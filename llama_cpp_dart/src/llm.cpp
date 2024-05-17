#include "./llm.h"
#include "./llama.cpp/common/common.h"
#include <cassert>
#include <cinttypes>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <ctime>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <unordered_set>
#include <thread>
#include <atomic>
#include <mutex>

static std::atomic_bool stop_generation(false);
static std::mutex continue_mutex;

static llama_model *model;
static llama_context *ctx;
static llama_context *ctx_guidance;
static llama_sampling_context *ctx_sampling;

static int32_t n_ctx;
static llama_batch batch;

static gpt_params params;

static dart_logger *dart_logger_callback;
static char *chat_template;
std::map<std::string, std::vector<std::string>> antiprompt_map = {
    {"chatml",
     {"<|im_start|>", "<|im_end|>"}},
    {"llama3",
     {"<|start_header_id|>", "<|eot_id|>", "<|end_header_id|>"}},
    {"zephyr",
     {"<|user|>", "<|assistant|>"}},
    {"phi3",
     {"<|user|>", "<|end|>", "<|assistant|>"}},
};

bool add_bos_token = true;

void dart_log_callback(ggml_log_level level, const char *text, void *user_data)
{
    dart_logger_callback(text);
}

static bool has_stop_string(gpt_params &params, std::string &last_output)
{

  for (std::string &antiprompt : params.antiprompt)
  {
    size_t extra_padding = 0;
    size_t search_start_pos = last_output.length() > static_cast<size_t>(antiprompt.length() + extra_padding)
                                  ? last_output.length() - static_cast<size_t>(antiprompt.length() + extra_padding)
                                  : 0;
    if (last_output.find(antiprompt, search_start_pos) != std::string::npos)
    {
      return true;
    }
  }
  return false;
}

int llm_init(int argc, char **argv, dart_logger *log_output)
{
  if (!gpt_params_parse(argc, argv, params))
  {
    return 1;
  }
  log_output("llm_log_init\n");
  LOG_TEE("llm_init: %s\n", "gpt_params_parsed");
  if (log_output != nullptr)
  {
    dart_logger_callback = log_output;
    // flutter debug will with error: ArgumentError (Invalid argument(s): argument value for 'return_value' is null)
    // llama_log_set(dart_log_callback, nullptr);
  }
  llama_backend_init();
  llama_numa_init(params.numa);
  std::tie(model, ctx) = llama_init_from_gpt_params(params);
  if (!model)
  {
    return 1;
  }
  if (!ctx)
  {
    llama_free_model(model);
    return 1;
  }
  add_bos_token = llama_should_add_bos_token(model);
  ctx_sampling = llama_sampling_init(params.sparams);
  n_ctx = llama_n_ctx(ctx);
  batch = llama_batch_init(n_ctx, 0, params.n_parallel);

  if (params.antiprompt.size() == 0 && antiprompt_map.count(chat_template) > 0)
  {
    params.antiprompt = antiprompt_map[chat_template];
  }
  return 0;
}

int llm_completion(const char *prompt, dart_output *output)
{
  stop_generation.store(false);
  llama_sampling_free(ctx_sampling);
  ctx_sampling = llama_sampling_init(params.sparams);
  llama_kv_cache_clear(ctx); // i think that's necessary
  std::string prompt_string = std::string(prompt);
  std::vector<llama_token> tokens_list = ::llama_tokenize(ctx, prompt_string, add_bos_token, true);

  for (size_t i = 0; i < tokens_list.size(); i++)
  {
    llama_batch_add(batch, tokens_list[i], i, {0}, false);
  }
  // llama_decode will output logits only for the last token of the prompt
  batch.logits[batch.n_tokens - 1] = true;

  for (int32_t i = 1; i < params.n_parallel; ++i)
  {
    llama_kv_cache_seq_cp(ctx, 0, i, -1, -1);
  }

  int n_cur = batch.n_tokens;

  while (!stop_generation)
  {
    if (stop_generation.load())
    {
      stop_generation.store(false);
      output("", true);
      return 0;
    }

    if (llama_decode(ctx, batch) != 0)
    {
      LOG_TEE("%s: llama_decode() failed\n", __func__);
      return 1;
    }
    const llama_token new_token_id = llama_sampling_sample(ctx_sampling, ctx, ctx_guidance, batch.n_tokens - 1);
    llama_sampling_accept(ctx_sampling, ctx, new_token_id, true);
    std::string text = std::string(llama_token_get_text(model, new_token_id));
    // is it an end of stream?
    bool is_antiprompt = has_stop_string(params, text);
    if (is_antiprompt || llama_token_is_eog(model, new_token_id))
    {
      stop_generation.store(false);
      output("", true);
      break;
    }
    // callback
    std::string token_str = llama_token_to_piece(ctx, new_token_id);
    output(token_str.c_str(), false);
    llama_batch_clear(batch);
    llama_batch_add(batch, new_token_id, n_cur, {0}, true);

    n_cur += 1;
  }

  return 0;
}

inline std::string format_chat(struct llama_chat_message *chat[], size_t length)
{
  size_t alloc_size = 0;
  std::vector<llama_chat_message> chatList(length);
  for (size_t i = 0; i < length; i++)
  {
    chatList[i] = *chat[i];
    alloc_size += strlen(chat[i]->content);
  }
  std::vector<char> buf(alloc_size * 2);
  int32_t res = llama_chat_apply_template(model, chat_template, chatList.data(), chatList.size(), true, buf.data(), buf.size());
  if (res < 0)
  {
    std::string input_prefix = params.input_prefix;
    std::string input_suffix = params.input_suffix;
    return "";
  }
  if ((size_t)res > buf.size())
  {
    buf.resize(res);
    res = llama_chat_apply_template(model, chat_template, chatList.data(), chatList.size(), true, buf.data(), buf.size());
  }
  std::string formatted_chat(buf.data(), res);
  return formatted_chat;
}

int llm_chat(struct llama_chat_message *chat[], size_t length, dart_output *output)
{
  std::string prompt = format_chat(chat, length);
  LOG_TEE("llm_chat: %s\n", prompt.c_str());
  return llm_completion(prompt.c_str(), output);
}

void set_chat_template(const char *template_str)
{
  chat_template = strdup(template_str);
}

void llm_stop(void)
{
  stop_generation.store(true);
}

void llm_cleanup(void)
{
  chat_template = nullptr;
  stop_generation.store(true);
  llama_kv_cache_clear(ctx);
  llama_free(ctx);
  if (ctx_guidance)
  {
    llama_free(ctx_guidance);
  }
  llama_free_model(model);
  llama_batch_free(batch);
  llama_sampling_free(ctx_sampling);
  llama_backend_free();
}

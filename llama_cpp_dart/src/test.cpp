#include "./llm.h"

#include <vector>
#include <cstring>

void print(const char *buffer, bool stop)
{
  if (stop)
  {
    printf("\nstop: %s\n", buffer);
  }
  else
  {
    printf("%s", buffer);
  }
}
int main()
{
  std::vector<const char *> argv = {
      "llm",
      "--model",
      "/Users/mizy/projects/llama-cpp-gpt-api/models/lmstudio-ai/gemma-2b-it-GGUF/gemma-2b-it-q8_0.gguf",
      "--prompt",
      "Hello"};

  // Convert vector to raw array
  std::vector<char *> cargv;
  for (const auto &arg : argv)
  {
    cargv.push_back(strdup(arg));
  }

  // Call llm_init
  int result = llm_init(cargv.size(), cargv.data(), nullptr);

  // typedef void dart_output(const char *buffer, bool stop);
  //   llm_completion(R"(<start_of_turn>user
  // hello!<end_of_turn>
  // <start_of_turn>model)",
  //                  print);
  std::vector<llama_chat_message *> messages;
  llama_chat_message message = llama_chat_message{.content = "Hello", .role = "user"};
  messages.push_back(&message);

  llm_chat(messages.data(), messages.size(), print);

  llm_cleanup();

  // Free duplicated strings
  for (auto &arg : cargv)
  {
    free(arg);
  }

  return result;
}

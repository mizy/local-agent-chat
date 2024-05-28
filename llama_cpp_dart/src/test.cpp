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
      "/Users/mizy/projects/ggufs/Phi-3-mini-4k-instruct-q4.gguf",
      "--ctx-size",
      "512",
  };
  // Convert vector to raw array
  std::vector<char *>
      cargv;
  for (const auto &arg : argv)
  {
    cargv.push_back(strdup(arg));
  }

  // Call llm_init
  set_chat_template("phi3");
  int result = llm_init(cargv.size(), cargv.data(), nullptr);
  //   char *chat_text = R"(provide a title of below conversation, return the title directly:
  // system: You are a helpful assistant
  // asistant: hi, how can I help you?
  // user: hello)";

  //   typedef void dart_output(const char *buffer, bool stop);
  //   llm_completion(R"(<|im_start|>user
  // provide a title of below conversation, return the title directly:
  // system: You are a helpful assistant
  // asistant: hi, how can I help you?
  // user: hello
  // <|im_end|>
  // <|im_start|>assistant)",
  //                  print);
  std::vector<llama_chat_message *> messages;
  llama_chat_message message = llama_chat_message{.content = "hi", .role = "user"};
  llama_chat_message botMessage = llama_chat_message{.content = "hi, how can I help you?", .role = "asistant"};
  messages.push_back(&botMessage);
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

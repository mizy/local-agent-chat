
#ifdef LLAMA_SHARED
#if defined(_WIN32) && !defined(__MINGW32__)
#ifdef LLAMA_BUILD
#define LLAMA_API __declspec(dllexport)
#else
#define LLAMA_API __declspec(dllimport)
#endif
#else
#define LLAMA_API __attribute__((visibility("default")))
#endif
#else
#define LLAMA_API
#endif

#ifdef __cplusplus
extern "C"
{
#endif

#include "./llama.cpp/llama.h"
#include <stdbool.h>
#include <stddef.h>

  typedef int dart_logger(const char *buffer);

  typedef void dart_output(const char *buffer, bool stop);

  LLAMA_API int llm_init(int argc, char **argv, dart_logger *log_output);

  LLAMA_API int llm_completion(const char *prompt, dart_output *output);

  LLAMA_API int llm_chat(struct llama_chat_message *chat[], size_t length, dart_output *output);

  LLAMA_API void llm_stop(void);

  LLAMA_API void llm_cleanup(void);

  LLAMA_API void set_chat_template(const char *template_str);

#ifdef __cplusplus
}
#endif

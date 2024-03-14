/// An enumeration representing different types of LLM Prompt Formats.
enum PromptFormatType { raw, chatml, alpaca }

/// A class representing a LLM Prompt Format.
abstract class PromptFormat {
  final PromptFormatType type;
  final String inputSequence;
  final String outputSequence;
  final String systemSequence;
  final String? stopSequence;

  PromptFormat(this.type,
      {required this.inputSequence,
      required this.outputSequence,
      required this.systemSequence,
      this.stopSequence});

  String formatPrompt(String prompt) {
    if (stopSequence != null) {
      return '$inputSequence$prompt$stopSequence$outputSequence';
    }
    return '$inputSequence$prompt$outputSequence';
  }

  String formatMessages(List<Map<String, dynamic>> messages) {
    String formattedMessages = '';
    for (var message in messages) {
      if (message['role'] == 'user') {
        formattedMessages += '$inputSequence${message['content']}';
      } else if (message['role'] == 'assistant') {
        formattedMessages += '$outputSequence${message['content']}';
      } else if (message['role'] == 'system') {
        formattedMessages += '$systemSequence${message['content']}';
      }

      if (stopSequence != null) {
        formattedMessages += stopSequence!;
      }
    }
    return formattedMessages;
  }
}

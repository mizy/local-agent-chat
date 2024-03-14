import './prompt_format.dart';

class GemmaFormat extends PromptFormat {
  GemmaFormat()
      : super(PromptFormatType.chatml,
            inputSequence: '<start_of_turn>user\n',
            outputSequence: '<start_of_turn>model',
            systemSequence: '',
            stopSequence: '<end_of_turn>');
}

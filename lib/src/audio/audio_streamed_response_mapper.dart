import 'package:flutter_azure_tts/src/audio/audio_streamed_responses.dart';
import 'package:flutter_azure_tts/src/common/base_streamed_response.dart';
import 'package:flutter_azure_tts/src/common/base_streamed_response_mapper.dart';
import 'package:http/http.dart' as http;

class AudioStreamedResponseMapper extends BaseStreamedResponseMapper {
  @override
  Future<BaseStreamedResponse> map(http.StreamedResponse response) async {
    switch (response.statusCode) {
      case 200:
        return AudioSuccess(audio: await response.stream);
      case 400:
        return AudioFailedBadRequest(reasonPhrase: response.reasonPhrase);
      case 401:
        return AudioFailedUnauthorized();
      case 415:
        return AudioFailedUnsupported();
      case 429:
        return AudioFailedTooManyRequest();
      case 502:
        return AudioFailedBadGateway();
      default:
        return AudioFailedUnkownError(
            code: response.statusCode,
            reason: response.reasonPhrase ?? "unknown");
    }
  }
}

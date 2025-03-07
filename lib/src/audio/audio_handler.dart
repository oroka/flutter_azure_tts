import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:flutter_azure_tts/src/audio/audio_client.dart';
import 'package:flutter_azure_tts/src/audio/audio_request_param.dart';
import 'package:flutter_azure_tts/src/audio/audio_responses.dart' as unstreamed;
import 'package:flutter_azure_tts/src/audio/audio_streamed_responses.dart'
    as streamed;
import 'package:flutter_azure_tts/src/audio/audio_response_mapper.dart'
    as unstreamed;
import 'package:flutter_azure_tts/src/audio/audio_streamed_response_mapper.dart'
    as streamed;
import 'package:flutter_azure_tts/src/audio/audio_type_header.dart';
import 'package:flutter_azure_tts/src/auth/authentication_types.dart';
import 'package:flutter_azure_tts/src/common/config.dart';
import 'package:flutter_azure_tts/src/common/constants.dart';
import 'package:flutter_azure_tts/src/ssml/ssml.dart';
import 'package:http/http.dart' as http;

class AudioHandler {
  Future<unstreamed.AudioSuccess> getAudio(AudioRequestParams params) async {
    final mapper = unstreamed.AudioResponseMapper();
    final audioClient = AudioClient(
        client: http.Client(),
        authHeader: BearerAuthenticationHeader(token: Config.authToken!.token),
        audioTypeHeader: AudioTypeHeader(audioFormat: params.audioFormat));

    try {
      final ssml = Ssml(
        voice: params.voice,
        text: params.text,
        speed: params.rate ?? 1,
        style: params.style,
        role: params.role,
      );

      final response = await audioClient.post(Uri.parse(Endpoints.audio),
          body: ssml.buildSsml);
      final audioResponse = mapper.map(response);
      if (audioResponse is AudioSuccess) {
        return audioResponse;
      } else {
        throw audioResponse;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<streamed.AudioSuccess> getAudioStream(
      AudioRequestParams params) async {
    final mapper = streamed.AudioStreamedResponseMapper();
    final audioClient = AudioClient(
        client: http.Client(),
        authHeader: BearerAuthenticationHeader(token: Config.authToken!.token),
        audioTypeHeader: AudioTypeHeader(audioFormat: params.audioFormat));

    try {
      final ssml = Ssml(
        voice: params.voice,
        text: params.text,
        speed: params.rate ?? 1,
        style: params.style,
        role: params.role,
      );

      final response = await audioClient.postStream(Uri.parse(Endpoints.audio),
          body: ssml.buildSsml);
      final audioResponse = await mapper.map(response);
      if (audioResponse is streamed.AudioSuccess) {
        return audioResponse;
      } else {
        throw audioResponse;
      }
    } catch (e) {
      rethrow;
    }
  }
}

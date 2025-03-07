import 'dart:convert';

import 'package:flutter_azure_tts/src/audio/audio_type_header.dart';
import 'package:flutter_azure_tts/src/auth/authentication_types.dart';
import 'package:flutter_azure_tts/src/common/base_client.dart';
import 'package:http/http.dart' as http;

class AudioClient extends BaseClient {
  AudioClient(
      {required http.Client client,
      required BearerAuthenticationHeader authHeader,
      required AudioTypeHeader audioTypeHeader})
      : _audioTypeHeader = audioTypeHeader,
        super(client: client, header: authHeader);
  final AudioTypeHeader _audioTypeHeader;

  Future<http.StreamedResponse> postStream(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamedToStreamd('POST', url, headers, body, encoding);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[header.type] = header.value;
    request.headers[_audioTypeHeader.type] = _audioTypeHeader.value;
    request.headers['Content-Type'] = "application/ssml+xml";
    return client.send(request);
  }

  Future<http.StreamedResponse> _sendUnstreamedToStreamd(
      String method, Uri url, Map<String, String>? headers,
      [Object? body, Encoding? encoding]) async {
    var request = http.Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    return await send(request);
  }
}

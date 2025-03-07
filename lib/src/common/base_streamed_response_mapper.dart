import 'package:flutter_azure_tts/src/common/base_streamed_response.dart';
import 'package:http/http.dart' as http;

abstract class BaseStreamedResponseMapper {
  Future<BaseStreamedResponse> map(http.StreamedResponse response);
}

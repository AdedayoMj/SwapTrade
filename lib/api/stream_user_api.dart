import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:swap/api/stream_api.dart';

class StreamUserApi {
  static Future createUser({
    @required String idUser,
    @required String username,
    @required String urlImage,
  }) async {
    final token = StreamApi.client.devToken(idUser);

    final user = User(
      id: idUser,
      extraData: {
        'name': username,
        'image': urlImage,
      },
    );
    await StreamApi.client.setUser(user, token);
  }

  static Future login({@required String idUser}) async {
    final token = StreamApi.client.devToken(idUser);

    final user = User(id: idUser);
    await StreamApi.client.setUser(user, token);
  }
}

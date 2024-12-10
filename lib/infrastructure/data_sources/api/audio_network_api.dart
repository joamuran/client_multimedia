import 'dart:async';
import 'dart:convert';
import 'package:client_multimedia/domain/entities/track_details.dart';
import 'package:http/http.dart' as http;
import 'package:client_multimedia/domain/entities/track.dart';

/// Interactúa amb el servidor per obtenir informació de les pistes d'àudio de l'API REST d'aquest.
class AudioNetworkAPI {
  String
      baseURL; // Aquesta és la URL base, que es proporcionarà en el moment de la instanciació.

  /// Constructor
  AudioNetworkAPI(this.baseURL);

  /// Retorna la informació completa sobre una pista
  Future<TrackDetails?> getTrack(String id) async {
    final String url = '$baseURL/pistes/track/$id';

    // print("Obtenint::: $url");
    var data = await http.get(Uri.parse(url));
    if (data.statusCode == 200) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body);

      bodyJSON["trackinfo"]["url"] =
          "$baseURL/public/audio/${bodyJSON["trackinfo"]["id"]}";
      //print(bodyJSON.toString());
      return TrackDetails.fromJSON(bodyJSON["trackinfo"]);
    }
    return null;
  }

  /// Retorna informació simplificada sobre les pistes al servidor
  Future<List<Track>> getTrackList() async {
    String url = '$baseURL/pistes/simple';

    var data = await http.get(Uri.parse(url));

    if (data.statusCode == 200) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body);
      if (bodyJSON.isNotEmpty) {
        return (bodyJSON["tracks"] as List)
            .map((trackJSON) => Track.fromJSON(trackJSON))
            .toList();
      }
    }

    return [];
  }
}

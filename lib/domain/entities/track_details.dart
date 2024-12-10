import 'dart:typed_data';
import 'package:client_multimedia/domain/entities/track.dart';

/// Extensió de la classe [Track] incorporant informació addicional, com l'àlbum, la portada i la URL al fitxer.
class TrackDetails extends Track {
  String? album;
  Uint8List? cover;
  String? url;

  TrackDetails(
      {required super.id,
      super.title,
      super.artist,
      super.duration,
      this.album,
      this.cover,
      this.url});

  /// Constructor de factoria per crear la pista detallada a partir d'un JSON
  factory TrackDetails.fromJSON(dynamic json) {
    final Map<String, dynamic>? imageData = json["cover"]?.first['data'];
    final Uint8List? bytes = imageData != null
        ? Uint8List.fromList(imageData.values.toList().cast<int>())
        : null;
    return TrackDetails(
        id: json["id"],
        title: json["title"],
        artist: json["artist"],
        duration: json["duration"],
        url: json["url"],
        cover: bytes,
        album: json["album"]);
  }
  @override
  String toString() {
    return ("""
Id: ${super.id}
Title: ${super.title}
Autor: ${super.artist}
Album:"$album
URL: $url
Durada: ${super.duration}""");
  }
}

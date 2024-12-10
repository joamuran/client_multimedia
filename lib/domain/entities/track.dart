/// Representa una pista d'àudio amb la informació bàsica.
class Track {
  String id; // ID: Nom del fitxer
  String? title; // títol de la pista
  String? artist; // Artista
  double? duration; // Durada

  Track({required this.id, this.title, this.artist, this.duration});

  /// Constructor de factoria per crear la pista a partir d'un JSON
  factory Track.fromJSON(dynamic json) {
    return Track(
        id: json["id"],
        title: json["title"],
        artist: json["artist"],
        duration: json["duration"]);
  }
}

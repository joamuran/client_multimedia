import 'package:client_multimedia/domain/entities/track.dart';
import 'package:client_multimedia/domain/entities/track_details.dart';

/// Repositori per accedir a les pistes d'àudio.
/// S'implementa com a classe abstracta per tal d'incorporar diferents implementacions.
abstract class TrackRepository {
  Future<TrackDetails?> getTrack(String id);
  Future<List<Track>> getTrackList();
}

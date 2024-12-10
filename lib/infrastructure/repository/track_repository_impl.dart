import 'package:client_multimedia/domain/entities/track.dart';
import 'package:client_multimedia/domain/entities/track_details.dart';
import 'package:client_multimedia/domain/repository/track_repository.dart';

import 'package:client_multimedia/infrastructure/data_sources/api/audio_network_api.dart';

/// Implementació del repositori de pistes utilitzant l'API REST del servidor.
class TrackRepositoryImpl implements TrackRepository {
  final AudioNetworkAPI _audioAPI;

  TrackRepositoryImpl(this._audioAPI);

  @override
  Future<TrackDetails?> getTrack(String id) {
    return _audioAPI.getTrack(id);
  }

  @override
  Future<List<Track>> getTrackList() {
    return _audioAPI.getTrackList();
  }
}

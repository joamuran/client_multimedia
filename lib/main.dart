import 'package:client_multimedia/infrastructure/data_sources/api/audio_network_api.dart';
import 'package:client_multimedia/domain/domain.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/audio_player_screen.dart';

/// Inici de l'aplicació
/// Inicialitzem el repositori amb l'API d'accés a dades i el proporcionem a la capa de presentació.
void main() {
  // Inicialització de l'API d'accés a les dades des de la xarxa
  final audioAPI = AudioNetworkAPI("http://10.0.2.2:3000");
  // Inicialització del repositori amb l'API
  final trackRepository = TrackRepositoryImpl(audioAPI);

  // I llancem l'aplicació amb el repositori
  runApp(AudioPlayerScreen(repository: trackRepository));
}

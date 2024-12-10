import 'package:client_multimedia/domain/domain.dart';
import 'package:client_multimedia/presentation/themes/app_theme.dart';
import 'package:client_multimedia/presentation/widgets/track_details_view.dart';
import 'package:client_multimedia/presentation/widgets/trackitem.dart';
import 'package:flutter/material.dart';

/// Finestra principal de l'aplicació
class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({required this.repository, super.key});

  // Repositori al què accedirem per obtenir les pistes
  // Representa una capa d'abstracció entre la vista/presentació i l'accés a les dades
  final TrackRepository repository;

  /// Estat de la finestra principal
  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with AutomaticKeepAliveClientMixin {
  /// Llsta amb les pistes d'audio
  List<Track> items = [];

  /// Pista actualment en reproduccio
  TrackDetails? currentPlaying;

  @override
  initState() {
    super.initState();

    loadTrackList(); // Fem ús d'aquesta funció perquè no podem declarar initState com async.
  }

  Future<void> loadTrackList() async {
    // Carrega la llista de pistes des del repositori, de manera síncrona i actualitza l'estat
    List<Track> tracks = await widget.repository.getTrackList();

    setState(() {
      items = tracks;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // This call is necessary.
    return MaterialApp(
      title: 'Just an AudioPlayer',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: SafeArea(
        // Widget SafeArea: https://www.youtube.com/watch?v=1OPDUhgrI24
        child: Scaffold(
          body: RefreshIndicator(
            // RefreshIndicator: Widget per controlar el gest
            //d'arrossegar el dit cap avall en la llista per refrescar-la.
            onRefresh: loadTrackList,
            child: Center(
              // amb MediaQuery podem veure si l'orientació és en horitzontal
              // o vertical, de manera que segons siga una o altra, podem
              // mostrar la interfície d'una o altra manera.
              child: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Column(
                      children: [
                        TrackDetailsView(currentPlaying: currentPlaying),
                        createTrackList(),
                      ],
                    )
                  : Row(
                      children: [
                        TrackDetailsView(currentPlaying: currentPlaying),
                        createTrackList(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded createTrackList() {
    // Justificació de l'ús de l'Expanded: // https://stackoverflow.com/questions/45669202/how-to-add-a-listview-to-a-column-in-flutter
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          // Convertim duration en mm:ss
          int minuts = ((items[index].duration ?? 0) / 60).floor();
          int segons = (items[index].duration ?? 0).round() - (minuts * 60);

          return TrackItem(
            title: items[index].title ?? "",
            author: items[index].artist ?? "",
            duration: "$minuts:$segons",
            onSelect: () async {
              print("Clicked");
              TrackDetails? track =
                  await widget.repository.getTrack(items[index].id);
              setState(() {
                currentPlaying = track;
              });
            },
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

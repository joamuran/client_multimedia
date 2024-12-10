import 'package:audioplayers/audioplayers.dart';
import 'package:client_multimedia/domain/entities/track_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Mostra els detalls de la pista en execució i els controls d'àudio
class TrackDetailsView extends StatefulWidget {
  const TrackDetailsView({super.key, required this.currentPlaying});

  final TrackDetails? currentPlaying;

  @override
  State<TrackDetailsView> createState() => _TrackDetailsViewState();
}

class _TrackDetailsViewState extends State<TrackDetailsView> {
  // Creem el player
  final player = AudioPlayer();

  // Inicialització
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Configura la durada total de l'àudio. Quan carreguem la pista
    // es llançarà aquest event, de manera que sapiguem què dura l'áudio.
    player.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        // 'mounted' serveix per vore si el widget està a l'arbre de ginys o no
        // Si intentem actualitzar l'estat i no està muntat dóna una excepció
        setState(() {
          totalDuration = duration;
        });
      }
    });

    // Actualitza la posició actual de reproducció:
    // Quan la posició de reproducció canvie, es canviarà la posició actual
    // de l'estat de manera que s'actualitze automàticament l'slider.
    player.onPositionChanged.listen((Duration position) {
      if (mounted) {
        // 'mounted' serveix per vore si el widget està a l'arbre de ginys o no
        // Si intentem actualitzar l'estat i no està muntat dóna una excepció
        setState(() {
          currentPosition = position;
        });
      }
    });

    // Escolta canvis d'estat de reproducció i actualitza la variable
    // isPlaying: Quan hi ha un canvi d'estat, es dispara aquest callback.
    // Si l'state que es res és "playing", isplaying serà true, i en cas
    // contrari, serà false.
    player.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        // 'mounted' serveix per vore si el widget està a l'arbre de ginys o no
        // Si intentem actualitzar l'estat i no està muntat dóna una excepció
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    player.dispose(); // Allibera els recursos quan el widget es destrueix
    super.dispose();
  }

  void playAudio() async {
    await player.play(UrlSource(widget.currentPlaying?.url ?? ""));
  }

  void pauseAudio() async {
    await player.pause();
  }

  void stopAudio() async {
    await player.stop();
  }

  @override
  Widget build(BuildContext context) {
    double widgetWidth = MediaQuery.of(context).size.width;
    double widgetHeight = MediaQuery.of(context).size.height;

    // Definim la grandària de la imatge segons l'orientació
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      widgetHeight = widgetHeight / 2;
    } else {
      widgetWidth = widgetWidth / 2;
      widgetHeight = widgetHeight - 160;
    }

    return Column(
      children: [
        Stack(children: [
          SizedBox(
            width: widgetWidth,
            height: widgetHeight,
            child: widget.currentPlaying?.cover != null
                ? Image(
                    image: MemoryImage(widget.currentPlaying!.cover!),
                    fit: BoxFit.cover,
                  )
                : SvgPicture.asset(
                    // Per incloure SVGs com a imatges utilitzem la llibreria flutter_svg
                    "assets/icons/equalizer-music-multimedia-svgrepo-com.svg",
                    fit: BoxFit.scaleDown,
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100, // Alçada del requadre
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent
                  ], // Degradat de negre a transparent
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alignar els textos a l'esquerra
                children: [
                  Text(widget.currentPlaying?.title ?? "",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    widget.currentPlaying?.artist ?? "",
                    textAlign: TextAlign.left,
                  ),
                ]),
          ),
        ]),
        SizedBox(
          width: widgetWidth,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 0.0, // Radi del thumb
              ),
            ),
            child: Slider(
              // Component de tipus Slider: https://api.flutter.dev/flutter/material/Slider-class.html
              thumbColor: Colors.purple,
              min: 0,
              max: totalDuration.inSeconds.toDouble(),
              value: currentPosition.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await player.seek(position);
              },
            ),
          ),
        ),
        SizedBox(
          width: widgetWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDuration(currentPosition)),
                Text(formatDuration(totalDuration)),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: isPlaying ? pauseAudio : playAudio,
              iconSize: 48,
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: stopAudio,
              iconSize: 48,
            ),
          ],
        ),
      ],
    );
  }

  // Mètode auxiliar per mostrar la durada
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

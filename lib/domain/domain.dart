/// Llibreria `domain`
///
/// Conté les entitats, casos d'ús i interfícies del repositori del domini.
/// L'objectiu de la capa és representar conceptes centrals del sistema de manera agnòstica de les fonts de dades (APIs, bases de dades, etc.).
///
/// Les entitats són objectes Dart que representen la base dels models de l'aplicació.
/// Els casos d'ús contenen ls lògica i les regles de negoci específiques de l'aplicació.
/// Els repositoris contenen la interfície per interactuar amb les dades.
///
/// En aquesta aplicació implementem les entitats i un repositori que farà de pont entre la interfície i la representació de les dades.

library domain;

export 'entities/entities.dart';
export 'repository/track_repository.dart';
export '../infrastructure/repository/track_repository_impl.dart';

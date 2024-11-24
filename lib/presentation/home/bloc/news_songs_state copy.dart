import 'package:spotify/domain/entities/song/song.dart';

abstract class NewSongsState {}

class NewsSongsLoading extends NewSongsState {}

class NewsSongsLoaded extends NewSongsState {
  final List<SongEntity> songs;
  NewsSongsLoaded({required this.songs});
}

class NewsSongsLoadFailure extends NewSongsState {}

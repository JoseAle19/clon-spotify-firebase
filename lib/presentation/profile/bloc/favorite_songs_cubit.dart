import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/get_favorite_songs.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:spotify/service_locator.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit() : super(FavoriteSongsLoading());

  Future<void> getFavoriteSongs() async {
    var res = await sl<GetFavoriteSongsUseCase>().call();
    List<SongEntity> favoriteSongs;
    res.fold((l) {
      emit(FavoriteSongsFailure());
    }, (songs) {
      favoriteSongs = songs;
      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    });
  }
}

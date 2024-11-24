import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify/domain/usecases/song/get_new_songs.dart';
import 'package:spotify/presentation/home/bloc/news_songs_state%20copy.dart';
import 'package:spotify/service_locator.dart';

class NewSongsCubit extends Cubit<NewSongsState> {
  NewSongsCubit() : super(NewsSongsLoading());

  Future<void> getNewSongs() async {
    final returned = await sl<GetNewSongsUseCase>().call();

    returned.fold((l) {
      emit(NewsSongsLoadFailure());
    }, (r) {
      emit(NewsSongsLoaded(songs: r));
    });
  }
}

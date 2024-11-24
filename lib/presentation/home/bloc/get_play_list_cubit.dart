import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify/domain/usecases/song/get_playl_list.dart';
import 'package:spotify/presentation/home/bloc/get_play_list_state.dart';
import 'package:spotify/service_locator.dart';

class PlayListCubit extends Cubit<PlayListState> {
  PlayListCubit() : super(PlayListLoading());

  Future<void> getPlayList() async {
    final returned = await sl<GetPlaylListUseCase>().call();

    returned.fold((l) {
      emit(PlayListLoadFailure());
    }, (r) {
      emit(PlayListLoaded(songs: r));
    });
  }
}

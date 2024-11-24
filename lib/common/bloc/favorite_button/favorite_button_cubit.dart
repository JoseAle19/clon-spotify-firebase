import 'package:dartz/dartz.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favotite_button_state.dart';
import 'package:spotify/domain/usecases/song/add_removve_favorite_song.dart';
import 'package:spotify/service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  void favoriteButtonUpdated(String songId) async {
    final res = await sl<AddRemoveFavoriteSongUseCase>().call(params: songId);
    res.fold((l) {
      left(l);
    }, (isFavorite) {
      emit(FavoriteButtonUpdated(isFavorite: isFavorite));
    });
  }
}

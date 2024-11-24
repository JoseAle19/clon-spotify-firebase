import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repositories/song/song.dart';
import 'package:spotify/service_locator.dart';

class GetFavoriteSongsUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<SongsRepository>().getFavoriteSongs();
  }
}
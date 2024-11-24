import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/domain/repositories/auth/auth.dart';
import 'package:spotify/service_locator.dart';

class SigninUseCase implements Usecase<Either, SignInUserRequest> {
  @override
  Future<Either> call({SignInUserRequest? params}) async {
    return await sl<AuthRepository>().signin(params!);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/models/auth/user.dart';
import 'package:spotify/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SignInUserRequest userReq);
  Future<Either> signup(CreateUserRequest userReq);
  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SignInUserRequest userReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userReq.email, password: userReq.password);

      return const Right('Signin was successfull');
    } on FirebaseAuthException catch (e) {
      print('mensaje de firebase ${e.code}');
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Correo o contraseña incorrectos.';
      } else if (e.code == 'invalid-credential') {
        message = 'Correo o contraseña incorrectos.';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserRequest userReq) async {
    try {
      final data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userReq.email, password: userReq.password);

      FirebaseFirestore.instance
          .collection('Users')
          .doc(data.user!.uid)
          .set({'name': userReq.fullname, 'email': data.user!.email});

      return const Right('Signup was successfull');
    } on FirebaseAuthException catch (e) {
      print('mensaje de firebase ${e.code}');
      String message = '';
      if (e.code == 'weak-password') {
        message = 'La contraseña es demaciado debil';
      } else if (e.code == 'email-already-in-use') {
        message = 'Hay una cuenta con este correo.';
      } else if (e.code == 'invalid-email') {
        message = 'Correo no valido';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore
          .collection('Users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      UserModel userModel = UserModel.fromJson(user.data()!);
      userModel.imageUrl =
          firebaseAuth.currentUser?.photoURL ?? AppUrls.imageProfile;
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return Left('An error ocurred');
    }
  }
}

import 'package:spotify/domain/entities/auth/user.dart';

class UserModel {
  String? userName;
  String? email;
  String? imageUrl;
  UserModel(this.userName, this.email, this.imageUrl);

  UserModel.fromJson(Map<String, dynamic> data) {
    userName = data['name'];
    email = data['email'];
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(email: email, imageUrl: imageUrl, userName: userName);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';
import 'package:spotify/presentation/auth/pages/singn_in.dart';
import 'package:spotify/presentation/home/pages/home.dart';
import 'package:spotify/service_locator.dart';

class Registerpage extends StatelessWidget {
  Registerpage({super.key});
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _singnInText(context),
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 30,
          width: 30,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _registerText(),
            const SizedBox(
              height: 20,
            ),
            _fullNameField(context),
            const SizedBox(
              height: 20,
            ),
            _emaildField(context),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 20,
            ),
            BasicAppButton(
                onPressed: () async {
                  var res = await sl<SignupUseCase>().call(
                      params: CreateUserRequest(_fullName.text.toString(),
                          _email.text.toString(), _password.text.toString()));
                  res.fold((l) {
                    print(' Mensaje  $l');
                    var snackbar = SnackBar(content: Text(l.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }, (r) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);
                  });
                },
                title: 'Crear cuenta')
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Registro',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: const InputDecoration(hintText: 'Nombre de usuario')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _emaildField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(hintText: 'Correo electrónico')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(hintText: 'Contraseña')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _singnInText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Ya tienes cuenta?',
            style: TextStyle(
                color: Color(0xff383838), fontWeight: FontWeight.w500),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SingnInPage()));
              },
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                    color: Color(0xff288CE9), fontWeight: FontWeight.w500),
              ))
        ],
      ),
    );
  }
}

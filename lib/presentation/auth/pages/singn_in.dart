import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/domain/usecases/auth/sigin.dart';
import 'package:spotify/presentation/auth/pages/singup.dart';
import 'package:spotify/presentation/auth/pages/widgets/loading.dart';
import 'package:spotify/presentation/home/pages/home.dart';
import 'package:spotify/service_locator.dart';

// ignore: must_be_immutable
class SingnInPage extends StatefulWidget {
  SingnInPage({super.key});

  @override
  State<SingnInPage> createState() => _SingnInPageState();
}

class _SingnInPageState extends State<SingnInPage> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signupText(context),
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 30,
          width: 30,
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _registerText(),
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
                  setState(() {
                    isLoading = true;
                  });
                  final res = await sl<SigninUseCase>().call(
                      params: SignInUserRequest(_emailController.text.trim(),
                          _passwordController.text.trim()));
                  setState(() {
                    isLoading = false;
                  });

                  res.fold((l) {
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
                title: 'Iniciar sesion',
                height: 50,
              )
            ],
          ),
        ),
        isLoading
            ? Container(
                color: const Color.fromARGB(218, 48, 48, 48),
                child: const Center(
                  child: Loading(),
                ),
              )
            : const SizedBox.shrink(),
      ]),
    );
  }

  Widget _registerText() {
    return const Text(
      'Inicio',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      textAlign: TextAlign.center,
    );
  }

  Widget _emaildField(BuildContext context) {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(hintText: 'Correo electrónico')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      decoration: const InputDecoration(hintText: 'Contraseña')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signupText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Aun no tienes cuenta?',
            style: TextStyle(
                color: Color(0xff383838), fontWeight: FontWeight.w500),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Registerpage()));
              },
              child: const Text(
                'Registrarse',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500),
              ))
        ],
      ),
    );
  }
}

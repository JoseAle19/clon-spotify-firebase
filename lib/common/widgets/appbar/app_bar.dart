import 'package:flutter/material.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppBar(
      {super.key,
      this.title,
      this.enableLeading = true,
      this.action,
      this.background});
  final Widget? title;
  final Color? background;
  final Widget? action;
  final bool? enableLeading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [action ?? Container()],
      title: title,
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: background,
      leading: enableLeading == false
          ? null
          : IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

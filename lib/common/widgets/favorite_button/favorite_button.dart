import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/bloc/favorite_button/favotite_button_state.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;
  const FavoriteButton({required this.songEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteButtonCubit(),
      child: BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
        builder: (context, state) {
          if (state is FavoriteButtonInitial) {
            return GestureDetector(
              onTap: () {
                context
                    .read<FavoriteButtonCubit>()
                    .favoriteButtonUpdated(songEntity.songId);
              },
              child: Icon(
                songEntity.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_rounded,
                color: context.isDarkMode
                    ? AppColors.primary
                    : const Color(0xffE6E6E6),
              ),
            );
          }
          if (state is FavoriteButtonUpdated) {
            return GestureDetector(
              onTap: () {
                context
                    .read<FavoriteButtonCubit>()
                    .favoriteButtonUpdated(songEntity.songId);
              },
              child: Icon(
                state.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_rounded,
                color: context.isDarkMode
                    ? AppColors.primary
                    : const Color(0xffE6E6E6),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

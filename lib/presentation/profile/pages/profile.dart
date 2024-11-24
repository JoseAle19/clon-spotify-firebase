import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/domain/entities/auth/user.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        background: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
        title: const Text('Perfil'),
        action: const IconButton(
            onPressed: null, icon: Icon(Icons.more_vert_outlined)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileInfo(context),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Mis favoritos',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  FavoriteSongs()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
            color: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileInfoLoaded) {
              return ContentProfile(user: state.userEntity);
            }
            if (state is ProfileInfoFailure) {
              return const Center(
                child: Text('Intentalo de nuevo'),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ContentProfile extends StatelessWidget {
  const ContentProfile({super.key, this.user});
  final UserEntity? user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _profileImage(),
        const SizedBox(
          height: 10,
        ),
        Text(
          user?.email ?? 'Sin correo',
          style: TextStyle(
              fontSize: 12,
              color: context.isDarkMode
                  ? const Color(0xffD8D4D4)
                  : const Color(0xff222222)),
        ),
        Text(
          user?.userName ?? 'sin nombre',
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
              color: context.isDarkMode
                  ? const Color(0xffD8D4D4)
                  : const Color(0xff222222)),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(child: _followers(context))
      ],
    );
  }

  Widget _profileImage() {
    return Container(
      height: 120,
      width: 120,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage(AppImages.profileImage)),
          shape: BoxShape.circle,
          color: Colors.white),
    );
  }

  Widget _followers(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              '788',
              style: TextStyle(
                  color:
                      context.isDarkMode ? Colors.white : const Color(0xff2222),
                  fontFamily: 'Satoshi',
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
            Text(
              'Followers',
              style: TextStyle(
                  color: context.isDarkMode
                      ? const Color(0xff585858)
                      : const Color(0xffA1A1A1)),
            ),
          ],
        ),
        Column(
          children: [
            BlocProvider(
              create: (_) => FavoriteSongsCubit()..getFavoriteSongs(),
              child: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
                  builder: (context, state) {
                if (state is FavoriteSongsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FavoriteSongsLoaded) {
                  return Text(
                    state.favoriteSongs.length.toString(),
                    style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : const Color(0xff2222),
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  );
                }
                return const Center(
                  child: Text('Ocurrio un error'),
                );
              }),
            ),
            Text(
              'Favoritos',
              style: TextStyle(
                  color: context.isDarkMode
                      ? const Color(0xff585858)
                      : const Color(0xffA1A1A1)),
            ),
          ],
        )
      ],
    );
  }
}

class FavoriteSongs extends StatelessWidget {
  const FavoriteSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteSongsCubit()..getFavoriteSongs(),
      child: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
          builder: (context, state) {
        if (state is FavoriteSongsLoading) {
          // Si anda cargando la informacion
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FavoriteSongsLoaded) {
          // Lisar la informacion del state
          return _songs(state.favoriteSongs);
        }
        return Text('Ocurrio un error ${state.toString()}');
      }),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: songs.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        final music = songs[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 50,
              child: Image.network(
                  '${AppUrls.fireStorage}${songs[index].artist} - ${songs[index].title}.jpeg?${AppUrls.mediaAlt}'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toCapitalized(music.title),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(toCapitalized(music.artist),
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 12))
              ],
            ),
            Row(
              children: [
                Text(music.duration.toString().replaceAll('.', ':')),
                const SizedBox(
                  width: 20,
                ),
                FavoriteButton(songEntity: music)
              ],
            )
          ],
        );
      },
    );
  }

  String toCapitalized(String value) {
    final valueToCapitalized =
        '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
    return valueToCapitalized;
  }
}

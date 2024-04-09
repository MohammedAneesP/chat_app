part of 'profile_image_bloc.dart';

@immutable
sealed class ProfileImageState {}

final class ProfileImageInitial extends ProfileImageState {}

class LoadingImage extends ProfileImageState{}

class SetProfile extends ProfileImageState{
 final XFile? anImage;
  SetProfile({required this.anImage});
}

part of 'profile_image_bloc.dart';

@immutable
sealed class ProfileImageEvent {}

class TakePhoto extends ProfileImageEvent{}

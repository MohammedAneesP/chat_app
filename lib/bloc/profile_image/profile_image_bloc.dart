import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_image_event.dart';
part 'profile_image_state.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  ProfileImageBloc() : super(ProfileImageInitial()) {
    on<TakePhoto>(
      (event, emit) async {
        XFile? anImage =
            await ImagePicker().pickImage(source: ImageSource.camera);
        return emit(SetProfile(anImage: anImage));
      },
    );
  }
}

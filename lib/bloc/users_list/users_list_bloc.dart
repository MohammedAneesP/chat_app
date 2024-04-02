import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'users_list_event.dart';
part 'users_list_state.dart';

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  UsersListBloc() : super(UsersListInitial()) {
    on<GetAllUsers>((event, emit) async {
      emit(UsersLoading());
      final anData = await FirebaseFirestore.instance.collection("Users").get();
      if (anData.docs.isEmpty) {
        return emit(UsersAllList(allUsersList: const []));
      } else {
        final anValue = anData.docs;
        for (var element in anValue) {
          log(element["Email"]);
        }
        return emit(UsersAllList(allUsersList: anValue));
      }
    });
  }
}

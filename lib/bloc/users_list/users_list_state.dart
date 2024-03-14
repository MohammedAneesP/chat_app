part of 'users_list_bloc.dart';

@immutable
sealed class UsersListState {}

final class UsersListInitial extends UsersListState {}

class UsersLoading extends UsersListState {}

class UsersAllList extends UsersListState {
  final List<dynamic> allUsersList;
  UsersAllList({required this.allUsersList});
}

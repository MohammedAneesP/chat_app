import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ningal_chat/bloc/users_list/users_list_bloc.dart';
import 'package:ningal_chat/screens/chat_screen.dart/chat_page.dart';
import 'package:ningal_chat/screens/login_sign_up/login_page.dart';
import 'package:ningal_chat/services/authentication/auth_gate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UsersListBloc>(context).add(GetAllUsers());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await AuthFunctions(FirebaseAuth.instance)
                    .logout(context: context);
                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                }
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: BlocBuilder<UsersListBloc, UsersListState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case UsersLoading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case UsersAllList:
              final fetchUsers = state as UsersAllList;
              return ListView.separated(
                  itemBuilder: (context, index) {
                    if (fetchUsers.allUsersList[index]["Email"] !=
                        FirebaseAuth.instance.currentUser!.email) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                allowSnapshotting: false,
                                builder: (context) => ChatPage(
                                    anEmail: fetchUsers.allUsersList[index]
                                            ["Email"]
                                        .toString()),
                              ));
                        },
                        title: Text(
                            fetchUsers.allUsersList[index]["Email"].toString()),
                      );
                    } else {
                      return Container();
                    }
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: fetchUsers.allUsersList.length);
            default:
              return const Center(
                child: Text("No Other Users "),
              );
          }
        },
      ),
    );
  }
}

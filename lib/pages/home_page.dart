import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo_21/bloc/home_bloc.dart';
import 'package:ngdemo_21/bloc/home_event.dart';
import 'package:ngdemo_21/views/item_random_user.dart';

import '../bloc/home_state.dart';
import '../models/random_user_list_res.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;
  ScrollController scrollController = ScrollController();




  @override
  void initState() {
    super.initState();
    homeBloc=BlocProvider.of<HomeBloc>(context);
    homeBloc.add(LoadRandomUserListEvent());

    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent <= scrollController.offset){
        homeBloc.add(LoadRandomUserListEvent());

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Random Users - Bloc"),
      ),
      body:BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current){
          return current is HomeRandomUserListState;
        },
        builder: (context, state) {
          if (state is HomeErrorState) {
            return viewOfError(state.errorMessage);
          }

          if (state is HomeRandomUserListState) {
            var userList = state.userList;
            return viewOfRandomUserList(userList);
          }

          return viewOfLoading();
        },
      ),
    );
  }
  Widget viewOfError(String err) {
    return Center(
      child: Text("Error occurred $err"),
    );
  }

  Widget viewOfLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget viewOfRandomUserList(List<RandomUser> userList) {
    return ListView.builder(
      controller: scrollController,
      itemCount: userList.length,
      itemBuilder: (ctx, index) {
        return itemOfRandomUser(userList[index], index);
      },
    );
  }
}








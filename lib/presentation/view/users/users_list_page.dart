// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/data/users/user_model.dart';
import 'package:pick_departure_app/di/app_modules.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';
import 'package:pick_departure_app/presentation/model/resource_state.dart';
import 'package:pick_departure_app/presentation/navigation/navigation_routes.dart';
import 'package:pick_departure_app/presentation/view/authentication/viewmodel/user_viewmodel.dart';
import 'package:pick_departure_app/presentation/widget/custom_body_view.dart';
import 'package:pick_departure_app/presentation/widget/custom_list_view.dart';
import 'package:pick_departure_app/presentation/widget/error/error_view.dart';
import 'package:pick_departure_app/presentation/widget/loading/loading_overlay.dart';
import 'package:pick_departure_app/presentation/widget/user/user_row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage>
    with TickerProviderStateMixin {
  final UserViewModel _usersViewModel = inject<UserViewModel>();
  List<UserModel> _users = [];
  final ScrollController _scrollController = ScrollController();
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _usersViewModel.getUsersState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingOverlay.show(context);
          break;
        case Status.SUCCESS:
          LoadingOverlay.hide();
          setState(() {
            _users = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingOverlay.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _usersViewModel.fetchUsers();
          });
          break;
      }
    });

    _usersViewModel.fetchUsers();
  }

  @override
  void dispose() {
    _usersViewModel.dispose();
    animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme2.buildLightTheme().primaryColor,
          title: const Text("Users",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              )),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout_outlined,
                color: AppTheme2.buildLightTheme().secondaryHeaderColor,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool("isLoggedIn", false);
                context.pushReplacementNamed(NavigationRoutes.LOGIN_ROUTE);
              },
            ),
          ],
        ),
        body: CustomBodyView(
          scrollController: _scrollController,
          bodyChildWidget: Container(
            color: AppTheme2.buildLightTheme().colorScheme.background,
            child: ListView.builder(
              itemCount: _users.length,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (BuildContext context, int index) {
                final int count = _users.length > 10 ? 10 : _users.length;
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();
                return CustomListView(
                  callback: () {},
                  itemRow: UserRowItem(user: _users[index]),
                  animation: animation,
                  animationController: animationController,
                );
              },
            ),
          ),
        ));
  }
}

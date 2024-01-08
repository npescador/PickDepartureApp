import 'package:flutter/material.dart';
import 'package:pick_departure_app/presentation/constants/them2_constants.dart';

class CustomBodyListView extends StatelessWidget {
  const CustomBodyListView({
    super.key,
    required this.scrollController,
    required this.listWidget,
  });

  final ScrollController scrollController;
  final Widget listWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Theme(
          data: AppTheme2.buildLightTheme(),
          child: Stack(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: [
                    Expanded(
                      child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return [];
                        },
                        controller: scrollController,
                        body: Container(
                          color: AppTheme2.buildLightTheme()
                              .colorScheme
                              .background,
                          child: listWidget,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

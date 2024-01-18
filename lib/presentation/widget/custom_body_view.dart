import 'package:flutter/material.dart';
import 'package:pick_departure_app/presentation/constants/app_theme_constants.dart';

class CustomBodyView extends StatelessWidget {
  const CustomBodyView({
    super.key,
    required this.scrollController,
    required this.bodyChildWidget,
  });

  final ScrollController scrollController;
  final Widget bodyChildWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Theme(
          data: AppTheme.buildLightTheme(),
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
                          color:
                              AppTheme.buildLightTheme().colorScheme.background,
                          child: bodyChildWidget,
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

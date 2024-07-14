import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';

import 'flutter_icon_button.dart';
import 'mianddes_sidebar.dart';
import 'mianddes_theme.dart';
import 'mianddes_toolbar.dart';

class MiAnddesCommonPage extends StatefulWidget {
  final BuildContext? context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget content;
  final VoidCallback onTap;
  final String title;
  final IconData iconData;
  final bool showTitle;
  final bool canGoBack;
  final bool returnToActivityList;
  const MiAnddesCommonPage(
  {
        super.key,
        required this.context,
        required this.scaffoldKey,
        required this.content,
        required this.onTap,
        required this.title,
        required this.iconData,
        required this.showTitle,
        this.canGoBack = true,
        this.returnToActivityList = false
  });

  @override
  State<MiAnddesCommonPage> createState() => _MiAnddesCommonPageState();
}

class _MiAnddesCommonPageState extends State<MiAnddesCommonPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onTap(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: widget.scaffoldKey,
            backgroundColor: MiAnddesTheme.of(context).primaryBackground,
            drawer: MiAnddesSidebar(context: context),
            body: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: MiAnddesTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset("assets/images/background.png").image,
                  ),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  MiAnddesToolbar(
                    context: context,
                    scaffoldKey: widget.scaffoldKey,
                  ),
                  Padding(
                      padding:
                        const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 15.0),
                      child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.80,
                          constraints: const BoxConstraints(
                            maxWidth: 500.0,
                            maxHeight: double.infinity
                          ),
                          decoration: BoxDecoration(
                            color:
                                MiAnddesTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    widget.showTitle
                                        ? Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              FlutterIconButton(
                                                buttonSize: 40.0,
                                                icon: Icon(
                                                  widget
                                                      .iconData /*Icons.arrow_back*/,
                                                  color:
                                                      MiAnddesTheme.of(context)
                                                          .primaryText,
                                                  size: 24.0,
                                                ),
                                                onPressed: () {
                                                  if (widget.canGoBack) {
                                                    if(widget.returnToActivityList){
                                                      context.pushReplacementNamed('activity-list');
                                                    }else {
                                                      context.pop();
                                                    }
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 200,
                                              child:Text(
                                                widget.title,
                                                style: MiAnddesTheme.of(context)
                                                    .titleLarge
                                                    .override(
                                                      fontSize:22.0,
                                                      fontFamily: 'Rubik',
                                                      letterSpacing: 0.0,
                                                      lineHeight: 1.0,
                                                    ),
                                              )),
                                            ].divide(
                                                const SizedBox(width: 12.0)),
                                          )
                                        : const SizedBox(),
                                    Expanded(
                                        child: widget.content
                                    )
                                  ]))))
                ]))));
  }
}

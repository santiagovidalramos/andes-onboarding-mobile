import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_anddes_mobile_app/service/auth_service.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/service/service_service.dart';
import 'package:mi_anddes_mobile_app/service/tool_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/exception/unauthorized_exception.dart';
import 'package:mi_anddes_mobile_app/view/splash/splash_model.dart';

import '../../service/profile_service.dart';
import '../../utils/flutter_model.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  late SplashModel _model;
  late AuthService _authService;
  late ProfileService _userService;
  late ToolService _toolService;
  late ServiceService _serviceService;
  late OnboardingService _onboardingService;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashModel());

    _authService = AuthService();
    _userService = ProfileService();
    _toolService = ToolService();
    _serviceService = ServiceService();
    _onboardingService = OnboardingService();

    syncOnboardingInformation();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MiAnddesTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: MiAnddesTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/background.png',
              ).image,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  //context.pushNamed('login');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 300.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Center(
                child: SizedBox(
                  height: 80.0,
                  width: 80.0,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void syncOnboardingInformation() async {
    var accessToken = await _authService.getAccessToken();
    var screenToNavigate = "";
    var userGivenName = "";
    if (accessToken != null && accessToken.isValid()) {
      try {

        await _toolService.listRemote();
        await _userService.getRemote();
        await _serviceService.listRemote();

        var user = await _userService.get();
        if (user != null && user.onItinerary != null && user.onItinerary!) {
          userGivenName = user.givenName!;

          await _onboardingService.syncProcess(user.id!);
          var process = await _onboardingService.findProcess();
          if (process != null) {

            await _onboardingService.syncProcessActivity(user.id!, process.id);
            await _onboardingService.syncOnboarding(user.id!, process.id);
            await _onboardingService.sendPendingELearningContents();

            if (!process.welcomed!) {
              await _onboardingService.updateWelcomed(user.id!, process.id);
              screenToNavigate = "welcome-user";
            } else {
              screenToNavigate = "activity-list";
            }
          } else {
            screenToNavigate = "tools";
          }
        } else {
          screenToNavigate = "tools";
        }
      } on UnauthorizedException {
        log('UnauthorizedException');
        screenToNavigate = "login";
      }
    } else {
      screenToNavigate = "login";
    }
    await Future.delayed(const Duration(seconds: 2)).then((r) => {
          context.pushReplacementNamed(screenToNavigate,
              queryParameters: {'userGivenName': userGivenName})
        });
    //context.pushNamed(screenToNavigate);
  }
}

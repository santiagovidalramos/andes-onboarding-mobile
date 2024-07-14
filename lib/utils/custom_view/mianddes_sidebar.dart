import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/service/profile_service.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';

import 'flutter_custom_widgets.dart';
import 'mianddes_theme.dart';

class MiAnddesSidebar extends StatefulWidget {
  final BuildContext? context;
  const MiAnddesSidebar({super.key, required this.context});

  @override
  State<MiAnddesSidebar> createState() => _MiAnddesSidebarState();
}

class _MiAnddesSidebarState extends State<MiAnddesSidebar> {
  ProfileService userService = ProfileService();
  OnboardingService _onboardingService=OnboardingService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: MiAnddesTheme.of(context).primary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 64.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/logo-01.png',
                  width: double.infinity,
                  height: 76.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            FFButtonWidget(
              onPressed: () {
                context.pushNamed("services");
              },
              text: 'VIDA EN LA EMPRESA',
              options: FFButtonOptions(
                height: 40.0,
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: MiAnddesTheme.of(context).primary,
                textStyle: MiAnddesTheme.of(context).bodyMedium.override(
                      fontFamily: 'Rubik',
                      color: MiAnddesTheme.of(context).primaryBackground,
                      letterSpacing: 2.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            FFButtonWidget(
              onPressed: () {
                context.pushNamed("tools");
              },
              text: 'HERRAMIENTAS',
              options: FFButtonOptions(
                height: 40.0,
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: MiAnddesTheme.of(context).primary,
                textStyle: MiAnddesTheme.of(context).bodyMedium.override(
                      fontFamily: 'Rubik',
                      color: MiAnddesTheme.of(context).primaryBackground,
                      letterSpacing: 2.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            FutureBuilder(
              future: _onboardingService.findProcess(),
              builder: (context, userSnap) {
                if (!userSnap.hasData ||
                    (userSnap.data == null)) {
                  return const SizedBox();
                }
                return FFButtonWidget(
                  onPressed: () {
                    context.pushNamed("activity-list");
                  },
                  text: 'ONBOARDING',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: MiAnddesTheme.of(context).primary,
                    textStyle: MiAnddesTheme.of(context).bodyMedium.override(
                          fontFamily: 'Rubik',
                          color: MiAnddesTheme.of(context).primaryBackground,
                          letterSpacing: 2.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                );
              },
            ),
          ]
              .divide(const SizedBox(height: 32.0))
              .addToStart(const SizedBox(height: 48.0)),
        ),
      ),
    );
  }
}

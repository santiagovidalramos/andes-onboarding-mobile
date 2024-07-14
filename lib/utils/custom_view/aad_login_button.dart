import 'package:flutter/material.dart';

import '../../model/token.dart';
import 'aad_webview.dart';
import 'flutter_custom_widgets.dart';
import 'mianddes_theme.dart';
import '../optional_param.dart';

class AADLoginButton extends StatefulWidget {
  final Function(BuildContext context)? onRedirect;
  final BuildContext? context;
  final ValueChanged<Token> onAccessToken;
  final ValueChanged<Token> onIDToken;
  final ValueChanged<Token> onRefreshToken;
  final ValueChanged<Token>? onAnyTokenRetrieved;
  final bool useImage;
  final String? title;
  final TextStyle? style;
  final List<OptionalParam>? optionalParameters;
  const AADLoginButton({
    super.key,
    required this.context,
    required this.onAccessToken,
    required this.onIDToken,
    required this.onRefreshToken,
    this.onAnyTokenRetrieved,
    this.onRedirect,
    this.useImage = true,
    this.title,
    this.style,
    this.optionalParameters,
  });

  @override
  State<AADLoginButton> createState() => _AADLoginButtonState();
}

class _AADLoginButtonState extends State<AADLoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        /*onTap: () {
        Navigator.of(widget.context ?? context).push(
          MaterialPageRoute(
            builder: (context) {
              return ADB2CEmbedWebView(
                onRedirect: widget.onRedirect,
                onAnyTokenRetrieved: (value) {
                  if (widget.onAnyTokenRetrieved != null) {
                    widget.onAnyTokenRetrieved!(value);
                  }
                },
                onAccessToken: (accessToken) {
                  widget.onAccessToken(accessToken);
                },
                onIDToken: (idToken) {
                  widget.onIDToken(idToken);
                },
                onRefreshToken: (refreshToken) {
                  widget.onRefreshToken(refreshToken);
                },
                optionalParameters: widget.optionalParameters ?? [],
              );
            },
          ),
        );
      },*/
        child: FFButtonWidget(
      onPressed: () async {
        Navigator.of(widget.context ?? context).push(
          MaterialPageRoute(
            builder: (context) {
              return ADB2CEmbedWebView(
                onRedirect: widget.onRedirect,
                onAnyTokenRetrieved: (value) {
                  if (widget.onAnyTokenRetrieved != null) {
                    widget.onAnyTokenRetrieved!(value);
                  }
                },
                onAccessToken: (accessToken) {
                  widget.onAccessToken(accessToken);
                },
                onIDToken: (idToken) {
                  widget.onIDToken(idToken);
                },
                onRefreshToken: (refreshToken) {
                  widget.onRefreshToken(refreshToken);
                },
                optionalParameters: widget.optionalParameters ?? [],
              );
            },
          ),
        );
      },
      text: 'INGRESAR',
      options: FFButtonOptions(
        height: 56.0,
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: MiAnddesTheme.of(context).primary,
        textStyle: MiAnddesTheme.of(context).bodyLarge.override(
              fontFamily: 'Rubik',
              color: MiAnddesTheme.of(context).primaryBackground,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w500,
            ),
        elevation: 3.0,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
    )
        /*child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(
          6.0,
        ),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 36.0,
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.title ?? 'Login with Azure AD',
                    style: widget.style ?? GoogleFonts.nunito(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (widget.useImage)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/images/icons8-azure-48.png'
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),*/
        );
  }
}

import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/view/firstday_information_dialog/firstday_information_dialog_widget.dart';

import '../../utils/flutter_model.dart';

class FirstDayInformationDialogModel
    extends FlutterModel<FirstInformationDialogWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

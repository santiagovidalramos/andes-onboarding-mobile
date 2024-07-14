import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mi_anddes_mobile_app/model/service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_icon_button.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/service_dialog/services_dialog_model.dart';

class ServicesDialogWidget extends StatefulWidget {
  final List<ServiceDetail> detail;
  final String title;
  const ServicesDialogWidget(
      {super.key, required this.title, required this.detail});

  @override
  State<ServicesDialogWidget> createState() => _ServicesDialogWidgetState();
}

class _ServicesDialogWidgetState extends State<ServicesDialogWidget> {
  late ServicesDialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ServicesDialogModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Container(
            decoration: BoxDecoration(
              color: MiAnddesTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: ListView.separated(
                  itemCount: widget.detail.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Row(children: [
                        const SizedBox(width: 5.0),
                        Text(widget.title,
                            style: MiAnddesTheme.of(context).titleLarge),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: FlutterIconButton(
                            buttonSize: 40.0,
                            icon: Icon(
                              Icons.close,
                              color: MiAnddesTheme.of(context).secondary,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.pop();
                            },
                          ),
                        ))
                      ]);
                    }
                    index -= 1;
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                          side: BorderSide(
                              color: MiAnddesTheme.of(context).accent2)),
                      child: ExpansionTile(
                          title: Text(widget.detail[index].title!),
                          children: [
                            ListTile(
                                title: HtmlWidget(
                                    widget.detail[index].description!)),
                            const SizedBox(height: 12.0)
                          ]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ))));
  }
}

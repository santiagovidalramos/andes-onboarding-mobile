import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/model/first_day_information_item.dart';
import 'package:mi_anddes_mobile_app/model/service.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/service/service_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/firstday_information/firstday_information_model.dart';
import 'package:mi_anddes_mobile_app/view/firstday_information_dialog/firstday_information_dialog_widget.dart';
import 'package:mi_anddes_mobile_app/view/service_dialog/services_dialog_widget.dart';

import '../../utils/custom_view/mianddes_theme.dart';

class FirstdayInformationWidget extends StatefulWidget {
  const FirstdayInformationWidget({super.key});

  @override
  State<FirstdayInformationWidget> createState() =>
      _FirstdayInformationWidgetState();
}

class _FirstdayInformationWidgetState extends State<FirstdayInformationWidget> {
  late FirstdayInformationModel _model;
  late OnboardingService _onboardingService;
  late ServiceService _serviceService;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FirstdayInformationModel());
    _onboardingService = OnboardingService();
    _serviceService = ServiceService();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(
      title: 'Información para tu primer día',
      iconData: Icons.arrow_back,
      context: this.context,
      scaffoldKey: scaffoldKey,
      showTitle: true,
      returnToActivityList: true,
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      content: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.data == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return const Center(
                child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: CircularProgressIndicator(),
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              FirstDayInformationItem item = snapshot.data![index];
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        10.0, 5.0, 10.0, 16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MiAnddesTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: MiAnddesTheme.of(context).secondary,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                                width: double.infinity, height: 20.0),
                            Icon(
                              getIcon(item.icon!),
                              //IconData(int.parse(item.icon!),
                              //    fontFamily: 'MaterialIcons'),
                              //Icons.not_listed_location_outlined,
                              color: MiAnddesTheme.of(context).secondary,
                              size: 56.0,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  item.title!,
                                  style: MiAnddesTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Rubik',
                                        letterSpacing: 0.0,
                                      ),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Text(
                                  item.description!,
                                  textAlign: TextAlign.justify,
                                  style: MiAnddesTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Rubik',
                                        letterSpacing: 0.0,
                                      ),
                                )),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () async {
                                  Service officeService =
                                      Service(id: -1, name: '', details: []);
                                  var services = await _serviceService.list();
                                  if (item.addFromServices!) {
                                    officeService = services.first;
                                  }
                                  await showDialog(
                                    barrierColor: const Color(0x99424242),
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (dialogContext) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                        child: GestureDetector(
                                          onTap: () => _model
                                                  .unfocusNode.canRequestFocus
                                              ? FocusScope.of(context)
                                                  .requestFocus(
                                                      _model.unfocusNode)
                                              : FocusScope.of(context)
                                                  .unfocus(),
                                          child: SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.65,
                                            width: 500.0,
                                            child: !item.addFromServices!
                                                ? FirstInformationDialogWidget(
                                                    title: item.title!,
                                                    content: item.body!)
                                                : ServicesDialogWidget(
                                                    title: officeService.name!,
                                                    detail:
                                                        officeService.details!),
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => setState(() {}));
                                },
                                child: Text(
                                  'VER MÁS',
                                  style: MiAnddesTheme.of(context).titleSmall,
                                ),
                              ),
                            )
                          ]
                              .divide(const SizedBox(height: 16.0))
                              //.addToStart(const SizedBox(height: 2.0))
                              .addToEnd(const SizedBox(height: 14.0)),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
        future: _onboardingService.findFirstDayInformationItems(),
      ),
    );
  }
}

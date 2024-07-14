import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/model/onsite_induction.dart';
import 'package:mi_anddes_mobile_app/model/process.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/onsite_induction/onsite_induction_model.dart';

class OnsiteInductionWidget extends StatefulWidget {
  final String activityName;
  const OnsiteInductionWidget({super.key,required this.activityName});
  @override
  State<OnsiteInductionWidget> createState() => _OnsiteInductionWidgetState();
}

class _OnsiteInductionWidgetState extends State<OnsiteInductionWidget> {
  late OnsiteInductionModel _model;
  late OnboardingService _onboardingService;
  late Process _process;
  late ProcessActivity _processActivity;
  late OnsiteInduction _onsiteInduction;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnsiteInductionModel());
    _onboardingService = OnboardingService();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<bool> getData() async{
    var process = await _onboardingService.findProcess();
    var processActivity = await _onboardingService.findProcessActivityByCode(Constants.ACTIVITY_ON_SITE_INDUCTION);
    var onsiteInduction = await _onboardingService.findOnsiteInduction();

    if(process != null && processActivity != null && onsiteInduction != null){
      _process = process;
      _processActivity = processActivity;
      _onsiteInduction = onsiteInduction;
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(
      title: widget.activityName,
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
          if (snapshot.data == null || (snapshot.data != null && !snapshot.data!)) {
            //print('project snapshot data is: ${projectSnap.data}');
            return const Center(
                child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: CircularProgressIndicator(),
            ));
          }
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: MiAnddesTheme.of(context)
                              .secondary,
                          size: 24.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${dateTimeFormat('MMMMd',_process.startDate!,locale: 'es')}, ${_process.hourOnsite}',
                              style: MiAnddesTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Rubik',
                                letterSpacing: 0.0,
                              ),
                            ),
                            Text(
                              _process.placeOnsite!,
                              style: MiAnddesTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Rubik',
                                color: MiAnddesTheme.of(
                                    context)
                                    .success,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ].divide(const SizedBox(height: 4.0)),
                        ),
                      ].divide(const SizedBox(width: 12.0)),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MiAnddesTheme.of(context)
                            .primaryBackground,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¿Qué abordaremos?',
                              style: MiAnddesTheme.of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Rubik',
                                letterSpacing: 0.0,
                              ),
                            ),
                            Text(
                              _onsiteInduction.description!,
                              style: MiAnddesTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Rubik',
                                letterSpacing: 0.0,
                                lineHeight: 1.5,
                              ),
                            ),
                          ].divide(const SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 24.0)),
                ),
              ),
            ),
          );
        },
        future: getData(),
      ),
    );
  }
}

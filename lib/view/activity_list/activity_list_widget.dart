import 'dart:developer';

import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/view/welcome_ceo_video/welcome_ceo_video_widget.dart';

import 'package:flutter/material.dart';
import '../../model/process.dart';
import 'activity_list_model.dart';

class ActivityListWidget extends StatefulWidget {
  const ActivityListWidget({super.key});

  @override
  State<ActivityListWidget> createState() => _ActivityListWidgetState();
}

class _ActivityListWidgetState extends State<ActivityListWidget> {
  late ActivityListModel _model;
  late OnboardingService _onboardingService;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ProcessActivity _activityCEOPresentation;
  late ProcessActivity _activityCompleteProfile;
  late ProcessActivity _activityFirstDayInformation;
  late ProcessActivity _activityKnowTeam;
  late ProcessActivity _activityOnsiteInduction;
  late ProcessActivity _activityRemoteInduction;
  late ProcessActivity _activityELearningContent;
  late Process? _process;
  late int _processTotal;
  late int _processCompleted;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityListModel());
    _onboardingService = OnboardingService();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState((){}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<bool?> getActivity() async {
    _process = await _onboardingService.findProcess();
    List<ProcessActivity>? activities =
        await _onboardingService.findActivities();

    if (activities != null && activities.isNotEmpty) {
      _activityCEOPresentation = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_CEO_PRESENTATION);
      _activityCompleteProfile = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_COMPLETE_PROFILE);
      _activityFirstDayInformation = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_FIRST_DAY_INFORMATION);
      _activityKnowTeam = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! == Constants.ACTIVITY_KNOW_YOUR_TEAM);
      _activityOnsiteInduction = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_ON_SITE_INDUCTION);
      _activityRemoteInduction = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_REMOTE_INDUCTION);
      _activityELearningContent = activities.firstWhere((processActivity) =>
          processActivity.activity?.code! ==
          Constants.ACTIVITY_INDUCTION_ELEARNING);

      _processTotal = activities.length;
      _processCompleted = activities.where((a) => a.completed!).length;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(
      title: '',
      iconData: Icons.handyman,
      context: this.context,
      scaffoldKey: scaffoldKey,
      showTitle: false,
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      content: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null || !snapshot.data!) {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Onboarding',
                        style: MiAnddesTheme.of(context).headlineLarge.override(
                              fontFamily: 'Rubik',
                              color: MiAnddesTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              lineHeight: 1.0,
                            ),
                      ),
                      Text(
                        '$_processCompleted/$_processTotal',
                        style: MiAnddesTheme.of(context).bodyLarge.override(
                              fontFamily: 'Rubik',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    //height: 380.0,
                    /*decoration: BoxDecoration(
                      color: MiAnddesTheme.of(context).aliceBlue,
                      borderRadius: BorderRadius.circular(4.0),
                    ),*/
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          2.0, 0.0, 2.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 8.0),
                            child: Container(
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: MiAnddesTheme.of(context).columbiaBlue,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 0.0, 8.0),
                                child: Text(
                                  'Antes',
                                  textAlign: TextAlign.start,
                                  style: MiAnddesTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Rubik',
                                        letterSpacing: 0.0,
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) => InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await showDialog(
                                  barrierColor: const Color(0x80424242),
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: const AlignmentDirectional(
                                              0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: GestureDetector(
                                        onTap: () => _model
                                                .unfocusNode.canRequestFocus
                                            ? FocusScope.of(context)
                                                .requestFocus(
                                                    _model.unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.65,
                                          width: 500.0,
                                          child: const WelcomeCeoVideoWidget(),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => setState(() {}));
                              },
                              child: Container(
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: MiAnddesTheme.of(context).info,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                          child:Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              _activityCEOPresentation
                                                  .activity!.name!,
                                              style: MiAnddesTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: 'Rubik',
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          )),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 16.0, 0.0),
                                            child: Icon(
                                              _activityCEOPresentation
                                                      .completed!
                                                  ? Icons.task_alt_outlined
                                                  : Icons.circle_outlined,
                                              color: MiAnddesTheme.of(context)
                                                  .secondaryText,
                                              size: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                context.pushNamed('profile-edit');
                              },
                              child: Container(
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: MiAnddesTheme.of(context).info,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              _activityCompleteProfile
                                                  .activity!.name!,
                                              style: MiAnddesTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: 'Rubik',
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 16.0, 0.0),
                                            child: Icon(
                                              _activityCompleteProfile
                                                      .completed!
                                                  ? Icons.task_alt_outlined
                                                  : Icons.circle_outlined,
                                              color: MiAnddesTheme.of(context)
                                                  .secondaryText,
                                              size: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          GestureDetector(
                              onTap: () async {
                                if (!_activityFirstDayInformation.completed!) {
                                  _activityFirstDayInformation.completed = true;
                                  _activityFirstDayInformation.completionDate = DateTime.now();
                                  await _onboardingService.updateActivityCompleted(_activityFirstDayInformation);
                                }
                                context.pushNamed('first-day-information-item');
                              },
                              child: Container(
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: MiAnddesTheme.of(context).info,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width:200,
                                              child:Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              _activityFirstDayInformation
                                                  .activity!.name!,
                                              style: MiAnddesTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: 'Rubik',
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          )),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 16.0, 0.0),
                                            child: Icon(
                                              _activityFirstDayInformation
                                                      .completed!
                                                  ? Icons.task_alt_outlined
                                                  : Icons.circle_outlined,
                                              color: MiAnddesTheme.of(context)
                                                  .secondaryText,
                                              size: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ]
                            .divide(const SizedBox(height: 12.0))
                            .addToStart(const SizedBox(height: 18.0))
                            .addToEnd(const SizedBox(height: 18.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    //height: 378.0,
                    /*decoration: BoxDecoration(
                      color: MiAnddesTheme.of(context).honeydew,
                      borderRadius: BorderRadius.circular(4.0),
                    ),*/
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          2.0, 0.0, 16.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Container(
                                  width: 150.0,
                                  decoration: BoxDecoration(
                                    color: MiAnddesTheme.of(context).teaGreen,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 8.0, 0.0, 8.0),
                                    child: Text(
                                      'Mi primer día',
                                      textAlign: TextAlign.start,
                                      style: MiAnddesTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Rubik',
                                            letterSpacing: 0.0,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/balloon.png',
                                  width: 32.0,
                                  height: 32.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                DateFormat("dd/MM")
                                    .format(_process!.startDate!),
                                style: MiAnddesTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Rubik',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!_activityKnowTeam.completed!) {
                                _activityKnowTeam.completed = true;
                                _activityKnowTeam.completionDate = DateTime.now();
                                await _onboardingService.updateActivityCompleted(_activityKnowTeam);
                              }
                              context.pushNamed('know-your-team');
                            },
                          child:Container(
                            height: 72.0,
                            decoration: BoxDecoration(
                              color: MiAnddesTheme.of(context).info,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          _activityKnowTeam.activity!.name!,
                                          style: MiAnddesTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Rubik',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 2.0, 0.0),
                                        child: Icon(
                                          _activityKnowTeam.completed!
                                              ? Icons.task_alt_outlined
                                              : Icons.circle_outlined,
                                          color: MiAnddesTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                          GestureDetector(
                            onTap: () async{
                                if (!_activityOnsiteInduction.completed!) {
                                  _activityOnsiteInduction.completed = true;
                                  _activityOnsiteInduction.completionDate = DateTime.now();
                                  await _onboardingService.updateActivityCompleted(_activityOnsiteInduction);
                                }
                                context.pushNamed('onsite-induction',
                                    queryParameters: {'activityName': _activityOnsiteInduction
                                        .activity!.name!});
                            },
                              child: Container(
                            height: 72.0,
                            decoration: BoxDecoration(
                              color: MiAnddesTheme.of(context).info,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          _activityOnsiteInduction
                                              .activity!.name!,
                                          style: MiAnddesTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Rubik',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 2.0, 0.0),
                                        child: Icon(
                                          _activityOnsiteInduction.completed!
                                              ? Icons.task_alt_outlined
                                              : Icons.circle_outlined,
                                          color: MiAnddesTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          ),
                        GestureDetector(
                            onTap: () async {
                              if (!_activityRemoteInduction.completed!) {
                                _activityRemoteInduction.completed = true;
                                _activityRemoteInduction.completionDate = DateTime.now();
                                await _onboardingService.updateActivityCompleted(_activityRemoteInduction);
                              }
                              context.pushNamed('remote-induction',
                                  queryParameters: {'activityName': _activityRemoteInduction
                                      .activity!.name!});
                            },
                            child:Container(
                            height: 72.0,
                            decoration: BoxDecoration(
                              color: MiAnddesTheme.of(context).info,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          _activityRemoteInduction
                                              .activity!.name!,
                                          style: MiAnddesTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Rubik',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 2.0, 0.0),
                                        child: Icon(
                                          _activityRemoteInduction.completed!
                                              ? Icons.task_alt_outlined
                                              : Icons.circle_outlined,
                                          color: MiAnddesTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ),
                        ]
                            .divide(const SizedBox(height: 12.0))
                            .addToStart(const SizedBox(height: 18.0))
                            .addToEnd(const SizedBox(height: 18.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    //height: 250.0,
                    /*decoration: BoxDecoration(
                      color: MiAnddesTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(4.0),
                    ),*/
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          2.0, 0.0, 2.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 0.0, 8.0),
                                child: Container(
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                    color: MiAnddesTheme.of(context).tertiary,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 8.0, 0.0, 8.0),
                                    child: Text(
                                      'Mi primera semana',
                                      textAlign: TextAlign.start,
                                      style: MiAnddesTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Rubik',
                                            letterSpacing: 0.0,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              var dateLimit=DateTime(_process!.startDate!.year,
                                                     _process!.startDate!.month,
                                                     _process!.startDate!.day+7);
                              context.pushNamed('elearning-contents',
                                  queryParameters: {'processId': '${_process!.id}',
                                    'dateLimit': dateTimeFormat('EEEE dd/MM',dateLimit,locale: 'es')});
                            },
                            child:
                          Container(
                            height: 72.0,
                            decoration: BoxDecoration(
                              color: MiAnddesTheme.of(context).info,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          _activityELearningContent
                                              .activity!.name!,
                                          style: MiAnddesTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Rubik',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 2.0, 0.0),
                                        child: Icon(
                                          _activityELearningContent.completed!
                                              ? Icons.task_alt_outlined
                                              : Icons.circle_outlined,
                                          color: MiAnddesTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ]
                            .divide(const SizedBox(height: 24.0))
                            .addToStart(const SizedBox(height: 16.0))
                            .addToEnd(const SizedBox(height: 24.0)),
                      ),
                    ),
                  ),
                ]
                    .divide(const SizedBox(height: 12.0))
                    .addToStart(const SizedBox(height: 18.0))
                    .addToEnd(const SizedBox(height: 18.0)),
              ),
            ),
          );
        },
        future: getActivity(),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';

import '../../utils/custom_view/mianddes_theme.dart';
import 'know_your_team_model.dart';

class KnowYourTeamWidget extends StatefulWidget {
  const KnowYourTeamWidget({super.key});

  @override
  State<KnowYourTeamWidget> createState() => _KnowYourTeamWidgetState();
}

class _KnowYourTeamWidgetState extends State<KnowYourTeamWidget> {
  late KnowYourTeamModel _model;
  late OnboardingService _onboardingService;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KnowYourTeamModel());
    _onboardingService = OnboardingService();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(
        title: 'Conoce a tu equipo',
        iconData: Icons.arrow_back,
        context: this.context,
        scaffoldKey: scaffoldKey,
        showTitle: true,
        returnToActivityList: true,
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        content: FutureBuilder(
            future: _onboardingService.findTeam(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.data == null ||
                  (snapshot.data != null && snapshot.data!.isEmpty)) {
                //print('project snapshot data is: ${projectSnap.data}');
                return const Center(
                    child: SizedBox(
                  height: 80.0,
                  width: 80.0,
                  child: CircularProgressIndicator(),
                ));
              }
              return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(),
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20.0),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.account_tree_outlined,
                                color: MiAnddesTheme.of(context).secondary,
                                size: 24.0,
                              ),
                              Text(
                                'Directorio general',
                                style: MiAnddesTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Rubik',
                                      color: MiAnddesTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ]),
                        const SizedBox(height: 25.0),
                        for (int i = 0; i < snapshot.data!.length; i++)
                          Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            width: double.infinity,
                            decoration: i==0?BoxDecoration(
                              color:
                                  MiAnddesTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: MiAnddesTheme.of(context).secondary,
                                width: 1.0,
                              ),
                            ):const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: snapshot.data![i].image != null?CachedNetworkImage(
                                          fit: BoxFit.fitHeight,
                                          imageUrl: snapshot.data![i].image!,
                                          placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                          Image.asset(
                                            'assets/images/noimage.png',
                                            width: 50.0,
                                            height: 50.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ):Image.asset(
                                          'assets/images/noimage.png',
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data![i].fullname!,
                                            style: MiAnddesTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily: 'Rubik',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                          child:Text(
                                            snapshot.data![i].job!,
                                            style: MiAnddesTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Rubik',
                                                  letterSpacing: 0.0,
                                                ),
                                          )
                                          ),
                                          Text(
                                            snapshot.data![i].isBoss?'Jefe a cargo':'',
                                            style: MiAnddesTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Rubik',
                                                  color:
                                                      MiAnddesTheme.of(context)
                                                          .success,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ].divide(const SizedBox(height: 4.0)),
                                      ),
                                    ].divide(const SizedBox(width: 12.0)),
                                  ),


                                  snapshot.data![i].hobbies!= null &&
                                      snapshot.data![i].hobbies!.isNotEmpty ?
                                  const Divider(
                                    thickness: 1.0,
                                    color: Color(0x8E57636C),
                                  ):const SizedBox(),

                                  snapshot.data![i].hobbies!= null &&
                                      snapshot.data![i].hobbies!.isNotEmpty?
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'HOBBIES',
                                        style: MiAnddesTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: 'Rubik',
                                              letterSpacing: 2.0,
                                            ),
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          for(var hobbie in snapshot.data![i].hobbies!)
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              border: Border.all(
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                hobbie,
                                                style: MiAnddesTheme.of(context)
                                                    .bodySmall
                                                    .override(
                                                      fontFamily: 'Rubik',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ),

                                        ].divide(const SizedBox(width: 8.0)),
                                      ),
                                    ].divide(const SizedBox(height: 8.0)),
                                  ):const SizedBox(),
                                ].divide(const SizedBox(height: 12.0)),
                              ),
                            ),
                          )
                      ])));
            }));
  }
}

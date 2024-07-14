import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_common_page.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/tools/tools_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/tool.dart';
import '../../service/tool_service.dart';
import '../../utils/custom_view/mianddes_theme.dart';

class ToolsWidget extends StatefulWidget {
  const ToolsWidget({super.key});

  @override
  State<ToolsWidget> createState() => _ToolsWidgetState();
}

class _ToolsWidgetState extends State<ToolsWidget> {
  late ToolModel _model;
  late ToolService _toolService;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ToolModel());
    _toolService = ToolService();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiAnddesCommonPage(
      title: 'Herramientas',
      iconData: Icons.handyman,
      context: this.context,
      scaffoldKey: scaffoldKey,
      showTitle: true,
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      content: FutureBuilder(
        builder: (context, toolSnap) {
          if (toolSnap.connectionState == ConnectionState.none ||
              toolSnap.data == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return const Center(
                child: SizedBox(
              height: 80.0,
              width: 80.0,
              child: CircularProgressIndicator(),
            ));
          }
          return ListView.builder(
            itemCount: toolSnap.data!.length,
            itemBuilder: (context, index) {
              Tool tool = toolSnap.data![index];
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tool.cover!=null?SizedBox(
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fitHeight,
                                  imageUrl: tool.cover!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )):const SizedBox(),
                            Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  tool.name!,
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
                                  tool.description!,
                                  textAlign: TextAlign.justify,
                                  style: MiAnddesTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Rubik',
                                        letterSpacing: 0.0,
                                      ),
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () async {
                                  log("tool.link=${tool.link}");
                                  if(!tool.link!.startsWith("http")){
                                    tool.link='https:\\${tool.link}';
                                  }
                                  final Uri url = Uri.parse(tool.link!);
                                  if (!await launchUrl(url)) {
                                    log('Could not launch ${tool.link!}');
                                  }
                                },
                                child: Text(
                                  'ABRIR',
                                  style: MiAnddesTheme.of(context).bodyLarge,
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
        future: _toolService.list(),
      ),
    );
  }
}

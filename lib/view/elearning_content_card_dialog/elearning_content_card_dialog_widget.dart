import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';
import 'package:mi_anddes_mobile_app/model/elearning_result.dart';
import 'package:mi_anddes_mobile_app/service/onboarding_service.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/flutter_icon_button.dart';
import 'package:mi_anddes_mobile_app/utils/custom_view/mianddes_theme.dart';
import 'package:mi_anddes_mobile_app/utils/flutter_util.dart';
import 'package:mi_anddes_mobile_app/view/elearning_content_card_dialog/elearning_content_card_dialog_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ELearningContentCardDialogWidget extends StatefulWidget {
  final ELearningContent eLearningContent;
  final String processId;
  const ELearningContentCardDialogWidget(
      {super.key, required this.eLearningContent,required this.processId});

  @override
  State<ELearningContentCardDialogWidget> createState() =>
      _ELearningContentCardDialogWidgetState();
}

class _ELearningContentCardDialogWidgetState
    extends State<ELearningContentCardDialogWidget> {
  late ELearningContentCardDialogModel _model;
  ELearningContentCard? _currentCard;
  ELearningContentCardOption? _optionSelected;
  int _currentIndex=0;
  bool _finished=false;
  late OnboardingService _onboardingService;

  @override
  void setState(VoidCallback callback) async{
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ELearningContentCardDialogModel());
    _onboardingService=OnboardingService();
    if(widget.eLearningContent.cards!=null
        && widget.eLearningContent.cards!.isNotEmpty
        && widget.eLearningContent.cards!
            .where((c) => c.read != null && !c.read!).isNotEmpty
    ) {
      _currentCard = widget.eLearningContent.cards!
          .firstWhere((c) => c.read != null && !c.read!);
      _currentIndex=widget.eLearningContent.cards!.indexOf(_currentCard!);
    }
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
                  const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 16.0, 0.0),
              child: ListView(
                children: [
                  Row(children: [
                    const SizedBox(width: 5.0),
                    SizedBox(
                      width: 250,
                      child:
                      Text(widget.eLearningContent.name!,
                          style: MiAnddesTheme.of(context).titleLarge),
                    ),
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
                  ]),
                  const SizedBox(height: 10.0),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0),
                      child: LinearPercentIndicator(
                        percent: widget.eLearningContent.progress!/100.0,
                        lineHeight: 6.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor:
                        MiAnddesTheme.of(context).primary,
                        backgroundColor:
                        MiAnddesTheme.of(context).alternate,
                        padding: EdgeInsets.zero,
                  )),
                  const SizedBox(height: 35.0),
                  if(_currentCard==null)
                    resultWidget()
                  else
                    if(_currentCard!.type==Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION)
                      questionWidget()
                    else
                      contentWidget(),
                  const SizedBox(height: 45.0),
                  _currentCard!=null?
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${_currentIndex+1}/${widget.eLearningContent.cards!.length}',
                        style: MiAnddesTheme.of(context).bodyMedium.override(
                          fontFamily: 'Rubik',
                          letterSpacing: 0.0,
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(1.0, 1.0),
                        child: FlutterIconButton(
                          borderRadius: 4.0,
                          borderWidth: 0.0,
                          buttonSize: 40.0,
                          fillColor: MiAnddesTheme.of(context).aliceBlue,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: MiAnddesTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            if (_finished) {
                              context.pop();
                            } else {
                              _currentCard!.read=true;
                              _currentCard!.dateRead = DateTime.now();
                              await _onboardingService.updateCard(widget.eLearningContent.id,_currentCard!);
                              if(_optionSelected!=null){
                                _optionSelected!.checked=true;
                                await _onboardingService.updateOption(_currentCard!.id, _optionSelected!);
                                _optionSelected=null;
                              }
                              if ((_currentIndex + 1) >=
                                  widget.eLearningContent.cards!.length) {
                                try {
                                  ELearningResult result = await _onboardingService
                                      .getResult(1,
                                      widget.processId,
                                      widget.eLearningContent.id);

                                  widget.eLearningContent.sent = true;
                                  widget.eLearningContent.result =
                                      result.result;
                                  widget.eLearningContent.progress = 100;
                                  widget.eLearningContent.finished = _finished =true;
                                  _onboardingService.updateContent(
                                      widget.eLearningContent);
                                }on Exception{
                                  widget.eLearningContent.sent = false;
                                  widget.eLearningContent.progress = 100;
                                  widget.eLearningContent.finished = _finished = true;
                                  _onboardingService.updateContent(
                                      widget.eLearningContent);
                                }
                                  setState((){
                                    _finished=true;
                                    _currentCard = null;
                                    _currentIndex=-1;
                                  });
                                }else{
                                  _currentIndex++;
                                  _currentCard=widget.eLearningContent.cards![_currentIndex];
                                  widget.eLearningContent.progress =(_currentIndex*100/widget.eLearningContent.cards!.length).round();
                                  _onboardingService.updateContent(widget.eLearningContent);
                                  setState((){
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ].divide(const SizedBox(width: 24.0)),

                  ):const SizedBox(),
                  //HtmlWidget(widget.content),
                  const SizedBox(height: 12.0),
                ],
              ),
            )));
  }

  Widget resultWidget() {
    return Center(
      heightFactor: 1.5,
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_outlined,
            color: MiAnddesTheme.of(context).secondary,
            size: 32.0,
          ),
          Text('Completaste el modulo',style: MiAnddesTheme.of(context).titleMedium),
          const SizedBox(height:10),
          SizedBox(
            width: 250,
            child: Text(widget.eLearningContent.name!,style: MiAnddesTheme.of(context).titleLarge,textAlign: TextAlign.center)
          ),
          const SizedBox(height:10),
          SizedBox(
            width: 100,
            child:Row(
                    children: [
                      Icon(
                        Icons.checklist_rtl,
                        color: MiAnddesTheme.of(context).secondary,
                        size: 24.0,
                      ),
                      Text('${widget.eLearningContent.result!}%',style: MiAnddesTheme.of(context).titleLarge)
                  ],
            )
          )
        ],
      ),
    );
  }

  Widget questionWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evaluación',
          style: MiAnddesTheme.of(context).titleSmall.override(
            fontFamily: 'Rubik',
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          _currentCard!.content!,
          style: MiAnddesTheme.of(context).bodyMedium.override(
            fontFamily: 'Rubik',
            letterSpacing: 0.0,
            lineHeight: 1.5,
          ),
        ),
        const SizedBox(height: 10.0),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opciones de respuesta',
              style: MiAnddesTheme.of(context).bodySmall.override(
                fontFamily: 'Rubik',
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 8.0),
            if(_currentCard!.options!=null && _currentCard!.options!.isNotEmpty)
              for(ELearningContentCardOption option in _currentCard!.options!)
                RadioListTile<ELearningContentCardOption>(
                  title: Text(option.description!),
                  value: option,
                  groupValue: _optionSelected,
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (ELearningContentCardOption? value) {
                    setState(() {
                      _optionSelected = value;
                    });
                  },
                  //subtitle: const Text('Supporting text'),
                )
          ]
    )
    ]
    );
  }
  Widget contentWidget() {
    return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child:HtmlWidget(_currentCard!.content!)
          );
  }
}

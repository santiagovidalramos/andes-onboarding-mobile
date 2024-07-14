import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mi_anddes_mobile_app/model/elearning_content.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';
import 'package:mi_anddes_mobile_app/model/elearning_result.dart';
import 'package:mi_anddes_mobile_app/model/first_day_information_item.dart';
import 'package:mi_anddes_mobile_app/model/onboarding.dart';
import 'package:mi_anddes_mobile_app/model/onsite_induction.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';
import 'package:mi_anddes_mobile_app/model/remote_induction.dart';
import 'package:mi_anddes_mobile_app/model/team_member.dart';

import 'package:mi_anddes_mobile_app/repository/ceo_presentation_repository.dart';
import 'package:mi_anddes_mobile_app/repository/elearning_content_repository.dart';
import 'package:mi_anddes_mobile_app/repository/onsite_induction_repository.dart';
import 'package:mi_anddes_mobile_app/repository/process_activity_repository.dart';
import 'package:mi_anddes_mobile_app/repository/process_repository.dart';
import 'package:mi_anddes_mobile_app/repository/remote_induction_repository.dart';
import 'package:mi_anddes_mobile_app/repository/team_member_repository.dart';
import 'package:mi_anddes_mobile_app/utils/exception/unauthorized_exception.dart';

import '../constants.dart';
import '../model/ceo_presentation.dart';
import '../model/process.dart';
import '../repository/first_day_information_item_repository.dart';
import 'auth_service.dart';

class OnboardingService {
  late ProcessRepository _processRepository;
  late ProcessActivityRepository _processActivityRepository;
  late TeamMemberRepository _teamMemberRepository;
  late CEOPresentationRepository _ceoPresentationRepository;
  late OnsiteInductionRepository _onsiteInductionRepository;
  late RemoteInductionRepository _remoteInductionRepository;
  late ELearningContentRepository _eLearningContentRepository;
  late FirstDayInformationItemRepository _firstDayInformationItemRepository;

  OnboardingService() {
    _processRepository = ProcessRepository();
    _processActivityRepository = ProcessActivityRepository();
    _teamMemberRepository = TeamMemberRepository();
    _ceoPresentationRepository = CEOPresentationRepository();
    _onsiteInductionRepository = OnsiteInductionRepository();
    _remoteInductionRepository = RemoteInductionRepository();
    _eLearningContentRepository = ELearningContentRepository();
    _firstDayInformationItemRepository = FirstDayInformationItemRepository();
  }

  Future<void> syncProcess(int userId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse("${Constants.baseUri}/onboarding/$userId/process/");
    final response = await http.get(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      if(response.body.isNotEmpty) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        Process process = Process.fromJson(body);
        await _processRepository.deleteAll();
        await _processRepository.add(process);
      }else{
        await _processRepository.deleteAll();
      }
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<void> syncProcessActivity(int userId, int processId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities");
    final response = await http.get(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}",
          "Content-Type": 'application/json',});
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      List<ProcessActivity> activities = List<ProcessActivity>.from(
          body.map((model) => ProcessActivity.fromJson(model)));
      await _processActivityRepository.deleteAll();
      await _processActivityRepository.addAll(activities);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<void> syncOnboarding(int userId, int processId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities/detail");
    final response = await http.get(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      //log(response.body);
      Onboarding onboarding = Onboarding.fromJson(body);

      await _ceoPresentationRepository.deleteAll();
      await _onsiteInductionRepository.deleteAll();
      await _remoteInductionRepository.deleteAll();
      await _teamMemberRepository.deleteAll();

      if (onboarding.ceoPresentation != null) {
        await _ceoPresentationRepository.add(onboarding.ceoPresentation!);
      }
      if (onboarding.remoteInduction != null) {
        await _remoteInductionRepository.add(onboarding.remoteInduction!);
      }
      if (onboarding.onSiteInduction != null) {
        await _onsiteInductionRepository.add(onboarding.onSiteInduction!);
      }
      if (onboarding.team != null) {
        await _teamMemberRepository.addAll(onboarding.team!);
      }

      if (onboarding.eLearningContents != null &&
          onboarding.eLearningContents!.isNotEmpty) {
        await _eLearningContentRepository.addAll(onboarding.eLearningContents!);
      }
      if (onboarding.firstDayInformationItems != null &&
          onboarding.firstDayInformationItems!.isNotEmpty) {
        await _firstDayInformationItemRepository
            .addAll(onboarding.firstDayInformationItems!);
      }
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<CEOPresentation?> findCEOPresentation() {
    return _ceoPresentationRepository.findFirst();
  }

  Future<RemoteInduction?> findRemoteInduction() {
    return _remoteInductionRepository.findFirst();
  }

  Future<OnsiteInduction?> findOnsiteInduction() {
    return _onsiteInductionRepository.findFirst();
  }

  Future<List<TeamMember>?> findTeam() {
    return _teamMemberRepository.findAll();
  }

  Future<List<ELearningContent>?> findELearningContents() {
    return _eLearningContentRepository.findAll();
  }
  Future<ELearningContent?> findELearningContentsById(int id) async{
    return await _eLearningContentRepository.findById(id);
  }

  Future<List<FirstDayInformationItem>?> findFirstDayInformationItems() {
    return _firstDayInformationItemRepository.findAll();
  }

  Future<Process?> findProcess() {
    return _processRepository.findFirst();
  }

  Future<List<ProcessActivity>?> findActivities() {
    return _processActivityRepository.findAll();
  }

  Future<void> updateWelcomed(int userId, processId) async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/welcomed");
    final response = await http.put(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      log('Se actualizo correctamente el flag de mostrar bienvenida');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<void> updateActivityCompleted(ProcessActivity processActivity) async {
    await _processActivityRepository.updateById(processActivity);

    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/1/process/1/activities/${processActivity.id}");
    final response = await http.put(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      log('Se actualizo correctamente el flag de completado a la actividad');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<ProcessActivity?> findProcessActivityByCode(String code) async {
    var activities = await _processActivityRepository.findByActivityCode(code);
    ProcessActivity? activity;
    if (activities != null && activities.isNotEmpty && activities.length == 1) {
      activity = activities.first;
    }
    return activity;
  }

  Future<void> updateCard(int parentId,ELearningContentCard eLearningContentCard) async{
    await _eLearningContentRepository.updateCard(parentId,eLearningContentCard);
  }


  Future<ELearningResult> getResult(int userId,String processId,int contentId) async{
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse(
        "${Constants.baseUri}/onboarding/$userId/process/$processId/activities/detail/INDUCTION_ELEARNING");

    var elearningContent = await findELearningContentsById(contentId);

    final response = await http.post(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}",
          "Content-Type": 'application/json'},
        body: jsonEncode(elearningContent!.toJson()));

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      ELearningResult eLearningResult = ELearningResult.fromJson(body);
      return eLearningResult;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
    return ELearningResult(result: 0);
  }

  Future<void> updateContent(ELearningContent eLearningContent) async {
    await _eLearningContentRepository.updateContent(eLearningContent);
  }
  Future<void> updateOption(int parentId,ELearningContentCardOption option) async {
    await _eLearningContentRepository.updateOption(parentId,option);
  }
  Future<void> sendPendingELearningContents() async{
    Process? process = await findProcess();
    ProcessActivity? processActivity = await findProcessActivityByCode(Constants.ACTIVITY_INDUCTION_ELEARNING);

    List<ELearningContent>? elearnings=await findELearningContents();

    if(process!= null && processActivity!=null && elearnings!=null && elearnings.isNotEmpty){
      ELearningResult result;
      for(ELearningContent content in elearnings){
        if(content.finished! && !content.sent! ) {
          result = await getResult(1, '${process.id}', content.id);

          content.sent = true;
          content.result = result.result;
          content.progress = 100;
          content.finished = true;
          await updateContent(content);
        }
      }
    }
  }
}

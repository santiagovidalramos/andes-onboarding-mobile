import 'package:json_annotation/json_annotation.dart';
import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

import 'elearning_content_card_option.dart';

class ELearningContentCard extends MapeableEntityWithParentId {
  int id;
  String? title;
  String? type;
  bool? draft;
  String? content;
  bool? deleted;
  int? position;
  bool? read;
  DateTime? dateRead;

  List<ELearningContentCardOption>? options;

  ELearningContentCard(
      {required this.id,
      this.title,
      this.type,
      this.draft,
      this.content,
      this.deleted,
      this.position,
      this.read,
      this.dateRead,
      this.options});

  static fromJson(Map<String, dynamic> json) => ELearningContentCard(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      draft: json['draft'] as bool?,
      content: json['content'] as String?,
      type: json['type'] as String?,
      deleted: json['deleted'] as bool?,
      position: (json['position'] as num).toInt(),
      read: json['read']!=null?(json['read'] as bool):false,
      dateRead: json['dateRead']!=null ? json['dateRead'] as DateTime:null,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) =>
              ELearningContentCardOption.fromJson(e as Map<String, dynamic>)
                  as ELearningContentCardOption)
          .toList());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'draft': draft,
        'content': content,
        'type':type,
        'deleted': deleted,
        'position': position,
        'read':read??false,
        'dateRead':dateRead?.toIso8601String(),
        'options': options?.map((e) => e.toJson()).toList(),
      };

  @override
  Map<String, Object?> toMap(int parentId) {
    return {
      'id': id,
      'title': title,
      'draft': draft !=null && draft!?1:0,
      'content': content,
      'type': type,
      'deleted': deleted!=null && deleted!?1:0,
      'position': position,
      'read':read!=null && read!?1:0,
      'date_read':dateRead?.toIso8601String(),
      'elearning_content_id': parentId
    };
  }

  @override
  int getId() {
    return id;
  }
}

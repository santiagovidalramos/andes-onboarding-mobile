import 'package:json_annotation/json_annotation.dart';
import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

part 'service.g.dart';

@JsonSerializable(explicitToJson: true)
class Service extends MapeableEntity {
  int id;
  String? name;
  String? description;
  String? icon;
  List<ServiceDetail>? details;
  Service(
      {required this.id, this.name, this.description, this.icon, this.details});

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'description': description, 'icon': icon};
  }

  @override
  int getId() {
    return id;
  }
}

@JsonSerializable(explicitToJson: true)
class ServiceDetail extends MapeableEntityWithParentId {
  int id;
  String? description;
  String? title;
  ServiceDetail({required this.id, this.description, this.title});

  factory ServiceDetail.fromJson(Map<String, dynamic> json) =>
      _$ServiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDetailToJson(this);

  @override
  Map<String, Object?> toMap(int serviceId) {
    return {
      'id': id,
      'description': description,
      'title': title,
      'service_id': serviceId
    };
  }

  @override
  int getId() {
    return id;
  }
}

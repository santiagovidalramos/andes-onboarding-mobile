abstract class MapeableEntity {
  Map<String, dynamic> toMap();
  int getId();
}

abstract class MapeableEntityWithParentId {
  Map<String, dynamic> toMap(int parentId);
  int getId();
}

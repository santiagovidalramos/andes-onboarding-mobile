class ELearningResult{

  int result;

  ELearningResult({required this.result});

  static fromJson(Map<String, dynamic> json) => ELearningResult(
  result: (json['result'] as num).toInt());

  Map<String, dynamic> toJson() => <String, dynamic> { 'result' : result };
}

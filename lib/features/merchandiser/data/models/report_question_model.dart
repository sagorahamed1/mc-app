class ReportQuestionModel {
  final String id;
  final String question;
  final int sortOrder;

  ReportQuestionModel({
    required this.id,
    required this.question,
    required this.sortOrder,
  });

  factory ReportQuestionModel.fromJson(Map<String, dynamic> json) =>
      ReportQuestionModel(
        id: json['_id'] ?? '',
        question: json['question'] ?? '',
        sortOrder: json['sortOrder'] ?? 0,
      );
}

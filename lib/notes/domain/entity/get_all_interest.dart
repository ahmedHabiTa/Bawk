
import 'dart:convert';

List<InterestModel> interestModelFromJson(String str) => List<InterestModel>.from(json.decode(str).map((x) => InterestModel.fromJson(x)));

String interestModelToJson(List<InterestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InterestModel {
  InterestModel({
    required this.intrestText,
    this.id,
  });

   String intrestText;
   String? id;

  factory InterestModel.fromJson(Map<String, dynamic> json) => InterestModel(
    intrestText: json["intrestText"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "intrestText": intrestText,
    "id": id,
  };
}

// To parse this JSON data, do
//
//     final getNotesResponse = getNotesResponseFromJson(jsonString);

import 'dart:convert';

List<GetNotesResponse> getNotesResponseFromJson(String str) =>
    List<GetNotesResponse>.from(
        json.decode(str).map((x) => GetNotesResponse.fromJson(x)));

String getNotesResponseToJson(List<GetNotesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetNotesResponse {


  GetNotesResponse({
    required this.text,
    this.placeDateTime,
    this.userId,
    this.id,
  });

  final String text;
  final DateTime? placeDateTime;
  final String? userId;
  final String? id;

  GetNotesResponse copy({
    String? text,
    DateTime? placeDateTime,
    String? userId,
    String? id,
}) => GetNotesResponse(
    id: id ?? this.id,
    text: text ?? this.text,
    userId: userId ?? this.userId,
    placeDateTime: placeDateTime ?? this.placeDateTime,
  );
  factory GetNotesResponse.fromJson(Map<String, dynamic> json) =>
      GetNotesResponse(
        text: json["text"],
        placeDateTime: DateTime.parse(json["placeDateTime"]),
        userId: json["userId"] == null ? null : json["userId"],
        id: json["id"],
      );

  factory GetNotesResponse.fromMap(Map<String, dynamic> map) =>
      GetNotesResponse(
        text: map["text"],
        placeDateTime: DateTime.parse(map["placeDateTime"]),
        userId: map["userId"] == null ? null : map["userId"],
        id: map["id"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "placeDateTime": placeDateTime!.toIso8601String(),
        "userId": userId == null ? null : userId,
        "id": id,
      };
}

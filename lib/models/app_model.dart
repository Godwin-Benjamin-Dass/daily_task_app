import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

class AppModel {
  String? name;
  Uint8List? icon;
  String? bundleId;

  AppModel({this.name, this.icon, this.bundleId});

  // Convert AppModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon':
          icon != null ? base64Encode(icon!) : null, // Encode icon to base64
      'bundleId': bundleId,
    };
  }

  // Create AppModel object from JSON
  factory AppModel.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return AppModel(
      name: json['name'],
      icon: json['icon'] != null
          ? base64Decode(json['icon'])
          : null, // Decode icon from base64
      bundleId: json['bundleId'],
    );
  }
}

import 'package:flutter/material.dart';

class InApp {
  int id;
  String category;
  String name;
  String type;
  String value;
  String message;
  String createdDate;

  InApp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['status'] ?? 'other';
    name = json['name'] ?? '';
    type = json['type'];
    value = json['value'];
    message = json['message'] ?? '';
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['type'] = this.type;
    data['value'] = this.value;
    data['message'] = this.message;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
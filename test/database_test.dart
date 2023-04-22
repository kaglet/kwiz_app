import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:kwiz_v2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kwiz_v2/services/database.dart';
import 'package:kwiz_v2/services/mock_database.dart';

void main() {
  test('get categories', () async {
    final service = MockDataService();
    final List? testCategories = await service.getCategories();

    expect(testCategories, ['Art', 'Science']);
  });
}

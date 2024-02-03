import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/constants.dart';
import 'package:google_docs/models/document_model.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:http/http.dart';

final documentServiceProvider = Provider(
  (ref) => DocumentService(
    client: Client(),
  ),
);

class DocumentService {
  final Client _client;

  DocumentService({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel errorModel = ErrorModel(
      error: 'Some unexpected error occured!',
      data: null,
    );
    try {
      final response = await _client.post(
        Uri.parse('$host/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      switch (response.statusCode) {
        case 200:
          final newDocument = DocumentModel.fromJson(response.body);
          errorModel = ErrorModel(error: null, data: newDocument);
          break;
        default:
          errorModel = ErrorModel(
            error: response.body,
            data: null,
          );
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
    }

    return errorModel;
  }
}

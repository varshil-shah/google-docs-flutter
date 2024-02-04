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

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel errorModel = ErrorModel(
      error: 'Some unexpected error occured!',
      data: null,
    );
    try {
      final response = await _client.get(
        Uri.parse('$host/docs/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      switch (response.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(
                  jsonDecode(response.body)[i],
                ),
              ),
            );
          }
          errorModel = ErrorModel(error: null, data: documents);
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

  Future<ErrorModel> updateTitle({
    required String token,
    required String id,
    required String title,
  }) async {
    ErrorModel errorModel = ErrorModel(
      error: 'Some unexpected error occured!',
      data: null,
    );
    try {
      final response = await _client.patch(
        Uri.parse('$host/doc/title'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'id': id,
          'title': title,
        }),
      );

      switch (response.statusCode) {
        case 200:
          final updatedDocument = DocumentModel.fromJson(response.body);
          errorModel = ErrorModel(error: null, data: updatedDocument);
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

  Future<ErrorModel> getDocumentById(String token, String id) async {
    ErrorModel errorModel = ErrorModel(
      error: 'Some unexpected error occured!',
      data: null,
    );
    try {
      final response = await _client.get(
        Uri.parse('$host/doc/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      switch (response.statusCode) {
        case 200:
          final document = DocumentModel.fromJson(response.body);
          errorModel = ErrorModel(error: null, data: document);
          break;
        default:
          throw Exception(
              "This document doesn't exist!, please create a new one");
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
    }

    return errorModel;
  }
}

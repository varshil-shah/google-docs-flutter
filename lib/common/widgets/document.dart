import 'package:flutter/material.dart';
import 'package:google_docs/colors.dart';
import 'package:routemaster/routemaster.dart';

import 'package:google_docs/models/document_model.dart';

// ignore: must_be_immutable
class DocumentCard extends StatelessWidget {
  DocumentModel document;
  DocumentCard({super.key, required this.document});

  void navigateToDocument(BuildContext context, String docId) {
    Routemaster.of(context).push('/document/$docId');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: null,
      onTap: () => navigateToDocument(context, document.id),
      child: Container(
        decoration: BoxDecoration(
          color: kLightGreyColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/document.png"),
            const SizedBox(height: 10),
            Text(document.title),
          ],
        ),
      ),
    );
  }
}

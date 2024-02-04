import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:google_docs/colors.dart';
import 'package:google_docs/models/document_model.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:google_docs/services/auth_service.dart';
import 'package:google_docs/services/document_service.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: "Untitled document");
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    errorModel = await ref
        .read(documentServiceProvider)
        .getDocumentById(ref.read(userProvider)!.token, widget.id);

    if (errorModel != null && errorModel!.data != null) {
      setState(() {
        titleController.text = (errorModel!.data as DocumentModel).title;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentServiceProvider).updateTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Image.asset("assets/images/document.png", height: 30),
            const SizedBox(width: 10),
            IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.8),
                child: TextField(
                  controller: titleController,
                  onSubmitted: (value) => updateTitle(ref, value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kLightBlueColor),
                    ),
                    contentPadding: EdgeInsets.all(5),
                  ),
                ),
              ),
            )
          ]),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 5.0,
            ),
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.lock,
                color: kWhiteColor,
                size: 20,
              ),
              onPressed: () {},
              label: const Text(
                'Share',
                style: TextStyle(
                  color: kWhiteColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kLightBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: kLightGreyColor,
            height: 1.0,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            quill.QuillToolbar.simple(
              configurations: quill.QuillSimpleToolbarConfigurations(
                controller: _controller,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: size.width * 0.9,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: kWhiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: quill.QuillEditor(
                      configurations: quill.QuillEditorConfigurations(
                        controller: _controller,
                      ),
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

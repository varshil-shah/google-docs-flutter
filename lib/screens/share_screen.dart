import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/colors.dart';
import 'package:routemaster/routemaster.dart';

class ShareScreen extends ConsumerWidget {
  const ShareScreen({Key? key}) : super(key: key);

  void navigateToDocument(BuildContext context, String docId) {
    if (docId.isNotEmpty) {
      Routemaster.of(context).push('/document/$docId');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter document Id',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            controller: controller,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              navigateToDocument(context, controller.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            child: const Text(
              'Get access!',
              style: TextStyle(
                fontSize: 16.0,
                color: kWhiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

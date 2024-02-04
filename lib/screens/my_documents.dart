import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_docs/common/widgets/docs_skeleton.dart';
import 'package:google_docs/common/widgets/document.dart';
import 'package:google_docs/services/auth_service.dart';
import 'package:google_docs/services/document_service.dart';

class MyDocuments extends ConsumerWidget {
  const MyDocuments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () async {
        ref
            .watch(documentServiceProvider)
            .getDocuments(ref.watch(userProvider)!.token);
      },
      child: FutureBuilder(
        future: ref.watch(documentServiceProvider).getDocuments(
              ref.watch(userProvider)!.token,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  maxCrossAxisExtent: 200.0,
                ),
                itemBuilder: (context, index) => const DocumentSkeleton(),
              ),
            );
          }

          if (snapshot.data!.data.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/empty.svg",
                    height: size.width * 0.7,
                    width: size.width * 0.7,
                  ),
                ],
              ),
            );
          }

          return Container(
            margin: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 4 / 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                maxCrossAxisExtent: 200.0,
              ),
              itemCount: snapshot.data!.data.length,
              itemBuilder: ((context, index) =>
                  DocumentCard(document: snapshot.data!.data[index])),
            ),
          );
        },
      ),
    );
  }
}

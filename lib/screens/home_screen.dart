import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/common/widgets/docs_skeleton.dart';
import 'package:google_docs/common/widgets/document.dart';
import 'package:google_docs/services/auth_service.dart';
import 'package:google_docs/services/document_service.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  void signOut(WidgetRef ref) async {
    ref.read(authServiceProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(documentServiceProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Google Docs',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
            actions: [
              IconButton(
                onPressed: () => signOut(ref),
                icon: const Icon(
                  Icons.logout,
                ),
              ),
            ]),
        body: RefreshIndicator(
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createDocument(context, ref);
          },
          child: const Icon(
            Icons.add,
            color: kWhiteColor,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'My files',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: 'Shared files',
            ),
          ],
        ));
  }
}

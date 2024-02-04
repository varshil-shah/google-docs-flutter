import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/screens/my_documents.dart';
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

  final List<Widget> _widgetOptions = <Widget>[
    const MyDocuments(),
  ];

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
        body: _widgetOptions.elementAt(selectedIndex),
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

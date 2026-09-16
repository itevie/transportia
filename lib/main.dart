import 'package:flutter/material.dart';
import 'package:transportia/util_widgets/page_container.dart';
import 'package:transportia/widgets/pages/filter_search.dart';
import 'package:transportia/widgets/pages/photo.dart';
import 'package:transportia/widgets/pages/photo_search_page.dart';
import 'package:transportia/widgets/pages/service_checklists.dart';
import 'package:transportia/widgets/pages/user.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),

      home: TransportiaMain(),
    );
  }
}

class TransportiaMain extends StatefulWidget {
  const TransportiaMain({super.key});

  @override
  State<TransportiaMain> createState() => _TransportiaMainState();
}

late void Function(Widget page) setAppPage;

class _TransportiaMainState extends State<TransportiaMain> {
  Widget currentPage = Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();

    setAppPage = (page) => setPage(page);
  }

  void setPage(Widget element) {
    setState(() {
      currentPage = PageContainer(child: element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transportia"),

        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.upload)),
          ElevatedButton.icon(
            onPressed: () {},
            label: Text("Login"),
            icon: const Icon(Icons.login),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: const Text(
                "Transportia",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.abc),
              title: Text("Photo Test"),
              onTap: () {
                Navigator.of(context).pop();
                setPage(FullscreenPhotoViewer());
              },
            ),
            ListTile(
              leading: const Icon(Icons.abc),
              title: Text("User Test"),
              onTap: () {
                Navigator.of(context).pop();
                setPage(UserViewer());
              },
            ),
            ListTile(
              leading: const Icon(Icons.abc),
              title: Text("Search Test"),
              onTap: () {
                Navigator.of(context).pop();
                setPage(PhotoSearchPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.abc),
              title: Text("Service Checklist"),
              onTap: () {
                Navigator.of(context).pop();
                setPage(ServiceChecklists());
              },
            ),
            ListTile(
              leading: const Icon(Icons.abc),
              title: Text("Filter Test"),
              onTap: () {
                Navigator.of(context).pop();
                setPage(FilterSearch(callback: (r) => {}));
              },
            ),
          ],
        ),
      ),

      body: currentPage,
    );
  }
}

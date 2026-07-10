import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:device_preview/device_preview.dart';

class MyCustomScrollbehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

void main() {
  runApp(
    DevicePreview(
      builder: (context) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      scrollBehavior: MyCustomScrollbehaviour(),
      builder: DevicePreview.appBuilder,
      title: 'Maple',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maple'),
        centerTitle: false,
        leading: Icon(Icons.map),
        titleSpacing: 0.0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(1.3521, 103.8198),
              initialZoom: 13.0,
              minZoom: 11.0,
              maxZoom: 19.0,
              cameraConstraint: CameraConstraint.contain(bounds: LatLngBounds(
                LatLng(1.144, 103.535),
                LatLng(1.494, 104.502),
              )),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://www.onemap.gov.sg/maps/tiles/Night/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.maple.app',
              ),
            ],
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            snap: true,
            builder: (context, scrollController) {
              return LayoutBuilder(
                builder: (context, constraints) {
                 return SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(233, 53, 59, 69),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    margin: EdgeInsets.all(6.0),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12.0),
                          height: 5,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(2.5),
                          )
                        ),
                        SearchAnchor(
                          builder:
                              (
                                BuildContext context,
                                SearchController controller,
                              ) {
                                return SearchBar(
                                  controller: controller,
                                  padding:
                                      const WidgetStatePropertyAll<EdgeInsets>(
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                      ),
                                  onTap: () {
                                    controller.openView();
                                  },
                                  onChanged: (_) {
                                    controller.openView();
                                  },
                                  leading: const Icon(Icons.search),
                                );
                              },
                          suggestionsBuilder:
                              (
                                BuildContext context,
                                SearchController controller,
                              ) {
                                return List<ListTile>.generate(5, (int index) {
                                  final String item = 'item $index';
                                  return ListTile(
                                    title: Text(item),
                                    onTap: () {
                                      setState(() {
                                        controller.closeView(item);
                                      });
                                    },
                                  );
                                });
                              },
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

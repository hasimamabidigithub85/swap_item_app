import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'block/watch_list_block.dart';
import 'block/watch_list_event.dart';
import 'block/watch_list_state.dart';
import 'model/stock.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => WatchlistBloc()..add(LoadWatchlist()),
        child: WatchlistScreen(),
      ),
    );
  }
}
class WatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smooth Swap List")),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          return


            ReorderableListView.builder(
            buildDefaultDragHandles: false, // 🔥 important
            itemCount: state.stocks.length,

            onReorder: (oldIndex, newIndex) {
              context.read<WatchlistBloc>().add(
                ReorderWatchlist(oldIndex, newIndex),
              );
            },

            itemBuilder: (context, index) {
              final stock = state.stocks[index];

              return Container(
                key: ValueKey(stock.name),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                child: ReorderableDragStartListener( // 🔥 move here
                  index: index,
                  child: Card(
                    child: ListTile(

                      title: Text(stock.name),
                      subtitle: Text("₹${stock.price}"),
                      trailing: Icon(Icons.drag_indicator), // optional icon
                    ),
                  ),
                ),
              );
            },

          );
        },
      ),
    );
  }
}
// class WatchlistScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Smooth Swap')),
//       body: BlocBuilder<WatchlistBloc, WatchlistState>(
//         builder: (context, state) {
//           return ListView.builder(
//             itemCount: state.stocks.length,
//             itemBuilder: (context, index) {
//               final stock = state.stocks[index];
//
//               return DragTarget<int>(
//                 onWillAccept: (fromIndex) =>
//                 fromIndex != null && fromIndex != index,
//
//                 onAcceptWithDetails: (details) {
//                   context.read<WatchlistBloc>().add(
//                     SwapItems(details.data, index),
//                   );
//                 },
//
//                 builder: (context, candidateData, rejectedData) {
//                   final isHovering = candidateData.isNotEmpty;
//
//                   return Draggable<int>(
//                     data: index,
//
//                     feedback: Material(
//                       color: Colors.transparent,
//                       child: Transform.scale(
//                         scale: 1.05, // 🔥 slight zoom while dragging
//                         child: _item(stock, isHovering, isDragging: true),
//                       ),
//                     ),
//
//                     childWhenDragging: Opacity(
//                       opacity: 0.2,
//                       child: _item(stock, false),
//                     ),
//
//                     child: AnimatedContainer(
//                       duration: Duration(milliseconds: 200),
//                       curve: Curves.easeInOut,
//                       child: _item(stock, isHovering),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _item(Stock stock, bool isHovering, {bool isDragging = false}) {
//     return SizedBox(
//       width: double.infinity,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isHovering
//               ? Colors.green.withOpacity(0.25)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: isDragging
//               ? [
//             BoxShadow(
//               blurRadius: 10,
//               color: Colors.black26,
//             )
//           ]
//               : [],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(stock.name, style: TextStyle(fontSize: 16)),
//             Text("₹${stock.price}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class WatchlistScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Swap Stocks')),
//       body: BlocBuilder<WatchlistBloc, WatchlistState>(
//         builder: (context, state) {
//           return ListView.builder(
//             itemCount: state.stocks.length,
//             itemBuilder: (context, index) {
//               final stock = state.stocks[index];
//
//               return DragTarget<int>(
//                 onWillAccept: (fromIndex) => fromIndex != index, // ✅ important
//                 onAccept: (fromIndex) {
//                   print("SWAP: $fromIndex -> $index"); // debug
//
//                   context.read<WatchlistBloc>().add(
//                     SwapItems(fromIndex, index),
//                   );
//                 },
//                 builder: (context, candidateData, rejectedData) {
//                   final isHovering = candidateData.isNotEmpty;
//
//                   return LongPressDraggable<int>(
//                     data: index,
//
//                     feedback: Material(
//                       color: Colors.transparent,
//                       child: Container(
//                         width: 200,
//                         padding: EdgeInsets.all(12),
//                         color: Colors.blue,
//                         child: Text(
//                           stock.name,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//
//                     childWhenDragging: Opacity(
//                       opacity: 0.3,
//                       child: _buildItem(stock),
//                     ),
//
//                     child: Container(
//                       color: isHovering
//                           ? Colors.green.withOpacity(0.3) // ✅ highlight target
//                           : Colors.transparent,
//                       child: _buildItem(stock),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildItem(Stock stock) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: ListTile(
//         title: Text(stock.name),
//         subtitle: Text("₹${stock.price}"),
//         trailing: Icon(Icons.drag_indicator),
//       ),
//     );
//   }
// }

// class WatchlistScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Stock Watchlist")),
//       body: BlocBuilder<WatchlistBloc, WatchlistState>(
//         builder: (context, state) {
//           return ReorderableListView.builder(
//             itemCount: state.stocks.length,
//             onReorder: (oldIndex, newIndex) {
//               context.read<WatchlistBloc>().add(
//                 ReorderWatchlist(oldIndex, newIndex),
//               );
//             },
//             itemBuilder: (context, index) {
//               final stock = state.stocks[index];
//
//               return Card(
//                 key: ValueKey(stock.name),
//                 margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: ListTile(
//                   title: Text(stock.name),
//                   subtitle: Text("₹${stock.price}"),
//                   leading: Icon(Icons.drag_handle),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: .fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: .center,
//           children: [
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

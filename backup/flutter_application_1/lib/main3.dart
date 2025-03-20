import 'librerias/word_spanish.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor:const Color.fromARGB(255, 94, 255, 0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current  = PalabrasEspanol.obtenerPalabraAleatoria();

   void getNext() {
    current= PalabrasEspanol.obtenerPalabraAleatoria();
    notifyListeners();
  }
   var favoritas = <String>[];

  void toggleFavorite() {
    if (favoritas.contains(current)) {
      favoritas.remove(current);
    } else {
      favoritas.add(current);
    }
    notifyListeners();
  }

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   var selectedIndex = 0;

  @override
  


  Widget build(BuildContext context) {
     // PAGES.... 
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // ...
    return LayoutBuilder(
      builder: (context,Constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                   extended: Constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,    // ← Change to this.
                  onDestinationSelected: (value) {
                     setState(() {
                      selectedIndex = value;
                       });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                   child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

// ...

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favoritas.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favoritas.length} favorites:'),
        ),
        for (var pair in appState.favoritas)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.toString()),
          ),
      ],
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favoritas.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
        //CODIGO ANTERIOR
       return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World'),
            BigCard(pair:pair),   
            SizedBox(height:30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                  ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('ME ENCANTA'),
                ),
                SizedBox(width: 50),


                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next >')
                ),
              ],
            ), 
          ],
        ),     
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });
   final String pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
     );
    return Card(
      color:Color.fromARGB(248, 255, 132, 0), 
      child: Padding(
        padding: const EdgeInsets.all(20),
         child: Text(
          pair.toLowerCase(),
          style: style,
          semanticsLabel: "${pair.toLowerCase()} ${pair.toLowerCase}",
         ),
      ),
    );
  }
}


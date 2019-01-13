import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; // ? Leveraged an external, third-party library

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData( // changing the ui colors
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  @override
  // ! _ enforces privacy
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>(); // stores the word pairings the user favs
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair); // checking to see if has already been saved to favs
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        // Added heart icons for faving
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red :null,
      ),
      onTap: (){ // to notify  framework that the state has changed
        setState(() {
          if (alreadySaved)
            _saved.remove(pair);
          else
            _saved.add(pair);
        });
      },
    );
  }

  RandomWordsState createState() => new RandomWordsState();
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Startup Name Generator'),
      actions: <Widget>[
        new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved) // added list icon that will navigate to saved page
      ],
    ),
    body: _buildSuggestions(),
  );
  }

  void _pushSaved(){
Navigator.of(context).push( // pushes route to navigator stack
  new MaterialPageRoute<void>(
    builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
          return new ListTile(
            title: new Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final List<Widget> divided = ListTile
          .divideTiles(
        context: context,
        tiles: tiles,
      )
          .toList();

      /*
      The builder property returns a Scaffold, containing the app bar for the new route,
      named "Saved Suggestions." The body of the new route consists of a ListView containing
      the ListTiles rows; each row is separated by a divider.
       */
      return new Scaffold(
        appBar: new AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: new ListView(children: divided),
      );
    },
  ),
);
  }

// ? This method builds the ListView that displays the suggested word pairing.
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd)
            return Divider(); /*2*/ // Add a one-pixel-high divider widget before each row in the ListView.

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/ // If you’ve reached the end of the available word pairings, then generate 10 more and add them to the suggestions list.
          }
          return _buildRow(_suggestions[index]);
        });
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

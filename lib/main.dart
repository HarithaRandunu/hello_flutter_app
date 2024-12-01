// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter_app/joke_service.dart';

// void main() => runApp(const MyApp());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

// void main() {
//   runApp(
//       DevicePreview(
//           builder: (context) => MyApp()
//       )
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const JokeListPage(),
    );
  }
}

class JokeListPage extends StatefulWidget {
  const JokeListPage({super.key});

  @override
  _JokeListPageState createState() => _JokeListPageState();
}

class Value_And_ChildText {
  late String value;
  late String childText;

  Value_And_ChildText(this.value, this.childText);
}

class _JokeListPageState extends State<JokeListPage> {
  final JokeService _jokeService = JokeService();
  List<Map<String, dynamic>> _jokesRaw = [];
  bool _isLoading = false;

  final List<String> _dropdownCategories = [
    'Any',
    'Miscellaneous',
    'Programming',
    'Pun',
    'Spooky',
    'Christmas',
  ];

  final List<Value_And_ChildText> _dropDownTypes = [
    Value_And_ChildText("any", "Any"),
    Value_And_ChildText("single", "Single"),
    Value_And_ChildText("twopart", "Two Part")
  ];

  final List<String> _noOfAmount = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  String? _selectedCategory = 'Any';
  String? _selectedType = 'any';
  String? _selectedAmount = '10';

  Future<void> _fetchJokes() async {
    // if (_selectedAmount == '') {
    //   setState(() {
    //     _jokesRaw = [];
    //   });
    //   throw Exception();
    // }
    setState(() => _isLoading = true);
    try {
      _jokesRaw = (await _jokeService.fetchJokesRaw(
          _selectedCategory, _selectedType, _selectedAmount))!;
      setState(() => _isLoading = false);
      if (_jokesRaw == []) {
        throw Exception();
      }
    } catch (e) {
      setState(() {
        _jokesRaw = [];
        _isLoading = false;
      });
      throw Exception('There is an error.');
    }
  }

  @override
  Widget build(BuildContext builderContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Joke App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple.shade100, Colors.white],
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to the Joke App!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    shadows: [Shadow(color: Colors.white, blurRadius: 2)]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Click the button to fetch random jokes!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: DropdownButton(
                              value: _selectedType,
                              items: _dropDownTypes
                                  .map((Value_And_ChildText item) {
                                return DropdownMenuItem(
                                  value: item.value,
                                  child: Text(item.childText),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedType = value;
                                });
                              },
                              dropdownColor: Colors.deepPurple[200],
                              elevation: 30,
                              padding: const EdgeInsets.all(10.0),
                              borderRadius: BorderRadius.circular(12),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                              underline: Container(
                                height: 5,
                                color: Colors.deepPurple[100],
                              ),
                              icon: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownButton(
                      value: _selectedCategory,
                      items: _dropdownCategories.map((String? item) {
                        return DropdownMenuItem(
                            value: item,
                            child: Text(item!),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    DropdownButton(
                        value: _selectedAmount,
                        items: _noOfAmount.map((String? item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item!));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedAmount = value;
                          });
                        }),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _fetchJokes();
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.deepPurple),
                      minimumSize: WidgetStatePropertyAll<Size>(Size(0, 50)),
                      shape: WidgetStatePropertyAll(LinearBorder.none),
                      enableFeedback: true),
                  child: const Text(
                    'Fetch Jokes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildJokeList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJokeList() {
    if (_selectedAmount!.isEmpty && _jokesRaw.isEmpty) {
      return const Center(
        child: Text(
          'Required the amount of jokes you idiot..',
          style: TextStyle(
            fontSize: 18,
            color: Colors.deepOrange,
          ),
        ),
      );
    }
    if (_jokesRaw.isEmpty) {
      return const Center(
          child: Text(
        'No jokes fetched yet.',
        style: TextStyle(
          fontSize: 18,
          color: Colors.deepPurple,
        ),
      ));
    }
    return ListView.builder(
      itemCount: _jokesRaw.length,
      itemBuilder: (context, index) {
        final jokeJson = _jokesRaw[index];
        if ('${jokeJson['type']}' == 'single') {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${jokeJson['joke']}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          );
        } else {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '${jokeJson['setup']}',
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${jokeJson['delivery']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

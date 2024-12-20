import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hello_flutter_app/dependency_injection.dart';
import 'package:hello_flutter_app/joke_service.dart';

// void main() => runApp(const MyApp());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
  DependencyInjection.init();
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
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AnimatedSplashScreen(
        splash: 'assets/jack-in-the-box.gif',
        nextScreen: const JokeListPage(),
        centered: true,
        splashIconSize: 500.0,
        backgroundColor: Colors.white,
        duration: 2800,
        splashTransition: SplashTransition.fadeTransition,
      ),
      // home: const JokeListPage(),
    );
  }
}

class JokeListPage extends StatefulWidget {
  const JokeListPage({super.key});

  @override
  _JokeListPageState createState() => _JokeListPageState();
}

// class Value_And_ChildText {
//   late String value;
//   late String childText;
//
//   Value_And_ChildText(this.value, this.childText);
// }

class _JokeListPageState extends State<JokeListPage> {
  final JokeService _jokeService = JokeService();
  List<Map<String, dynamic>> _jokesRaw = [];
  bool _isLoading = false;
  bool isConnectedToInternet = false;
  bool _isExpanded = false;

  StreamSubscription? _internetConnectionStreamSubscription;

  late String? _selectedCategoriesAsText = 'Any';
  List<String> _selectedCategories = [];
  late String? _selectedBlacklistAsText = '';
  List<String> _selectedBlacklist = [];
  String? _selectedType = 'any';
  String? _selectedAmount = '10';

  void _showType() async {
    final List<String> items = [
      'any',
      'single',
      'twopart',
    ];

    final String? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleSelect(items: items);
      },
    );

    if (result != null) {
      setState(() {
        _selectedType = result;
      });
    } else {
      setState(() {
        _selectedType = 'any';
      });
    }
  }

  void _showCount() async {
    final List<String> items = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
    ];

    final String? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleSelect(items: items);
      },
    );

    if (result != null) {
      setState(() {
        _selectedAmount = result;
      });
    } else {
      setState(() {
        _selectedAmount = '10';
      });
    }
  }

  void _showMultiSelectCategories() async {
    final List<String> items = [
      'Miscellaneous',
      'Programming',
      'Pun',
      'Spooky',
      'Christmas',
    ];

    final List<String>? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    if (result != null) {
      setState(() {
        _selectedCategories = result;
        _listToString(_selectedCategories, _selectedCategoriesAsText!);
      });
    } else {
      setState(() {
        _selectedCategories = [];
        _selectedCategoriesAsText = 'Any';
      });
    }
  }

  void _showBlackList() async {
    final List<String> items = [
      'nsfw',
      'religious',
      'political',
      'racist',
      'sexist',
      'explicit',
    ];

    final List<String>? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    if (result != null) {
      setState(() {
        _selectedBlacklist = result;
        _listToString(_selectedBlacklist, _selectedBlacklistAsText!);
      });
    } else {
      setState(() {
        _selectedBlacklist = [];
        _selectedBlacklistAsText = '';
      });
    }
  }

  String _listToString(List<String> selectedItems, String returnString) {
    setState(() {
      returnString = '';
      returnString = selectedItems.join(',');
    });
    return returnString;
  }

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
          _selectedCategoriesAsText!, _selectedType, _selectedAmount))!;
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
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Center(
            child: Text(
              'Joker',
              style: TextStyle(
                fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
          backgroundColor: Colors.blueGrey,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade100, Colors.white],
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to the Joker App!',
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
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: _showType,
                      child: const Text('Select Type'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: _showMultiSelectCategories,
                      child: const Text('Select Categories'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                        onPressed: _showBlackList,
                        child: const Text('Select Blacklist')),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: _showCount,
                        child: const Text('Select Count')),
                    const SizedBox(
                      width: 10,
                    ),
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
              const SizedBox(height: 16),
              Expanded(
                  child:
                      // _isLoading
                      //     ? const Center(child: CircularProgressIndicator())
                      //     : _buildJokeList(),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                _buildSelected(),
                                // if (!isConnectedToInternet)
                                //   _connectivityState(),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: _buildJokeList(),
                                ),
                              ],
                            ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelected() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isExpanded ? 'Hide Details' : 'Show Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Icon(
                _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.blue,
              )
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    Wrap(
                      children: [
                        Text(
                          'Type :- ',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Chip(
                            label: Text(_selectedType!),
                            backgroundColor: Colors.deepOrange.shade100,
                            side:
                                BorderSide(color: Colors.deepOrange, width: 2)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Amount :- ',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Chip(
                            label: Text(_selectedAmount!),
                            backgroundColor: Colors.green.shade100,
                            side: BorderSide(color: Colors.green, width: 2)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Selected Categories :- ',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      children: _selectedCategories
                          .map((e) => Chip(
                                label: Text(e),
                                side: BorderSide(color: Colors.blue, width: 2),
                                backgroundColor: Colors.blue.shade100,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Selected Blacklist :- ',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      children: _selectedBlacklist
                          .map((e) => Chip(
                                label: Text(e),
                                side: BorderSide(color: Colors.red, width: 2),
                                backgroundColor: Colors.red.shade100,
                              ))
                          .toList(),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        )
      ],
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
                padding: const EdgeInsets.all(10.0),
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
                    style: const TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${jokeJson['delivery']}',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
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

class SingleSelect extends StatefulWidget {
  final List<String> items;
  const SingleSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingleSelectState();
}

class _SingleSelectState extends State<SingleSelect> {
  String? _selectedItem;

  void _itemChange(String itemValue) {
    setState(() {
      _selectedItem = itemValue;
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Item'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => RadioListTile(
                    value: item,
                    groupValue: _selectedItem,
                    title: Text(item),
                    onChanged: (value) => _itemChange(value!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isChecked) {
    setState(() {
      if (isChecked) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Category'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

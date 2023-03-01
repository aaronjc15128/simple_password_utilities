import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  
  String currentTheme = "Dark";
  Icon iconTheme = const Icon(Icons.nightlight_rounded);

  void changeTheme() {
    setState(() {
      if (currentTheme == "Dark") {
        currentTheme = "Light";
        iconTheme = const Icon(Icons.wb_sunny_rounded);
      }
      else if (currentTheme == "Light") {
        currentTheme = "Dark";
        iconTheme = const Icon(Icons.nightlight_rounded);
      }
    });
  }


  Widget appBarText = const Text("Password Generator");

  int navBarIndex = 0;

  void navBarTap(int index) {
    setState(() {
      navBarIndex = index;

      if (navBarIndex == 0) {
        appBarText = const Text("Password Generator");
      }
      else if (navBarIndex == 1) {
        appBarText = const Text("Password Strength Checker");
      }
    });
  }

  
  String password = "password will generate here";

  List lowercase = const ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
  List uppercase = const ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
  List numbers = const ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List symbols = const ["!", "#", "%", "&", '"', "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "]", "^", "_", "'", "{", "|", "}", "~"];

  void generatePassword(int numberCharacters, bool allowedCapitals, bool allowedNumbers, bool allowedSymbols){
    List allowedCharacters = [];
    allowedCharacters += lowercase;
    if (allowedCapitals) {allowedCharacters += uppercase;}
    if (allowedNumbers) {allowedCharacters += numbers;}
    if (allowedSymbols) {allowedCharacters += symbols;}

    password = "";
    final random = Random();

    setState(() {
      for (var i = 0; i < numberCharacters; i++) {
        password += allowedCharacters[random.nextInt(allowedCharacters.length)];
      }
    });
  }

  double lengthSliderValue = 20;
  bool capitalsSwitchValue = true;
  bool numbersSwitchValue = true;
  bool symbolsSwitchValue = true;


  String passwordInput = "Password";
  double passwordScore = 0;
  String roundedScore = "0";
  String rankScore = "Poor";
  MaterialColor colorScore = Colors.red;

  void checkPassword(String userpassword) {
    /*
      - Password score is calculated out of 3.0
      - You gain +0.1 score for every character no matter the type
      - You then lose score depening on certain parameters

        Refer to the following table for values:

        Consecutive same characters: -0.08 (-0.11 total)
        Consecutive same types     : -0.03


      - You then gain score depending on the types of characters,
        and how many times they show up
      
        Refer to the following table for values:

        Lowercase:            /            /            / all = 0.0
        Uppercase: 1st = +0.3 / 2nd = +0.2 / 3rd = +0.1 / all = 0.0
        Numbers  : 1st = +0.4 / 2nd = +0.2 / 3rd = +0.1 / all = 0.0
        Symbols  : 1st = +0.5 / 2nd = +0.3 / 3rd = +0.1 / all = 0.0

      - The score is then multiplied by 33.33 and rounded to an integer
    */
    
    passwordScore = 0;

    passwordScore += (userpassword.length) / 10;    // Length

    String prevChar = "";
    int countUppercase = 0;
    int countNumbers = 0;
    int countSymbols = 0;
    for (var i = 0; i < userpassword.length; i++) {
      String char = userpassword[i];
      if (char == prevChar) {
        passwordScore -= 0.08;
      }
      if (uppercase.contains(char)) {
        if (uppercase.contains(prevChar)) {
          passwordScore -= 0.03;
        }
        if (countUppercase == 0) {
          countUppercase += 1;
          passwordScore += 0.3;
        }
        else if (countUppercase == 1) {
          countUppercase += 1;
          passwordScore += 0.2;
        }
        else if (countUppercase == 2) {
          countUppercase += 1;
          passwordScore += 0.1;
        }
        else if (countUppercase == 3) {
          countUppercase += 1;
          passwordScore += 0.0;
        }
      }
      else if (numbers.contains(char)) {
        if (numbers.contains(prevChar)) {
          passwordScore -= 0.03;
        }
        if (countNumbers == 0) {
          countNumbers += 1;
          passwordScore += 0.4;
        }
        else if (countNumbers == 1) {
          countNumbers += 1;
          passwordScore += 0.2;
        }
        else if (countNumbers == 2) {
          countNumbers += 1;
          passwordScore += 0.1;
        }
        else if (countNumbers == 3) {
          countNumbers += 1;
          passwordScore += 0.0;
        }
      }
      else if (symbols.contains(char)) {
        if (symbols.contains(prevChar)) {
          passwordScore -= 0.03;
        }
        if (countSymbols == 0) {
          countSymbols += 1;
          passwordScore += 0.5;
        }
        else if (countSymbols == 1) {
          countSymbols += 1;
          passwordScore += 0.3;
        }
        else if (countSymbols == 2) {
          countSymbols += 1;
          passwordScore += 0.1;
        }
        else if (countSymbols == 3) {
          countSymbols += 1;
          passwordScore += 0.0;
        }
      }
      prevChar = char;
    }
    
    if (passwordScore >= 3) {
      rankScore = "Strong";
      colorScore = Colors.teal;
    }
    else if (passwordScore >= 2) {
      rankScore = "Good";
      colorScore = Colors.green;
    }
    else if (passwordScore >= 1) {
      rankScore = "Fair";
      colorScore = Colors.orange;
    }
    else if (passwordScore >= 0) {
      rankScore = "Poor";
      colorScore = Colors.red;
    }

    setState(() {
      if (passwordScore > 3) {passwordScore = 3;}
      passwordScore *= 33.33;
      roundedScore = passwordScore.toStringAsFixed(0);
    });
  }


  List<Widget> pages() => <Widget>[
    /* Generator        */ Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      
      children: <Widget>[
        /* Box     */ Container(
          margin: const EdgeInsets.fromLTRB(60, 0, 60, 0),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 128, 128, 128))
          ),
          child: Text(password, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        ),
        /* Button  */ Container(
          margin: const EdgeInsets.fromLTRB(90, 20, 90, 60),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              textStyle: const TextStyle(fontSize: 16)
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: password));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.copy_all),
                Text(" Copy to Clipboard")
              ]
            ),
          ),
        ),
        /* Slider  */ Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(" Length", style: TextStyle(fontSize: 18)),
            Slider(
              value: lengthSliderValue,
              min: 1,
              max: 30,
              divisions: 29,
              label: lengthSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  lengthSliderValue = value;
                });
              },
              inactiveColor: const Color.fromARGB(255, 128, 128, 128),
              activeColor: Colors.tealAccent,
              thumbColor: Colors.teal,
            ),
          ]
        ),
        /* Toggle  */ Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(" Capitals", style: TextStyle(fontSize: 18)),
            Switch(
              value: capitalsSwitchValue,
              onChanged: (value) {
                setState(() {
                  capitalsSwitchValue = value;
                });
              },
              activeTrackColor: Colors.tealAccent,
              activeColor: Colors.teal,
            )
          ]
        ),
        /* Toggle  */ Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(" Numbers", style: TextStyle(fontSize: 18)),
            Switch(
              value: numbersSwitchValue,
              onChanged: (value) {
                setState(() {
                  numbersSwitchValue = value;
                });
              },
              activeTrackColor: Colors.tealAccent,
              activeColor: Colors.teal,
            )
          ]
        ),
        /* Toggle  */ Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(" Symbols", style: TextStyle(fontSize: 18)),
            Switch(
              value: symbolsSwitchValue,
              onChanged: (value) {
                setState(() {
                  symbolsSwitchValue = value;
                });
              },
              activeTrackColor: Colors.tealAccent,
              activeColor: Colors.teal,
            )
          ]
        ),
        /* Button  */ Container(
          margin: const EdgeInsets.fromLTRB(90, 20, 90, 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              textStyle: const TextStyle(fontSize: 16)
            ),
            onPressed: () {
              generatePassword(lengthSliderValue.toInt(), capitalsSwitchValue, numbersSwitchValue, symbolsSwitchValue);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.get_app_rounded),
                Text(" Generate")
              ],
            )
          ),
        )
      ],
    ),
    /* Strength Checker */ Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>[
        /* Score */ Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(60, 10, 60, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(" Score: ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
                  Text(roundedScore, style: const TextStyle(fontSize: 22))
                ]
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(60, 10, 60, 20),
              child: Text(rankScore, style: TextStyle(color: colorScore, fontSize: 22))
            ),
          ],
        ),
        /* Input */ Container(
          margin: const EdgeInsets.fromLTRB(60, 50, 60, 0),

          child: TextField(
            autocorrect: false,
            textAlign: TextAlign.center,
            cursorColor: Colors.white,

            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r"\s"))
            ],

            decoration: const InputDecoration(
              label: Center(child: Text("Password")),
              labelStyle: TextStyle(color: Color.fromARGB(255, 240, 240, 240)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
            ),

            onChanged: (text) {
              passwordInput = text;
              checkPassword(passwordInput);
            },
          )
        ),
        /* Button  */ Container(
          margin: const EdgeInsets.fromLTRB(90, 20, 90, 60),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              textStyle: const TextStyle(fontSize: 16)
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: passwordInput));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.copy_all),
                Text(" Copy to Clipboard")
              ]
            ),
          ),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Password Generator",
      darkTheme: ThemeData(brightness: Brightness.dark),
      theme: ThemeData(brightness: Brightness.light),
      themeMode: ThemeMode.system,
      
      home: Scaffold(
        appBar: AppBar(
          title: appBarText,
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: const [
                    SizedBox(height: 12),
                    Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/img.jpg'),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("Password Generator", style: TextStyle(fontSize: 22)),
                    SizedBox(height: 2),
                    Text("Created by Aaron Chauhan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
              ListTile(
                leading: iconTheme,
                title: Text("$currentTheme Theme"),
                onTap: changeTheme,
              ),
              const ListTile(
                leading: Icon(Icons.info_outline_rounded),
                title: Text("About"),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.get_app_rounded),
              activeIcon: Icon(Icons.get_app_rounded),
              label: "Generator",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline_rounded),
              activeIcon: Icon(Icons.check_circle_rounded),
              label: "Strength Checker",
            ),
          ],
          currentIndex: navBarIndex,
          onTap: navBarTap,
        ),

        body: pages()[navBarIndex]
      ),
    );
  }
}

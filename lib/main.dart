import 'package:flutter/material.dart';

void main()
{
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget
{
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp>
{
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme()
  {
    setState(()
    {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'CALCULATOR APPLICATION',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      themeMode: _themeMode,
      home: CalculatorHomePage(toggleTheme: _toggleTheme),
    );
  }
}

class CalculatorHomePage extends StatefulWidget
{
  final VoidCallback toggleTheme;

  CalculatorHomePage({required this.toggleTheme});

  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage>
{
  String _output = "0";
  String _input = "";
  double _num1 = 0.0;
  double _num2 = 0.0;
  double _memory = 0.0;
  String _operation = "";
  List<String> _history = [];
  bool _isHistoryVisible = false;

  void buttonPressed(String buttonText)
  {
    if (buttonText == "C")
    {
      _input = "";
      _num1 = 0.0;
      _num2 = 0.0;
      _operation = "";
      _history.clear();
    } else if (buttonText == "⌫")
    {
      if (_input.isNotEmpty)
      {
        _input = _input.substring(0, _input.length - 1);
      }
    } else if (buttonText == "M+")
    {
      _memory += double.tryParse(_input) ?? 0.0;
      _input = "";
    } else if (buttonText == "M-")
    {
      _memory -= double.tryParse(_input) ?? 0.0;
      _input = "";
    } else if (buttonText == "MR")
    {
      _input = _memory.toString();
    } else if (buttonText == "MC")
    {
      _memory = 0.0;
    } else if (buttonText == "%")
    {
      _input = (double.tryParse(_input) ?? 0.0 / 100).toString();
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
      _num1 = double.parse(_input);
      _operation = buttonText;
      _input = "";
    } else if (buttonText == "=")
    {
      _num2 = double.parse(_input);

      if (_operation == "+")
      {
        _output = (_num1 + _num2).toString();
      } else if (_operation == "-")
      {
        _output = (_num1 - _num2).toString();
      } else if (_operation == "×")
      {
        _output = (_num1 * _num2).toString();
      } else if (_operation == "÷")
      {
        _output = (_num1 / _num2).toString();
      }

      _history.add("$_num1 $_operation $_num2 = $_output");

      _num1 = 0.0;
      _num2 = 0.0;
      _operation = "";
      _input = _output;
    } else {
      _input += buttonText;
    }
    setState(() {
      _output = _input.isEmpty ? "0" : _input;
    });
  }

  Widget buildButton(String buttonText, Color buttonColor, {double textSize = 24.0}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: textSize, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed: () => buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALCULATOR'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
            alignment: Alignment.center,
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              setState(() {
                _isHistoryVisible = !_isHistoryVisible;
              });
            },
            alignment: Alignment.center,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          if (_isHistoryVisible)
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.white60,
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index)
                  {
                    return ListTile(
                      title: Text(
                        _history[index],
                        style: TextStyle(fontSize: 18.0),
                      ),
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20.0),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("M+", Colors.grey),
                  buildButton("M-", Colors.grey),
                  buildButton("MR", Colors.grey),
                  buildButton("MC", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("7", Colors.grey),
                  buildButton("8", Colors.grey),
                  buildButton("9", Colors.grey),
                  buildButton("÷", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("4", Colors.grey),
                  buildButton("5", Colors.grey),
                  buildButton("6", Colors.grey),
                  buildButton("×", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("1", Colors.grey),
                  buildButton("2", Colors.grey),
                  buildButton("3", Colors.grey),
                  buildButton("-", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton(".", Colors.grey),
                  buildButton("0", Colors.grey),
                  buildButton("%", Colors.grey),
                  buildButton("+", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("C", Colors.redAccent),
                  buildButton("⌫", Colors.lightBlueAccent),
                  buildButton("=", Colors.green, textSize: 32.0),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

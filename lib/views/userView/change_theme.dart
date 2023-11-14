import 'package:flutter/material.dart';

class ChangeTheme extends StatefulWidget {

  const ChangeTheme({Key? key})
      : super(key: key);

  @override
  State<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<String> colours = ["Red", "Orange", "Yellow", "Lime", "Green", "Teal", "Cyan", "Blue", "Indigo", 
      "Purple", "Pink", "Brown", "Grey", "Black"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SETTINGS",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      body: ListView.builder(
          itemCount: colours.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(colours[index]),
              leading: Icon(
                Icons.circle,
                color: _getColorFromName(colours[index]),
              ),
              onTap: () {
                Navigator.pop(context, _getColorFromName(colours[index]));
              },
            );
          },
        ),
    );
  }

  Color _getColorFromName(String colorName) {
    // Map your color names to corresponding Colors
    Map<String, Color> colorMap = {
      "Red": Colors.red, 
      "Orange": Colors.orange,
      "Yellow": Colors.yellow,
      "Lime": Colors.lime,
      "Green": Colors.green,
      "Teal": Colors.teal,
      "Cyan": Colors.cyan,
      "Blue": Colors.blue,
      "Indigo": Colors.indigo,
      "Purple": Colors.purple,
      "Pink": Colors.pink,
      "Brown": Colors.brown,
      "Grey": Colors.grey,
      "Black": Colors.black
    };

    // Return the color corresponding to the given name, or a default color if not found
    return colorMap[colorName] ?? Colors.blue;
  }
}
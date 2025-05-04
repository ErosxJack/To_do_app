import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  final String title;

  Task({required this.title});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To-Do App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          labelStyle: TextStyle(color: Colors.teal[800]),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.teal[900]),
          bodyMedium: TextStyle(color: Colors.teal[800]),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: ToDoScreen(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToDoScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onToggleTheme;

  ToDoScreen({required this.isDark, required this.onToggleTheme});

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final List<Task> _tasks = [];
  final List<Task> _completedTasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(Task(title: _controller.text.trim()));
      _controller.clear();
    });
  }

  void _completeTask(int index) {
    setState(() {
      _completedTasks.add(_tasks[index]);
      _tasks.removeAt(index);
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
          title: Text(
            'My Tasks',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.checklist),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CompletedTasksPage(completedTasks: _completedTasks),
                ),
              );
            },
          ),
          actions: [
            Row(
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                Switch(
                  value: isDark,
                  onChanged: widget.onToggleTheme,
                  activeColor: Colors.amber,
                ),
                SizedBox(width: 8),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter task',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addTask,
              icon: Icon(Icons.add),
              label: Text('Add Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text("No tasks added yet."))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Checkbox(
                              value: false,
                              onChanged: (_) => _completeTask(index),
                              activeColor: Colors.green,
                            ),
                            title: Text(_tasks[index].title),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompletedTasksPage extends StatelessWidget {
  final List<Task> completedTasks;

  CompletedTasksPage({required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Tasks"),
        leading: BackButton(),
      ),
      body: completedTasks.isEmpty
          ? Center(child: Text("No completed tasks yet."))
          : ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    completedTasks[index].title,
                    style: TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                );
              },
            ),
    );
  }
}

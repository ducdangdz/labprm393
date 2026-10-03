import 'package:flutter/material.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 - Flutter UI Fundamentals',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      themeMode: themeMode,

      home: Lab4Home(
        isDark: themeMode == ThemeMode.dark,
        onThemeChanged: (value) {
          setState(() {
            themeMode =
                value ? ThemeMode.dark : ThemeMode.light;
          });
        },
      ),
    );
  }
}

class Lab4Home extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const Lab4Home({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,

      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lab 4 - UI Fundamentals',
          ),

          bottom: const TabBar(
            isScrollable: true,

            tabs: [
              Tab(
                text: 'Exercise 1',
              ),
              Tab(
                text: 'Exercise 2',
              ),
              Tab(
                text: 'Exercise 3',
              ),
              Tab(
                text: 'Exercise 4',
              ),
              Tab(
                text: 'Exercise 5',
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            const CoreWidgetsDemo(),
            const InputControlsDemo(),
            const LayoutDemo(),

            ScaffoldDemo(
              isDark: isDark,
              onThemeChanged: onThemeChanged,
            ),

            const FixErrorsDemo(),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// EXERCISE 1
// Text, Image, Icon, Card, ListTile
// ======================================================

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),

      children: [

        const Text(
          'Movie App',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        const Icon(
          Icons.movie,
          size: 70,
        ),

        const SizedBox(height: 20),

        Image.network(
          'https://picsum.photos/800/400',

          height: 220,

          fit: BoxFit.cover,

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  size: 60,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),

            title: const Text(
              'Movie Explorer',
            ),

            subtitle: const Text(
              'Flutter Core Widgets',
            ),

            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// EXERCISE 2
// Slider, Switch, Radio, DatePicker
// ======================================================

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() =>
      _InputControlsDemoState();
}

class _InputControlsDemoState
    extends State<InputControlsDemo> {

  double volume = 50;

  bool notifications = true;

  String category = 'Action';

  DateTime? selectedDate;

  Future<void> pickDate() async {

    final date = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2020),

      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: const EdgeInsets.all(16),

      children: [

        Text(
          'Volume: ${volume.round()}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        Slider(
          value: volume,

          min: 0,

          max: 100,

          onChanged: (value) {

            setState(() {
              volume = value;
            });

          },
        ),

        const Divider(),

        SwitchListTile(
          title: const Text(
            'Notifications',
          ),

          value: notifications,

          onChanged: (value) {

            setState(() {
              notifications = value;
            });

          },
        ),

        const Divider(),

        const Text(
          'Movie Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        RadioListTile<String>(
          title: const Text(
            'Action',
          ),

          value: 'Action',

          groupValue: category,

          onChanged: (value) {

            setState(() {
              category = value!;
            });

          },
        ),

        RadioListTile<String>(
          title: const Text(
            'Comedy',
          ),

          value: 'Comedy',

          groupValue: category,

          onChanged: (value) {

            setState(() {
              category = value!;
            });

          },
        ),

        RadioListTile<String>(
          title: const Text(
            'Drama',
          ),

          value: 'Drama',

          groupValue: category,

          onChanged: (value) {

            setState(() {
              category = value!;
            });

          },
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(

          onPressed: pickDate,

          icon: const Icon(
            Icons.calendar_month,
          ),

          label: Text(

            selectedDate == null

                ? 'Choose Date'

                : 'Date: '
                    '${selectedDate!.day}/'
                    '${selectedDate!.month}/'
                    '${selectedDate!.year}',
          ),
        ),
      ],
    );
  }
}

// ======================================================
// EXERCISE 3
// Column, Row, Padding, ListView
// ======================================================

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  final List<String> movies = const [
    'Inception',
    'Interstellar',
    'The Dark Knight',
    'Avatar',
    'Avengers: Endgame',
    'Toy Story',
  ];

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'Popular Movies',

            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              const Icon(
                Icons.local_fire_department,
              ),

              const SizedBox(width: 8),

              Text(
                '${movies.length} movies available',
              ),
            ],
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(

              itemCount: movies.length,

              itemBuilder: (context, index) {

                return Card(

                  child: ListTile(

                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                      ),
                    ),

                    title: Text(
                      movies[index],
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// EXERCISE 4
// Scaffold, AppBar, FAB, ThemeData, Dark Mode
// ======================================================

class ScaffoldDemo extends StatelessWidget {

  final bool isDark;

  final ValueChanged<bool> onThemeChanged;

  const ScaffoldDemo({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Movie Home',
        ),

        actions: [

          Switch(
            value: isDark,

            onChanged: onThemeChanged,
          ),
        ],
      ),

      body: Center(

        child: Text(

          isDark
              ? 'Dark Mode'
              : 'Light Mode',

          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        onPressed: () {

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(
              content: Text(
                'FAB clicked',
              ),
            ),
          );
        },

        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

// ======================================================
// EXERCISE 5
// Fix common Flutter UI errors
// ======================================================

class FixErrorsDemo extends StatefulWidget {
  const FixErrorsDemo({super.key});

  @override
  State<FixErrorsDemo> createState() =>
      _FixErrorsDemoState();
}

class _FixErrorsDemoState
    extends State<FixErrorsDemo> {

  int counter = 0;

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        // SingleChildScrollView
        // giúp tránh overflow
        Expanded(

          flex: 1,

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(16),

            child: Column(

              children: [

                const Text(
                  'Common UI Error Fixes',

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'SingleChildScrollView '
                  'helps prevent overflow '
                  'on small screens.',
                ),

                const SizedBox(height: 15),

                Text(
                  'Counter: $counter',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(

                  onPressed: () {

                    // setState dùng để cập nhật UI
                    setState(() {
                      counter++;
                    });
                  },

                  child: const Text(
                    'Increase Counter',
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(

                  onPressed: () async {

                    final date =
                        await showDatePicker(

                      context: context,

                      initialDate:
                          DateTime.now(),

                      firstDate:
                          DateTime(2020),

                      lastDate:
                          DateTime(2035),
                    );

                    if (date != null &&
                        mounted) {

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(

                        SnackBar(

                          content: Text(
                            'Selected: '
                            '${date.day}/'
                            '${date.month}/'
                            '${date.year}',
                          ),
                        ),
                      );
                    }
                  },

                  child: const Text(
                    'Open DatePicker',
                  ),
                ),
              ],
            ),
          ),
        ),

        const Divider(),

        const Padding(
          padding: EdgeInsets.all(8),

          child: Text(
            'ListView inside Expanded',
          ),
        ),

        // Expanded giúp ListView
        // không gây overflow trong Column
        Expanded(

          flex: 2,

          child: ListView.builder(

            itemCount: 10,

            itemBuilder: (context, index) {

              return ListTile(

                leading: CircleAvatar(
                  child: Text(
                    '${index + 1}',
                  ),
                ),

                title: Text(
                  'Item ${index + 1}',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
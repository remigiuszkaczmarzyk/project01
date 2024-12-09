import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'WybranyDzienScreen.dart';

class KalendarzScreen extends StatefulWidget {
  const KalendarzScreen({Key? key}) : super(key: key);

  @override
  _KalendarzScreenState createState() => _KalendarzScreenState();
}

class _KalendarzScreenState extends State<KalendarzScreen> {
  DateTime? _selectedDay; // Zmienna do przechowywania wybranego dnia

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendarz'),
      ),
      body: TableCalendar(
        firstDay: DateTime(2000),
        lastDay: DateTime(2100),
        focusedDay: DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WybranyDzienScreen(selectedDay: selectedDay),
            ),
          );
        },
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
        ),
      ),
    );
  }
}

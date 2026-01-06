import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Config {
  static final monthCount = 240;
}

class MonthCalendarScreen extends StatefulWidget {
  const MonthCalendarScreen({super.key});

  @override
  State<MonthCalendarScreen> createState() => _MonthCalendarScreenState();
}

class _MonthCalendarScreenState extends State<MonthCalendarScreen> {
  
  final int _monthCount = Config.monthCount; // 20 years
  final int _monthBefore = Config.monthCount ~/ 2;
  late final DateTime _startMonth = DateTime(DateTime.now().year, DateTime.now().month - _monthBefore);

  late final PageController _pageController =
      PageController(initialPage: _monthBefore);

  DateTime _monthFromIndex(int index) {
    return DateTime(_startMonth.year, _startMonth.month + index);
  }

  int _daysInMonth(DateTime month) {
    final firstDayNextMonth =
        DateTime(month.year, month.month + 1, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Hours Calendar'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _monthCount,
        itemBuilder: (context, index) {
          final month = _monthFromIndex(index);
          return _MonthView(
            month: month,
            daysInMonth: _daysInMonth(month),
            onPreviousMonth: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300), 
                curve: Curves.easeOut
              );
            },
            onNextMonth: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300), 
                curve: Curves.easeOut
              );
            },
          );
        },
      ),
    );
  }
}

class _MonthView extends StatelessWidget {
  final DateTime month;
  final int daysInMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _MonthView({
    required this.month,
    required this.daysInMonth,
    required this.onPreviousMonth,
    required this.onNextMonth
  });

  @override
  Widget build(BuildContext context) {
    final monthTitle = DateFormat('MMMM yyyy').format(month);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  onPreviousMonth();
                }, 
                icon: const Icon(Icons.chevron_left)
              ),

              Expanded(
                child: Text(
                  monthTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  )
                )
              ),

              IconButton(
                onPressed: () {
                  onNextMonth();
                }, 
                icon: const Icon(Icons.chevron_right)
              )
            ],
          ),
        ),

        const Divider(height: 1),

        Expanded(
          child: ListView.builder(
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = DateTime(
                month.year,
                month.month,
                index + 1,
              );

              return _DayTile(day: day);
            },
          ),
        ),
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  final DateTime day;

  const _DayTile({required this.day});

  @override
  Widget build(BuildContext context) {
    final weekday = DateFormat('EEE').format(day);
    final date = DateFormat('d').format(day);

    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekday,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      title: const Text('0h worked'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // open add / view work time
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final int numberOfMonths = 12; // Total number of months to show
  int selectedIndex = 0; // Index of the selected month
  List<String> dates = []; // List to store the dates shown below the months

  @override
  void initState() {
    super.initState();
    _loadDates();
  }

  // Load saved dates from SharedPreferences
  _loadDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dates = prefs.getStringList('dates') ?? [];
    });
  }

  // Save the current date to SharedPreferences
  _saveDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dates.add(date); // Add the current date to the list
    prefs.setStringList('dates', dates); // Save the updated list of dates
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = _generateMonthList(now);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 50),
          // Heading and Search Icon Row
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Hey Naresh!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 50),

          // Horizontal scrollable list of months
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: months.map((month) {
                final index = months.indexOf(month);
                final isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    print("Selected Month: ${month["label"]}");
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 9.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color.fromRGBO(236, 223, 204, 1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.grey, width: isSelected ? 0 : 1),
                    ),
                    child: Text(
                      month["label"],
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.black : Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 40), // Space between months and today section

          // Today's Date Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // Save today's date to the list and navigate
                String todayDate = DateFormat("d MMMM yyyy").format(DateTime.now());
                _saveDate(todayDate);
                print("Navigating to today's sentiment screen.");
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blueAccent),
                    SizedBox(width: 10),
                    Text(
                      "Today's Date: ${DateFormat("d MMMM yyyy").format(DateTime.now())}",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Show list of dates saved (including today's date)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Previous Dates:",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                ...dates.map((date) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(date),
                    onTap: () {
                      print("Navigating to sentiment for $date");
                      // Navigate to the sentiment screen for that date
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateMonthList(DateTime currentDate) {
    List<Map<String, dynamic>> monthList = [];

    for (int i = 0; i < numberOfMonths; i++) {
      DateTime monthDate = DateTime(currentDate.year, currentDate.month - i, 1);
      String label = i == 0
          ? "This month"
          : DateFormat("MMMM").format(monthDate); // Only the month name
      monthList.add({
        "label": label,
        "date": monthDate, // Store the exact date for comparison
      });
    }

    return monthList;
  }
}

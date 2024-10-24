import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LastWorkingDayModal extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onSave;

  const LastWorkingDayModal({
    Key? key,
    this.initialTime,
    required this.onSave,
  }) : super(key: key);

  @override
  _LastWorkingDayModalState createState() => _LastWorkingDayModalState();
}

class _LastWorkingDayModalState extends State<LastWorkingDayModal> {
  late int selectedHour;
  late int selectedMinute;
  late bool isPM;
  bool isStartTime = true; // Track which tab is selected

  @override
  void initState() {
    super.initState();
    final initialTime = widget.initialTime ?? TimeOfDay.now();
    selectedHour = initialTime.hourOfPeriod;
    selectedMinute = initialTime.minute;
    isPM = initialTime.period == DayPeriod.pm;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE8E8E8),
                  width: 3,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'Edit last working day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          //const SizedBox(height: 8),
          // Tab-like buttons

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isStartTime = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isStartTime
                          ? Colors.transparent
                          : const Color(0xFFF5F5F5),
                      border: Border.all(
                        color: isStartTime
                            ? Colors.transparent
                            : const Color(0xFFE8E8E8),
                        width: 1,
                      ),
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Started at',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isStartTime
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isStartTime ? Colors.black : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isStartTime = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !isStartTime
                          ? Colors.transparent
                          : const Color(0xFFF5F5F5),
                      border: Border.all(
                        color: !isStartTime
                            ? Colors.transparent
                            : const Color(0xFFE8E8E8),
                        width: 1,
                      ),
                      //borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Finished at',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: !isStartTime
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: !isStartTime ? Colors.black : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 24),
          const Gap(24),
          Text(
            isStartTime
                ? 'Edit your entry time here:'
                : 'Edit your exit time here:',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          //const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours
                Expanded(
                  child: ListWheelScrollView(
                    itemExtent: 50,
                    diameterRatio: 1.5,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = index + 1;
                      });
                    },
                    children: List.generate(12, (index) {
                      final hour = index + 1;
                      final isSelected = hour == selectedHour;
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          hour.toString(),
                          style: TextStyle(
                            fontSize: isSelected ? 24 : 20,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Minutes
                Expanded(
                  child: ListWheelScrollView(
                    itemExtent: 50,
                    diameterRatio: 1.5,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = index * 5;
                      });
                    },
                    children: List.generate(12, (index) {
                      final minute = index * 5;
                      final isSelected = minute == selectedMinute;
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          minute.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: isSelected ? 24 : 20,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // AM/PM
                Expanded(
                  child: ListWheelScrollView(
                    itemExtent: 50,
                    diameterRatio: 1.5,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        isPM = index == 1;
                      });
                    },
                    children: ['AM', 'PM'].map((period) {
                      final isSelected = (period == 'PM') == isPM;
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          period,
                          style: TextStyle(
                            fontSize: isSelected ? 24 : 20,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32), // Increased spacing before button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final hour = isPM ? selectedHour + 12 : selectedHour;
                  widget.onSave(TimeOfDay(hour: hour, minute: selectedMinute));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Increased border radius
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

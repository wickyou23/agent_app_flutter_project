import 'package:agent_app/res/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSlot {
  TimeSlot({
    required this.title,
    this.hrs = 0,
    this.min = 0,
    this.secs = 0,
  });

  final String title;
  final int secs;
  final int hrs;
  final int min;
}

class TimeslotWidget extends StatelessWidget {
  TimeslotWidget({Key? key, this.timeSelected, required this.onSelected})
      : super(key: key);

  final TimeSlot? timeSelected;
  final Function(TimeSlot) onSelected;

  final List<TimeSlot> _timeList = [
    TimeSlot(title: '09:00AM', hrs: 9),
    TimeSlot(title: '10:00AM', hrs: 10),
    TimeSlot(title: '11:00AM', hrs: 11),
    TimeSlot(title: '01:00PM', hrs: 13),
    TimeSlot(title: '02:00PM', hrs: 14),
    TimeSlot(title: '03:00PM', hrs: 15),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Strings.selectTimeslot.localize(context)',
            style: context.theme.textTheme.body,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: GridView.builder(
            itemCount: _timeList.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 1,
            ),
            itemBuilder: (_, idx) {
              final item = _timeList[idx];
              return Container(
                alignment: Alignment.centerLeft,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    item.title,
                    style: context.theme.textTheme.body.copyWith(
                      color: (timeSelected?.hrs == item.hrs)
                          ? Colors.blue
                          : Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    onSelected(item);
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

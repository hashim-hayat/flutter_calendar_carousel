import 'package:benefits/src/api/model/request/timeoff_service_request.dart';
import 'package:benefits/src/api/model/response/timeoff.dart';
import 'package:benefits/src/app/constants.dart';
import 'package:benefits/src/app/home/timeoff/leave-request/leave_request_bloc.dart';
import 'package:benefits/src/app/widget/pending_action.dart';
import 'package:benefits/src/app/widget/sticky_bottom_button.dart';
import 'package:benefits/src/core/bloc/bloc_event_state_builder.dart';
import 'package:benefits/src/core/bloc/page_event_state_type.dart';
import 'package:benefits/src/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';

class DateRangePickerScreen extends StatefulWidget {
  static final String routeName = 'date_range_picker';
  final LeaveRequestBloc leaveRequestBloc;
  final Function nextPage;

  DateRangePickerScreen(this.leaveRequestBloc, {this.nextPage});

  @override
  DateRangePickerScreenState createState() {
    return DateRangePickerScreenState();
  }
}

class DateRangePickerScreenState extends State<DateRangePickerScreen> {
  final rowDivider = Container(
    height: 2.0,
    color: Colors.black12,
    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
  );

  var startWeekDay = "";
  var startMonthDay = "";
  var startYear = "";

  var endWeekdDay = "";
  var endMonthDay = "";
  var endYear = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocEventStateBuilder<LeaveRequestBlocEvent, LeaveRequestBlocState>(
        bloc: widget.leaveRequestBloc,
        builder: (BuildContext context, LeaveRequestBlocState state) {
          dateRangePicked([state?.body?.dateFrom, state?.body?.dateTo]);
          var holidays = state?.holidays?.isNotEmpty == true
              ? state?.holidays?.map((it) => listDatesBetween([it.dateFrom, it.dateTo]))?.reduce((a, b) => a + b) ??
                  List<DateTime>()
              : List<DateTime>();
          var intersection =
              buildHolidays(state?.holidays, listDatesBetween([state?.body?.dateFrom, state?.body?.dateTo]));
//          var currentBalance =
//              state?.leaveBalance?.firstWhere((it) => it.leaveTypeId == state.selectedLeaveType.id, orElse: () => null);
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: createStickyBottomButton(
                context, 'Continue', state?.invalid == false ? () => widget.nextPage(1) : null),
            resizeToAvoidBottomPadding: false,
            body: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.00, right: 16.00, left: 16.00),
                        child: Container(
                            margin: const EdgeInsets.only(top: 20.0, bottom: 16.00),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 18.0),
                                      child: Text(
                                        "First day out of office",
                                        style: TextStyle(
                                            fontSize: 14.00,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(62, 69, 87, 1)),
                                      ),
                                    ),
                                    Text(
                                      startWeekDay,
                                      style: TextStyle(fontSize: 18.00, color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        height: 1,
                                        color: Color.fromRGBO(175, 185, 205, 0.3),
                                        width: screenWidth / 3,
                                      ),
                                    ),
                                    Text(
                                      startMonthDay,
                                      style: TextStyle(
                                          fontSize: 20.00, color: DEFAULT_BAYZAT_COLOR, fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        height: 1,
                                        color: Color.fromRGBO(175, 185, 205, 0.3),
                                        width: screenWidth / 3,
                                      ),
                                    ),
                                    Text(
                                      startYear,
                                      style: TextStyle(fontSize: 18.00, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 140.0,
                                  width: 1.0,
                                  color: Color.fromRGBO(175, 185, 205, 0.3),
                                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 18.0),
                                      child: Text(
                                        "Last day out of office",
                                        style: TextStyle(
                                            fontSize: 14.00,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(62, 69, 87, 1)),
                                      ),
                                    ),
                                    Text(
                                      endWeekdDay,
                                      style: TextStyle(fontSize: 18.00, color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        height: 1,
                                        color: Color.fromRGBO(175, 185, 205, 0.3),
                                        width: screenWidth / 3,
                                      ),
                                    ),
                                    Text(
                                      endMonthDay,
                                      style: TextStyle(
                                          fontSize: 20.00, color: DEFAULT_BAYZAT_COLOR, fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        height: 1,
                                        color: Color.fromRGBO(175, 185, 205, 0.3),
                                        width: screenWidth / 3,
                                      ),
                                    ),
                                    Text(
                                      endYear,
                                      style: TextStyle(fontSize: 18.00, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    intersection?.isNotEmpty == true
                        ? Container(
                            color: DEFAULT_BACKGROUND_GREY_COLOR,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (intersection?.map((it) {
                                      var data = it.dateFrom == it.dateTo
                                          ? '${it.name} - ${strDate(it.dateFrom)}'
                                          : '${it.name} - ${strDate(it.dateFrom)} to ${strDate(it.dateTo)}';
                                      return Text(data) as Widget;
                                    })?.toList() as List)
                                        .cast<Widget>() ??
                                    [Container()],
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      color: DEFAULT_BACKGROUND_GREY_COLOR,
                      width: screenWidth,
                      padding: EdgeInsets.all(8),
                      child: CalendarCarousel(
                        height: 420.0,
                        initalDate: state?.body?.dateFrom,
                        endDate: state?.body?.dateTo,
                        //TODO: add hire date check here
                        //TODO: modify date range picker library and disable dates for range out of min-max, for now, they are just unselectable
//                        minSelectedDate: currentBalance?.leaveCycleStartDate?.subtract(Duration(days: 365)),
//                        maxSelectedDate: currentBalance?.leaveCycleStartDate?.add(Duration(days: 365)),
                        showWeekDays: true,
                        daysHaveCircularBorder: true,
                        todayButtonColor: Colors.transparent,
                        todayTextStyle: TextStyle(color: Color.fromRGBO(175, 185, 205, 1), fontWeight: FontWeight.bold),
                        todayBorderColor: Colors.grey,
                        weekendTextStyle: TextStyle(color: Colors.black26),
                        weekdayTextStyle: TextStyle(
                            color: Color.fromRGBO(175, 185, 205, 1), fontSize: 14, fontWeight: FontWeight.bold),
                        onDayPressed: (List<DateTime> dateRange, List<Event> events) {
                          this.setState(() => dateRangePicked(dateRange));
                          state?.body ??= UpdateLeaveRequest();
                          state?.body?.dateFrom = dateRange.first;
                          state?.body?.dateTo = dateRange.last;
                          widget.leaveRequestBloc.emitEvent(LeaveRequestBlocEventUpdateDates(
                              body: state?.body,
                              callback: (message) {
                                showSnackBar(context, message);
                              }));
                          //events.forEach((event) => print(event.title));
                        },
                        selectedDayButtonColor: DEFAULT_BAYZAT_COLOR,
                        selectedDayBorderColor: Colors.transparent,
                        selectedDayTextStyle: TextStyle(color: Colors.white),
                        holidays: holidays,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    )
                  ],
                ),
                Positioned(
                  child: state?.type != PageStateType.ready && state?.type != PageStateType.reload
                      ? PendingAction(
                          backgroundColor: Colors.transparent,
                          loadingColor: Colors.blueAccent,
                        )
                      : Container(),
                )
              ],
            ),
          );
        });
  }

  buildHolidays(List<Holiday> holidays, List<DateTime> selectedDates) {
    if (selectedDates == null || selectedDates.first == null) return [];

    var intersection = holidays.where((holiday) => selectedDates.any((it) =>
        it.isAtSameMomentAs(holiday.dateFrom) ||
        it.isAtSameMomentAs(holiday.dateTo) ||
        it.isAfter(holiday.dateFrom) && it.isBefore(holiday.dateTo)));
    return intersection.toSet();
  }

  void dateRangePicked(List<DateTime> picked) {
    if (picked.length > 0 && picked[0] != null) {
      DateTime _startDate = picked[0];
      DateTime _endDate;

      var formatter = DateFormat('yyyy-MMM dd-EEEE');
      String formattedStartDate = formatter?.format(_startDate);
      String formattedEndDate;

      var startDateComps = formattedStartDate?.split("-");
      var endDateComps = [];

      if (picked.length == 2 && picked[1] != null) {
        _endDate = picked[1];
        formattedEndDate = formatter.format(_endDate);
        endDateComps = formattedEndDate?.split("-");
      }

      if (picked.length == 1) {
        startWeekDay = startDateComps.length == 3 ? startDateComps[2] : "";
        startMonthDay = startDateComps.length == 3 ? startDateComps[1] : "";
        startYear = startDateComps.length == 3 ? startDateComps[0] : "";

        endWeekdDay = endDateComps.length == 3 ? endDateComps[2] : "";
        endMonthDay = endDateComps.length == 3 ? endDateComps[1] : "";
        endYear = endDateComps.length == 3 ? endDateComps[0] : "";

        return;
      }

      startWeekDay = startDateComps.length == 3 ? startDateComps[2] : "";
      startMonthDay = startDateComps.length == 3 ? startDateComps[1] : "";
      startYear = startDateComps.length == 3 ? startDateComps[0] : "";

      endWeekdDay = endDateComps.length == 3 ? endDateComps[2] : "";
      endMonthDay = endDateComps.length == 3 ? endDateComps[1] : "";
      endYear = endDateComps.length == 3 ? endDateComps[0] : "";
    }
  }

  showSnackBar(context, message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}

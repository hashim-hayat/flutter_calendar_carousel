library flutter_calendar_dooboo;

import 'dart:async';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

typedef MarkedDateIconBuilder<T> = Widget Function(T event);

class CalendarCarousel<T> extends StatefulWidget {
  final TextStyle defaultHeaderTextStyle = TextStyle(
    fontSize: 20.0,
    color: Colors.blue,
  );
  final TextStyle defaultPrevDaysTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14.0,
  );
  final TextStyle defaultNextDaysTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14.0,
  );
  final TextStyle defaultDaysTextStyle =  TextStyle(
      fontSize: 14.0,
      color: Color.fromRGBO(175, 185, 205, 1)
  );
  final TextStyle defaultTodayTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14.0,
  );
  final TextStyle defaultSelectedDayTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14.0,
  );
  final TextStyle defaultWeekdayTextStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 14.0,
  );
  final TextStyle defaultWeekendTextStyle = TextStyle(
    color: Colors.pinkAccent,
    fontSize: 14.0,
  );
  final TextStyle defaultInactiveDaysTextStyle = TextStyle(
    color: Colors.black38,
    fontSize: 14.0,
  );
  final TextStyle defaultInactiveWeekendTextStyle = TextStyle(
    color: Colors.pinkAccent.withOpacity(0.6),
    fontSize: 14.0,
  );
  final Widget defaultMarkedDateWidget = Container(
    margin: EdgeInsets.symmetric(horizontal: 1.0),
    color: Colors.blueAccent,
    height: 4.0,
    width: 4.0,
  );

  final bool pickSingleDate;
  final DateTime initalDate;
  final DateTime endDate;
  final List<DateTime> holidays;
  final Color holidayColor;

  final double viewportFraction;
  final TextStyle prevDaysTextStyle;
  final TextStyle daysTextStyle;
  final TextStyle nextDaysTextStyle;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final TextStyle todayTextStyle;
  final Color dayButtonColor;
  final Color todayBorderColor;
  final Color todayButtonColor;
  final DateTime selectedDateTime;
  final TextStyle selectedDayTextStyle;
  final Color selectedDayButtonColor;
  final Color selectedDayBorderColor;
  final bool daysHaveCircularBorder;
  final Function(List<DateTime>, List<T>) onDayPressed;
  final TextStyle weekdayTextStyle;
  final Color iconColor;
  final TextStyle headerTextStyle;
  final Widget headerText;
  final TextStyle weekendTextStyle;
  final List<DateTime> markedDates;
  final EventList<T> markedDatesMap;
  final Color markedDateColor;
  final Widget markedDateWidget;
  final bool markedDateShowIcon;
  final Color markedDateIconBorderColor;
  final int markedDateIconMaxShown;
  final double markedDateIconMargin;
  final double markedDateIconOffset;
  final MarkedDateIconBuilder<T> markedDateIconBuilder;
  final bool
      markedDateMoreShowTotal; // null - no indicator, true - show the total events, false - show the total of hidden events
  final Decoration markedDateMoreCustomDecoration;
  final TextStyle markedDateMoreCustomTextStyle;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final bool weekFormat;
  final bool showWeekDays;
  final bool showHeader;
  final bool showHeaderButton;
  final ScrollPhysics customGridViewPhysics;
  final Function(DateTime) onCalendarChanged;
  final String locale;
  final DateTime minSelectedDate;
  final DateTime maxSelectedDate;
  final TextStyle inactiveDaysTextStyle;
  final TextStyle inactiveWeekendTextStyle;
  final bool headerTitleTouchable;
  final Function onHeaderTitlePressed;
  final WeekdayFormat weekDayFormat;

  CalendarCarousel({
    this.pickSingleDate = false,
    this.initalDate,
    this.endDate,
    this.holidays,
    this.holidayColor,
    this.viewportFraction = 1.0,
    this.prevDaysTextStyle,
    this.daysTextStyle,
    this.nextDaysTextStyle,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.height = double.infinity,
    this.width = double.infinity,
    this.todayTextStyle,
    this.dayButtonColor = Colors.transparent,
    this.todayBorderColor = Colors.red,
    this.todayButtonColor = Colors.red,
    this.selectedDateTime,
    this.selectedDayTextStyle,
    this.selectedDayBorderColor = Colors.green,
    this.selectedDayButtonColor = Colors.green,
    this.daysHaveCircularBorder,
    this.onDayPressed,
    this.weekdayTextStyle,
    this.iconColor = Colors.blueAccent,
    this.headerTextStyle,
    this.headerText,
    this.weekendTextStyle,
    @deprecated this.markedDates,
    this.markedDatesMap,
    @deprecated this.markedDateColor,
    this.markedDateShowIcon = false,
    this.markedDateIconBorderColor,
    this.markedDateIconMaxShown = 2,
    this.markedDateIconMargin = 5.0,
    this.markedDateIconOffset = 5.0,
    this.markedDateIconBuilder,
    this.markedDateMoreShowTotal,
    this.markedDateMoreCustomDecoration,
    this.markedDateMoreCustomTextStyle,
    this.markedDateWidget,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
    this.showWeekDays = true,
    this.weekFormat = false,
    this.showHeader = true,
    this.showHeaderButton = true,
    this.customGridViewPhysics,
    this.onCalendarChanged,
    this.locale = "en",
    this.minSelectedDate,
    this.maxSelectedDate,
    this.inactiveDaysTextStyle,
    this.inactiveWeekendTextStyle,
    this.headerTitleTouchable = false,
    this.onHeaderTitlePressed,
    this.weekDayFormat = WeekdayFormat.short,
  });

  @override
  _CalendarState<T> createState() => _CalendarState<T>();
}

enum WeekdayFormat {
  weekdays,
  standalone,
  short,
  standaloneShort,
  narrow,
  standaloneNarrow,
}

class _CalendarState<T> extends State<CalendarCarousel<T>> {
  PageController _controller;
  List<DateTime> _dates = List(3);
  List<List<DateTime>> _weeks = List(3);
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _selectedDates = [];
  List<DateTime> _selectedDateRange = [];
  int _startWeekday = 0;
  int _endWeekday = 0;
  DateFormat _localeDate;

  int currentPage = -1;
  bool initialDatesChanged = false;

  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations])
  int firstDayOfWeek = 0;

  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class
  bool _isReloadSelectedDate = true;

  @override
  initState() {
    super.initState();
    initializeDateFormatting();

    /// setup pageController
    _controller = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );

    _localeDate = DateFormat.yMMM(widget.locale);
    firstDayOfWeek = (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;
    if (widget.selectedDateTime != null) {
      _selectedDate = widget.selectedDateTime;
    } else {

      if (widget.initalDate != null) {
        _selectedDate = widget.initalDate;
      }
    }

    _setDate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("Recreating");

    if (widget.initalDate != null && widget.endDate != null && !initialDatesChanged) {
      _selectedDates = [widget.initalDate, widget.endDate];
      produceDateRange(_selectedDates);
      _selectedDate = widget.initalDate;
      print("produceDateRange");
      print(_selectedDates);
    }

    _setDate(currentPage);

    Widget headerText = DefaultTextStyle(
        style: TextStyle(fontSize: 16.0, color: Colors.black),
        child: widget.headerText != null
            ? widget.headerText
            : Text(
                widget.weekFormat
                    ? '${_localeDate.format(_weeks[1].first)}'
                    : '${_localeDate.format(this._dates[1])}',
                style: widget.headerTextStyle,
              ));
    if (_isReloadSelectedDate) {
      if (widget.selectedDateTime != null)
        _selectedDate = widget.selectedDateTime;
      _setDatesAndWeeks();
    } else {
      _isReloadSelectedDate = true;
    }
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          widget.showHeader
              ? Container(
                  margin: widget.headerMargin,
                  child: DefaultTextStyle(
                      style: widget.headerTextStyle != null
                          ? widget.headerTextStyle
                          : widget.defaultHeaderTextStyle,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            widget.showHeaderButton
                                ? IconButton(
                                    onPressed: () => _setDate(0),
                                    icon: Icon(Icons.chevron_left,
                                        color: widget.iconColor),
                                  )
                                : Container(),
                            widget.headerTitleTouchable
                                ? FlatButton(
                                    onPressed:
                                        widget.onHeaderTitlePressed != null
                                            ? widget.onHeaderTitlePressed
                                            : () => _selectDateFromPicker(),
                                    child: headerText,
                                  )
                                : headerText,
                            widget.showHeaderButton
                                ? IconButton(
                                    onPressed: () => _setDate(2),
                                    icon: Icon(Icons.chevron_right,
                                        color: widget.iconColor),
                                  )
                                : Container(),
                          ])),
                )
              : Container(),
          Container(
            child: !widget.showWeekDays
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _renderWeekDays(),
                  ),
          ),
          Expanded(
              child: PageView.builder(
              itemCount: 3,
              onPageChanged: (index) {
                this._setDate(index);
              },
              controller: _controller,
              itemBuilder: (context, index) {
                return widget.weekFormat ? weekBuilder(index) : builder(index);
              },
              pageSnapping: true,
          )),
        ],
      ),
    );
  }

  AnimatedBuilder builder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItemCount = DateTime(
          _dates[slideIndex].year,
          _dates[slideIndex].month + 1,
          0,
        ).day +
        _startWeekday +
        (7 - _endWeekday);
    int year = _dates[slideIndex].year;
    int month = _dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: GridView.count(
                physics: widget.customGridViewPhysics,
                crossAxisCount: 7,
                childAspectRatio: widget.childAspectRatio,
                padding: EdgeInsets.zero,
                children: List.generate(totalItemCount,

                    /// last day of month + weekday
                    (index) {
                  bool isToday =
                      DateTime.now().day == index + 1 - _startWeekday &&
                          DateTime.now().month == month &&
                          DateTime.now().year == year;
                  bool isSelectedDay = widget.selectedDateTime != null &&
                      widget.selectedDateTime.year == year &&
                      widget.selectedDateTime.month == month &&
                      widget.selectedDateTime.day == index + 1 - _startWeekday;
                  bool isPrevMonthDay = index < _startWeekday;
                  bool isNextMonthDay = index >=
                      (DateTime(year, month + 1, 0).day) + _startWeekday;
                  bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                  DateTime now = DateTime(year, month, 1);
                  TextStyle textStyle;
                  TextStyle defaultTextStyle;
                  if (isPrevMonthDay) {
                    now = now.subtract(Duration(days: _startWeekday - index));
                    textStyle = widget.prevDaysTextStyle;
                    defaultTextStyle = widget.defaultPrevDaysTextStyle;
                  } else if (isThisMonthDay) {
                    now = DateTime(year, month, index + 1 - _startWeekday);
                    textStyle = (isSelectedDay || isASelectedDate(now))
                        ? widget.selectedDayTextStyle
                        : isToday
                            ? widget.todayTextStyle
                            : widget.daysTextStyle;
                    defaultTextStyle = (isSelectedDay || isASelectedDate(now))
                        ? widget.defaultSelectedDayTextStyle
                        : isToday
                            ? widget.defaultTodayTextStyle
                            : widget.defaultDaysTextStyle;
                  } else {
                    now = DateTime(year, month, index + 1 - _startWeekday);
                    textStyle = widget.nextDaysTextStyle;
                    defaultTextStyle = widget.defaultNextDaysTextStyle;
                  }
                  bool isSelectable = true;
                  if (widget.minSelectedDate != null &&
                      now.millisecondsSinceEpoch <
                          widget.minSelectedDate.millisecondsSinceEpoch)
                    isSelectable = false;
                  else if (widget.maxSelectedDate != null &&
                      now.millisecondsSinceEpoch >
                          widget.maxSelectedDate.millisecondsSinceEpoch)
                    isSelectable = false;
                  return Container(
                    margin: EdgeInsets.all(isASelectedDate(now) ? 0.0 : widget.dayPadding),
                    child: FlatButton(
                      color: colorForDate(index, now, isSelectedDay, isToday, isThisMonthDay),
                      onPressed: () => _onDayPressed(now),
                      padding: EdgeInsets.all(isASelectedDate(now) ? 0.0 : widget.dayPadding),
                      shape: widget.daysHaveCircularBorder == null
                          ? CircleBorder()
                          : widget.daysHaveCircularBorder && !isASelectedDate(now) && !isHoliday(now)
                              ? shapeForToday(isToday, isHoliday(now))
                        : RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: shapeForDateRectangular(index, now, isToday, isSelectedDay, isThisMonthDay),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: DefaultTextStyle(
                              style: (_localeDate.dateSymbols.WEEKENDRANGE
                                          .contains(
                                              (index - 1 + 1) %
                                                  7)) &&
                                      !isSelectedDay &&
                                      !isToday
                                  ? (isPrevMonthDay
                                      ? widget.defaultPrevDaysTextStyle
                                      : isNextMonthDay
                                          ? widget.defaultNextDaysTextStyle
                                          : isSelectable
                                              ? widget.defaultWeekendTextStyle
                                              : widget
                                                  .defaultInactiveWeekendTextStyle)
                                  : isToday
                                      ? widget.defaultTodayTextStyle
                                      : isSelectable
                                          ? defaultTextStyle
                                          : widget.defaultInactiveDaysTextStyle,
                              child: Text(
                                '${now.day}',
                                style: styleForDate(index, now, isSelectedDay, isThisMonthDay, isToday),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          widget.markedDatesMap != null
                              ? _renderMarkedMapContainer(now)
                              : _renderMarked(now),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  RoundedRectangleBorder shapeForToday (bool isToday, bool isHoliday) {
    return RoundedRectangleBorder(
      side: BorderSide(
          color: isToday ? widget.todayBorderColor : Colors.transparent,
        width: 0.5
      ),
      borderRadius: (isToday || isHoliday ) ? BorderRadius.all(Radius.circular(25)) : BorderRadius.all(Radius.circular(0))
    );
  }

  BorderRadiusGeometry shapeForDateRectangular(int index, DateTime now, bool isToday, bool isSelectedDay,bool isThisMonthDay) {

    if (isSingleSelectedDate(now)) {
      return BorderRadius.all(Radius.circular(25));
    }

    if (_localeDate.dateSymbols.WEEKENDRANGE.contains((index - 1 + 1) % 7) && !isSelectedDay && isThisMonthDay && !isToday && !isASelectedDate(now)) {
      return BorderRadius.all(Radius.circular(0));
    }

    if (isASelectedDate(now)) {
      return isStartDate(now) ? BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))
          : isEndDate(now) ? BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)) : BorderRadius.all(Radius.circular(0));
    }

    if (isHoliday(now)) {
      return BorderRadius.all(Radius.circular(25));
    }

  }

  Color colorForDate(int index, DateTime now, bool isSelectedDay, bool isToday, bool isThisMonthDay) {

    if (_localeDate.dateSymbols.WEEKENDRANGE.contains((index - 1 + 1) % 7) && !isSelectedDay && isThisMonthDay && !isToday && !isASelectedDate(now)) {
      return Colors.grey.shade200;
    }

    if (isSelectedDay || isASelectedDate(now)) {
      return widget.selectedDayButtonColor != null
          ? widget.selectedDayButtonColor
          : isToday && widget.todayButtonColor != null
          ? widget.todayButtonColor
          : widget.dayButtonColor;
    }

    if (isHoliday(now)) {
      return widget.holidayColor != null ? widget.holidayColor : Colors.grey.shade200;
    }

  }

  TextStyle styleForDate(int index, DateTime now, bool isSelectedDay, bool isThisMonthDay, bool isToday) {

    if (isSelectedDay || isASelectedDate(now)) {
      return widget.selectedDayTextStyle;
    }

    if (_localeDate.dateSymbols.WEEKENDRANGE.contains((index - 1 + 1) % 7) && !isSelectedDay && isThisMonthDay && !isToday) {
      return widget.weekendTextStyle;
    }

    return widget.weekdayTextStyle;
  }

  AnimatedBuilder weekBuilder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<DateTime> weekDays = _weeks[slideIndex];

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double value = 1.0;
          if (_controller.position.haveDimensions) {
            value = _controller.page - slideIndex;
            value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
          }

          return Center(
            child: SizedBox(
              height: Curves.easeOut.transform(value) * widget.height,
              width: Curves.easeOut.transform(value) * screenWidth,
              child: child,
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: GridView.count(
                  crossAxisCount: 7,
                  childAspectRatio: widget.childAspectRatio,
                  padding: EdgeInsets.zero,
                  children: List.generate(weekDays.length,

                      /// last day of month + weekday
                      (index) {
                    bool isToday = weekDays[index].day == DateTime.now().day &&
                        weekDays[index].month == DateTime.now().month &&
                        weekDays[index].year == DateTime.now().year;
                    bool isSelectedDay = this._selectedDate != null &&
                        this._selectedDate.year == weekDays[index].year &&
                        this._selectedDate.month == weekDays[index].month &&
                        this._selectedDate.day == weekDays[index].day;
                    bool isPrevMonthDay =
                        weekDays[index].month < this._selectedDate.month;
                    bool isNextMonthDay =
                        weekDays[index].month > this._selectedDate.month;
                    bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                    DateTime now = weekDays[index];
                    TextStyle textStyle;
                    TextStyle defaultTextStyle;
                    if (isPrevMonthDay) {
                      textStyle = widget.prevDaysTextStyle;
                      defaultTextStyle = widget.defaultPrevDaysTextStyle;
                    } else if (isThisMonthDay) {
                      textStyle = (isSelectedDay || isASelectedDate(now))
                          ? widget.selectedDayTextStyle
                          : isToday
                              ? widget.todayTextStyle
                              : widget.daysTextStyle;
                      defaultTextStyle = (isSelectedDay || isASelectedDate(now))
                          ? widget.defaultSelectedDayTextStyle
                          : isToday
                              ? widget.defaultTodayTextStyle
                              : widget.defaultDaysTextStyle;
                    } else {
                      textStyle = widget.nextDaysTextStyle;
                      defaultTextStyle = widget.defaultNextDaysTextStyle;
                    }
                    bool isSelectable = true;
                    if (widget.minSelectedDate != null &&
                        now.millisecondsSinceEpoch <
                            widget.minSelectedDate.millisecondsSinceEpoch)
                      isSelectable = false;
                    else if (widget.maxSelectedDate != null &&
                        now.millisecondsSinceEpoch >
                            widget.maxSelectedDate.millisecondsSinceEpoch)
                      isSelectable = false;
                    return Container(
                      margin: EdgeInsets.all(widget.dayPadding),
                      child: FlatButton(
                        color: (isSelectedDay || isASelectedDate(now)) &&
                                widget.selectedDayButtonColor != null
                            ? widget.selectedDayButtonColor
                            : isToday && widget.todayButtonColor != null
                                ? widget.todayButtonColor
                                : widget.dayButtonColor,
                        onPressed: () => _onDayPressed(now),
                        padding: EdgeInsets.all(widget.dayPadding),
                        shape: widget.daysHaveCircularBorder == null
                            ? CircleBorder()
                            : widget.daysHaveCircularBorder
                                ? CircleBorder(
                                    side: BorderSide(
                                      color: (isSelectedDay || isASelectedDate(now))
                                          ? widget.selectedDayBorderColor
                                          : isPrevMonthDay
                                              ? widget.prevMonthDayBorderColor
                                              : isNextMonthDay
                                                  ? widget
                                                      .nextMonthDayBorderColor
                                                  : isToday &&
                                                          widget.todayBorderColor !=
                                                              null
                                                      ? widget.todayBorderColor
                                                      : widget
                                                          .thisMonthDayBorderColor,
                                    ),
                                  )
                                : RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: (isSelectedDay || isASelectedDate(now))
                                          ? widget.selectedDayBorderColor
                                          : isPrevMonthDay
                                              ? widget.prevMonthDayBorderColor
                                              : isNextMonthDay
                                                  ? widget
                                                      .nextMonthDayBorderColor
                                                  : isToday &&
                                                          widget.todayBorderColor !=
                                                              null
                                                      ? widget.todayBorderColor
                                                      : widget
                                                          .thisMonthDayBorderColor,
                                    ),
                                  ),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: DefaultTextStyle(
                                style: (index % 7 == 0 || index % 7 == 6) &&
                                        !(isSelectedDay || isASelectedDate(now)) &&
                                        !isToday &&
                                        !isPrevMonthDay &&
                                        !isNextMonthDay
                                    ? (isSelectable
                                        ? widget.defaultWeekendTextStyle
                                        : widget
                                            .defaultInactiveWeekendTextStyle)
                                    : isToday
                                        ? widget.defaultTodayTextStyle
                                        : defaultTextStyle,
                                child: Text(
                                  '${now.day}',
                                  style: (index % 7 == 0 || index % 7 == 6) && !(isSelectedDay || isASelectedDate(now)) && !isToday
                                      ? widget.weekendTextStyle
                                      : isToday
                                          ? widget.todayTextStyle
                                          : isSelectable
                                              ? textStyle
                                              : widget.inactiveDaysTextStyle,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            _renderMarked(now),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ));
  }

  List<DateTime> _getDaysInWeek([DateTime selectedDate]) {
    if (selectedDate == null) selectedDate = new DateTime.now();

    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selectedDate);

    return Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList();
  }


  bool isSingleSelectedDate(DateTime picked){
    return !_selectedDates.isEmpty && _selectedDates.first == picked && _selectedDates.length == 1;
  }

  bool isStartDate(DateTime picked){

    if (_selectedDates.length > 1) {
      return _selectedDates.first == picked && _selectedDates.first != _selectedDates.last;
    }

    return !_selectedDates.isEmpty && _selectedDates.first == picked;
  }

  bool isEndDate(DateTime picked){

    if (_selectedDates.length > 1) {
      return _selectedDates.last == picked && _selectedDates.first != _selectedDates.last;;
    }
    return !_selectedDates.isEmpty &&  _selectedDates.last == picked;
  }


  bool isASelectedDate(DateTime picked) {
    return (_selectedDateRange.contains(picked));
  }

  bool isASelectedDateExcludingBoundaries(DateTime picked) {

    List<DateTime> copy = [];
    _selectedDateRange.forEach((f) {copy.add(f);});

    copy.removeAt(0);
    copy.removeLast();

    return copy.contains(picked);
  }

  bool isHoliday(DateTime picked) {

    if (widget.holidays != null) {
      return widget.holidays.contains(picked);
    }
    return false;
  }

  void produceDateRange(List<DateTime> dates) {
    _selectedDateRange = [];

    if (dates.length == 2) {
      var startDate = dates[0];
      var endDate = dates[1];

      var difference = endDate.difference(startDate);
      var daysCount = difference.inDays - 1;

      _selectedDateRange.add(startDate);

      for (var i = 0; i < daysCount; i++) {
        _selectedDateRange.add(startDate.add(Duration(days: i + 1)));
      }

      _selectedDateRange.add(endDate);
    }

    if (dates.length == 1) {
      var startDate = dates[0];
      _selectedDateRange.add(startDate);
    }
  }

  void _onDayPressed(DateTime picked) {
    if (picked == null) return;
    if (widget.minSelectedDate != null &&
        picked.millisecondsSinceEpoch <
            widget.minSelectedDate.millisecondsSinceEpoch) return;
    if (widget.maxSelectedDate != null &&
        picked.millisecondsSinceEpoch >
            widget.maxSelectedDate.millisecondsSinceEpoch) return;

    initialDatesChanged = true;
    _selectedDate = null;

    setState(() {
      _isReloadSelectedDate = false;
      _selectedDate = picked;

      if (widget.pickSingleDate != null && !widget.pickSingleDate) {
        if (_selectedDates.length >= 2) {
          _selectedDates.clear();
        }

        if (_selectedDates.length == 0) {

          _selectedDates.add(picked);

        } else if (_selectedDates.length == 1) {

          if (picked.isAfter(_selectedDates[0]) || picked == _selectedDates[0]) {
            _selectedDates.add(picked);
          } else {
            _selectedDates.clear();
            _selectedDates.add(picked);
          }

        }
      } else {
        if (_selectedDates.length >= 1) {
          _selectedDates.clear();
        }
        _selectedDates.add(picked);
      }

      produceDateRange(_selectedDates);
    });

    if (widget.onDayPressed != null)
      widget.onDayPressed(
          _selectedDates,
          widget.markedDatesMap != null
              ? widget.markedDatesMap.getEvents(picked)
              : []);
    _setDate();
  }

  Future<Null> _selectDateFromPicker() async {
  /*
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: widget.minSelectedDate != null
          ? widget.minSelectedDate
          : DateTime(1960),
      lastDate: widget.maxSelectedDate != null
          ? widget.maxSelectedDate
          : DateTime(2050),
    );

    if (selected != null) {
      // updating selected date range based on selected week
      setState(() {
        _isReloadSelectedDate = false;
        _selectedDate = selected;
      });
      if (widget.onDayPressed != null)
        widget.onDayPressed(
            selected,
            widget.markedDatesMap != null
                ? widget.markedDatesMap.getEvents(selected)
                : []);
      _setDate();
    }
    */
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    DateTime date0 =
        DateTime(this._selectedDate.year, this._selectedDate.month - 1, 1);
    DateTime date1 =
        DateTime(this._selectedDate.year, this._selectedDate.month, 1);
    DateTime date2 =
        DateTime(this._selectedDate.year, this._selectedDate.month + 1, 1);

    /// Setup week-only format
    DateTime now = this._selectedDate;
    List<DateTime> week0 = _getDaysInWeek(now.subtract(new Duration(days: 7)));
    List<DateTime> week1 = _getDaysInWeek(now);
    List<DateTime> week2 = _getDaysInWeek(now.add(new Duration(days: 7)));

    _startWeekday = date1.weekday - firstDayOfWeek;
    _endWeekday = date2.weekday - firstDayOfWeek;
    this._dates = [
      date0,
      date1,
      date2,
    ];
    this._weeks = [
      week0,
      week1,
      week2,
    ];
  }

  void _setDate([int page = -1]) {

    if (page == -1) {
      setState(() {
        _isReloadSelectedDate = false;
        _setDatesAndWeeks();
      });
    } else if (page == 1) {
      return;
    } else {
      if (widget.weekFormat) {
        DateTime curr;
        List<List<DateTime>> newWeeks = this._weeks;
        if (page == 0) {
          curr = _weeks[0].first;
          newWeeks[0] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day - 7));
          newWeeks[1] = _getDaysInWeek(curr);
          newWeeks[2] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day + 7));
          page += 1;
        } else if (page == 2) {
          curr = _weeks[2].first;
          newWeeks[1] = _getDaysInWeek(curr);
          newWeeks[0] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day - 7));
          newWeeks[2] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day + 7));
          page -= 1;
        }
        setState(() {
          _isReloadSelectedDate = false;
          this._weeks = newWeeks;
        });

        _controller.animateToPage(page,
            duration: Duration(milliseconds: 1), curve: Threshold(0.0));
      } else {
        List<DateTime> dates = this._dates;
        if (page == 0) {
          dates[2] = DateTime(dates[0].year, dates[0].month + 1, 1);
          dates[1] = DateTime(dates[0].year, dates[0].month, 1);
          dates[0] = DateTime(dates[0].year, dates[0].month - 1, 1);
          page = page + 1;
        } else if (page == 2) {
          dates[0] = DateTime(dates[2].year, dates[2].month - 1, 1);
          dates[1] = DateTime(dates[2].year, dates[2].month, 1);
          dates[2] = DateTime(dates[2].year, dates[2].month + 1, 1);
          page = page - 1;
        }

        setState(() {
          _isReloadSelectedDate = false;
          _startWeekday = dates[page].weekday - firstDayOfWeek;
          _endWeekday = dates[page + 1].weekday - firstDayOfWeek;
          this._dates = dates;
        });


        _controller.animateToPage(page,
            duration: Duration(milliseconds: 1), curve: Threshold(0.0));
      }
    }

    //call callback
    if (this._dates.length == 3 && widget.onCalendarChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isReloadSelectedDate = false;
        widget.onCalendarChanged(this._dates[1]);
      });
    }

    currentPage = page;
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];

    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    for (var i = firstDayOfWeek, count = 0;
        count < 7;
        i = (i + 1) % 7, count++) {
      String weekDay;

      switch (widget.weekDayFormat) {
        case WeekdayFormat.weekdays:
          weekDay = _localeDate.dateSymbols.WEEKDAYS[i];
          break;
        case WeekdayFormat.standalone:
          weekDay = _localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
          break;
        case WeekdayFormat.short:
          weekDay = _localeDate.dateSymbols.SHORTWEEKDAYS[i];
          break;
        case WeekdayFormat.standaloneShort:
          weekDay = _localeDate.dateSymbols.STANDALONESHORTWEEKDAYS[i];
          break;
        case WeekdayFormat.narrow:
          weekDay = _localeDate.dateSymbols.NARROWWEEKDAYS[i];
          break;
        case WeekdayFormat.standaloneNarrow:
          weekDay = _localeDate.dateSymbols.STANDALONENARROWWEEKDAYS[i];
          break;
        default:
          weekDay = _localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
          break;
      }

      list.add(
        Expanded(
            child: Container(
          margin: widget.weekDayMargin,
          child: Center(
            child: DefaultTextStyle(
              style: widget.defaultWeekdayTextStyle,
              child: Text(
                weekDay,
                style: widget.weekdayTextStyle,
              ),
            ),
          ),
        )),
      );
    }
    return list;
  }

  Widget _renderMarked(DateTime now) {
    if (widget.markedDates != null && widget.markedDates.length > 0) {
      List<DateTime> markedDates = widget.markedDates.map((date) {
        return DateTime(date.year, date.month, date.day);
      }).toList();
      if (markedDates.contains(now)) {
        return widget.markedDateWidget != null
            ? widget.markedDateWidget
            : widget.defaultMarkedDateWidget;
      }
    }
    return Container();
  }

  Widget _renderMarkedMapContainer(DateTime now) {
    if (widget.markedDateShowIcon) {
      return Stack(
        children: _renderMarkedMap(now),
      );
    } else {
      return Container(
        height: double.infinity,
        padding: EdgeInsets.only(bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _renderMarkedMap(now),
        ),
      );
    }
  }

  List<Widget> _renderMarkedMap(DateTime now) {
    if (widget.markedDatesMap != null &&
        widget.markedDatesMap.getEvents(now).length > 0) {
      List<Widget> tmp = [];
      int count = 0;
      double offset = 0.0;
      double padding = widget.markedDateIconMargin;
      widget.markedDatesMap.getEvents(now).forEach((event) {
        if (widget.markedDateShowIcon) {
          if (tmp.length > 0 && tmp.length < widget.markedDateIconMaxShown) {
            offset += widget.markedDateIconOffset;
          }
          if (tmp.length < widget.markedDateIconMaxShown &&
              widget.markedDateIconBuilder != null) {
            tmp.add(Center(
                child: new Container(
              padding: EdgeInsets.only(
                top: padding + offset,
                left: padding + offset,
                right: padding - offset,
                bottom: padding - offset,
              ),
              width: double.infinity,
              height: double.infinity,
              child: widget.markedDateIconBuilder(event),
            )));
          } else {
            count++;
          }
          if (count > 0 && widget.markedDateMoreShowTotal != null) {
            tmp.add(
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: widget.markedDateMoreCustomDecoration == null
                      ? new BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000.0)),
                        )
                      : widget.markedDateMoreCustomDecoration,
                  child: Center(
                    child: Text(
                      widget.markedDateMoreShowTotal
                          ? (count + widget.markedDateIconMaxShown).toString()
                          : (count.toString() + '+'),
                      style: widget.markedDateMoreCustomTextStyle == null
                          ? TextStyle(
                              fontSize: 9.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal)
                          : widget.markedDateMoreCustomTextStyle,
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          if (widget.markedDateWidget != null) {
            tmp.add(widget.markedDateWidget);
          } else {
            tmp.add(widget.defaultMarkedDateWidget);
          }
        }
      });
      return tmp;
    }
    return [];
  }
}

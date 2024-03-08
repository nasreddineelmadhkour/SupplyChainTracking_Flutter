import 'package:flutter/material.dart';

class PForm extends StatefulWidget {
  final List<Widget> pages;
  final List<PTitle> title;
  PFormController controller;
  double height= 265;

  Color activeColor, disableColor;

  PForm({
    required this.pages,
    required this.title,
    required this.controller,
    this.activeColor = Colors.teal,
    this.disableColor = Colors.grey,
  });

  @override
  _PFormState createState() => _PFormState();
}

class _PFormState extends State<PForm> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<double>> _animationsOpacity;
  late List<bool> activeColor;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.pages.length,
          (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        lowerBound: 0.05,
      ),
    );

    _animations = _controllers
        .map((controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();

    _animationsOpacity = _controllers
        .map((controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();

    activeColor = List.generate(widget.pages.length, (index) => false);

    if (widget.controller != null) {
      widget.controller.addListener(() {
        controlColor(widget.controller.currentPage);
      });
    }
  }

  void controlColor(int index) {
    for (var i = 0; i < activeColor.length; i++) {
      if (index == i) {
        if (!_controllers[i].isCompleted) _controllers[index].animateTo(1);
      } else {
        if (_controllers[i].isCompleted) _controllers[i].reverse();
      }
    }

    for (var i = 0; i <= index; i++) {
      activeColor[i] = true;
    }

    for (var i = index + 1; i < activeColor.length; i++) {
      activeColor[i] = false;
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((c) {
      c.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.pages.map(_buildPageContainer).toList(),
      ),
    );
  }

  Widget _buildPageContainer(Widget e) {
    int index = widget.pages.indexOf(e);
    return Stack(
      children: [
        if (index != widget.pages.length - 1)
          Container(
            margin: EdgeInsets.only(left: 2, top: 37),

            child: SizeTransition(
              sizeFactor: _animations[index],
              child: Container(
                margin: EdgeInsets.only(left: 13, right: 20,top: 0),
                width: 3,
                height: widget.height,
                color: activeColor[index + 1]
                    ? widget.activeColor.withOpacity(0.9)
                    : widget.disableColor,
              ),
            ),
          ),
        Column(
          children: [
            _buildRow(index),
            Row(
              children: [
                SizedBox(width: 35),
                Expanded(
                  child: FadeTransition(
                    opacity: _animationsOpacity[index],
                    child: SizeTransition(
                      sizeFactor: _animations[index],
                      child: e,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(int index) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            controlColor(index);
          },
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: activeColor[index]
                  ? widget.activeColor.withOpacity(0.9)
                  : widget.disableColor,
            ),
          ),
        ),
        SizedBox(width: 40),
        widget.title[index].copyWith(
          activeColor: activeColor[index] ? widget.activeColor : Colors.black,
        ),
      ],
    );
  }
}

class PTitle extends StatelessWidget {
  String title, subTitle;
  Color activeColor;
  PTitle({
    this.activeColor = Colors.black,
    required this.title,
    this.subTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: activeColor,

          ),
        ),
        if (subTitle.isNotEmpty) Text(subTitle),
      ],
    );
  }

  PTitle copyWith({String? title, String? subTitle, Color? activeColor}) {
    return PTitle(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      activeColor: activeColor ?? this.activeColor,
    );
  }
}

class PFormController extends ChangeNotifier {
  PFormController(this.length);
  int _page = -1;
  final int length;

  nextPage() {
    if (_page < length - 1) _page++;

    notifyListeners();
  }

  get currentPage => _page;

  set jumpToPage(int p) {
    _page = p;
    notifyListeners();
  }

  prevPage() {
    if (_page > 0) _page--;
    notifyListeners();
  }

}

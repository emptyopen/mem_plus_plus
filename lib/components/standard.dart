import 'package:flutter/material.dart';

class BasicContainer extends StatelessWidget {
  BasicContainer({Key key, this.text, this.color, this.fontSize});

  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

class MainMenuOption extends StatelessWidget {

  MainMenuOption({Key key, this.icon = const Icon(Icons.access_alarm), this.text, this.color, this.route, this.firstView});

  final Icon icon;
  final Widget text;
  final Color color;
  final Widget route;
  final bool firstView;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlatButton(
            onPressed: () {
              final result = Navigator.push(context,
                  MaterialPageRoute(builder: (context) => route));
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Row(
                children: <Widget>[
                  icon,
                  SizedBox(width: 20,),
                  text,
                ],
              ),
            )),
        firstView ?
        Positioned(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black,
            ),
            child: Center(
              child: Text('!!',
              style: TextStyle(fontSize: 14,
              color: Colors.white),),
            ),
          ),
          left: 5,
          top: 10
        ) : Container()
      ],
    );
  }
}

class PopButton extends StatelessWidget {

  PopButton({Key key, this.widget, this.color});

  final Widget widget;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: widget
      ));
  }
}

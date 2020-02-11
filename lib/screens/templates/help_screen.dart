import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/standard.dart';

class HelpScreen extends StatefulWidget {
  final String title;
  final List<String> information;

  HelpScreen({this.title = '', this.information});

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int slideIndex;
  final IndexController indexController = IndexController();
  List<Widget> informationList = [];

  @override
  void initState() {
    super.initState();
    if (widget.information.length > 1) {
      informationList.add(Column(
        children: <Widget>[
          Text(
            widget.information[0],
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '(Swipe for more information)',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          Icon(Icons.arrow_forward),
        ],
      ));
      widget.information.sublist(1).forEach((f) {
        informationList.add(Text(
          f,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.left,
        ));
      });
    } else {
      informationList.add(Text(
        widget.information[0],
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.left,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            slideIndex = index;
          });
        },
        loop: false,
        controller: indexController,
        transformer:
            PageTransformerBuilder(builder: (Widget child, TransformInfo info) {
          return Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      ParallaxContainer(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                            child: informationList[info.index]),
                        position: info.position,
                        translationFactor: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Text('${info.index + 1}/${widget.information.length}'),
                right: 10,
                bottom: 10,
              )
            ],
          );
        }),
        itemCount: widget.information.length);

    return Material(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 350,
                      height: 500,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: transformerPageView),
                  SizedBox(
                    height: 15,
                  ),
                  OKPopButton()
                ],
              ),
            ),
          ],
        ));
  }
}

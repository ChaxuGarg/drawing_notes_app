import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DrawingScreen extends StatefulWidget {
  List<Offset> points = <Offset>[];
  String title;

  DrawingScreen({Key key, @required this.points, @required this.title}) : super(key: key);
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   automaticallyImplyLeading: false,
      // ),
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details){
            setState(() {
              RenderBox object = context.findRenderObject();
              Offset _localPosition =
                  object.globalToLocal(details.globalPosition);
              widget.points = new List.from(widget.points)..add(_localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => widget.points.add(null),
          child: CustomPaint(
            painter: DrawingSheet(points: widget.points),
            size: Size.infinite,
          )
        )
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'clear',
              child: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  widget.points = [null];
                });
              },
            ),
            FloatingActionButton(
              heroTag: 'save',
              child: Icon(Icons.save),
              onPressed: () {
                Navigator.pop(context, widget.points);
              },
            ),
          ],
        ),
    );
  }
}

class DrawingSheet extends CustomPainter {
  List<Offset> points;

  DrawingSheet({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i], points[i+1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingSheet oldDelegate) => oldDelegate.points != points;
}
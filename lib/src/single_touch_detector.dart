import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SingleTouchDectector extends StatelessWidget {
  final Widget child;
  final Function onTap;

  SingleTouchDectector({this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        _MyGestureDetector:
            GestureRecognizerFactoryWithHandlers<_MyGestureDetector>(
          () => _MyGestureDetector(onTap),
          (_MyGestureDetector instance) {},
        ),
      },
      child: child,
    );
  }
}

class _MyGestureDetector extends OneSequenceGestureRecognizer {
  Function onTap;

  _MyGestureDetector(this.onTap);

  @override
  String get debugDescription => null;

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void addPointer(PointerEvent event) {
    onTap();
  }

  @override
  void handleEvent(PointerEvent event) {
    // if (event is PointerDownEvent) {
    //   print('testing');
    //   onTap(event.down);
    // }
  }
}

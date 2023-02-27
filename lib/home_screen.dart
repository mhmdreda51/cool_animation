import 'package:cool_animation/widgets/card_widget.dart';
import 'package:cool_animation/widgets/hole_clipper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final cardSize = 150.0;
  late final cardOffsetTween = Tween<double>(
    begin: 0,
    end: 2 * cardSize,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardRotationTween = Tween<double>(
    begin: 0,
    end: 0.5,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardElevationTween = Tween<double>(
    begin: 2,
    end: 20,
  );
  late final holeSizeTween = Tween<double>(
    begin: 0,
    end: 1.5 * cardSize,
  );
  late final cardOffsetAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);
  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);
  @override
  initState() {
    super.initState();
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              holeAnimationController.forward();
              await cardOffsetAnimationController.forward();
              Future.delayed(
                const Duration(milliseconds: 200),
                () => holeAnimationController.reverse(),
              );
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              cardOffsetAnimationController.reverse();
              holeAnimationController.reverse();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: ClipPath(
          clipper: BlackHoleClipper(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: holeSize,
                child: Image.asset(
                  'assets/hole.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, cardOffset),
                    child: Transform.rotate(
                      angle: cardRotation,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CardWidget(
                          size: cardSize,
                          elevation: cardElevation,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: SizedBox(
                  width: cardSize * 1.5,
                  child: Image.asset(
                    'assets/images/hole.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

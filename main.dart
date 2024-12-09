import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T extends Object> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late List<T> _items;
//   late final List<T> _items = widget.items.toList();
  int? hoverIndex;

  @override
  void initState() {
    super.initState();
    _items = widget.items.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_items.length, (index) {
            return Draggable<T>(
              data: _items[index],
              feedback: Material(
                color: Colors.transparent,
                child: widget.builder(_items[index]),
              ),
              childWhenDragging: const SizedBox.shrink(),
              onDragCompleted: () {},
              child: DragTarget<T>(
                onAccept: (receivedIcon) {
                  setState(() {
                    int targetindex = _items.indexOf(receivedIcon);
                    _items[targetindex] = _items[index];
                    _items[index] = receivedIcon;
                  });
                },
                builder: (context, candidatedata, rejectedData) {
                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        hoverIndex = index;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        hoverIndex = null;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: hoverIndex == index ? 80 : 60,
                      width: hoverIndex == index ? 80 : 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            Colors.primaries[index % Colors.primaries.length],
                      ),
                      child: widget.builder(
                        _items[index],
                      ),
                    ),
                  );
                },
              ),
            );
          })),
    );
  }
}

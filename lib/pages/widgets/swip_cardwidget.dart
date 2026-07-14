import 'package:flutter/material.dart';

class SwipCardwidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback onCheck;
  final VoidCallback onTap;
  final bool status;

  const SwipCardwidget({
    super.key,
    required this.child,
    required this.onDelete,
    required this.onCheck,
    required this.onTap,
    required this.status,
  });

  @override
  State<SwipCardwidget> createState() => _SwipCardwidgetState();
}

class _SwipCardwidgetState extends State<SwipCardwidget> {
  double _dragExtend = 0.0;
  final double _actionWidth = 100.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dragExtend > 0
                    ? Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: IconButton(
                          onPressed: () {
                            setState(() => _dragExtend = 0.0);
                            widget.onDelete();
                          },
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Theme.of(context).colorScheme.error,
                            size: 30,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),

                _dragExtend < 0
                    ? Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          onPressed: () {
                            setState(() => _dragExtend = 0.0);
                            widget.onCheck();
                          },
                          icon: Icon(
                            Icons.check_circle_outline_outlined,
                            color: !widget.status
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                            size: 30,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () => widget.onTap(),
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragExtend += details.primaryDelta!;

              _dragExtend = _dragExtend.clamp(-_actionWidth, _actionWidth);
            });
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              if (_dragExtend > _actionWidth / 2) {
                _dragExtend = _actionWidth;
              } else if (_dragExtend < -_actionWidth / 2) {
                _dragExtend = -_actionWidth;
              } else {
                _dragExtend = 0.0;
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_dragExtend, 0, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class TopicTile extends StatefulWidget {
  final String tema;
  final String valor;
  final Color color;
  final IconData topicIcon;
  final bool isWarning;
  const TopicTile(
      {super.key,
      required this.tema,
      required this.color,
      required this.valor,
      required this.topicIcon,
      this.isWarning = false});

  @override
  State<TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.5),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: widget.color),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: <Widget>[
            Icon(
              widget.topicIcon,
              color: Colors.white,
            ),
            Text(
              "${widget.tema}: ",
              style: const TextStyle(color: Colors.white),
            ),
            Text(widget.valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            if (widget.isWarning)
              const Icon(
                Icons.warning_sharp,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextComponents extends StatefulWidget {
  final Color color;
  final double txtSize;
  final FontWeight fw;
  final TextAlign textAlign;
  final String txt;
  final String family;
  final List<Shadow>? shadows;
  final int? maxLines; // Ajouté
  final TextOverflow? overflow; // Ajouté

  const TextComponents({
    super.key,
    required this.txt,
    this.color = Colors.black,
    this.txtSize = 16,
    this.fw = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.family = "Regular",
    this.shadows,
    this.maxLines, // Ajouté
    this.overflow, // Ajouté
  });

  @override
  State<TextComponents> createState() => _TextComponentsState();
}

class _TextComponentsState extends State<TextComponents> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.txt,
      style: TextStyle(
        fontFamily: widget.family,
        color: widget.color,
        fontSize: widget.txtSize,
        fontWeight: widget.fw,
        shadows: widget.shadows,
      ),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines, // Appliqué
      overflow:
          widget.overflow ??
          TextOverflow.clip, // Par défaut à clip si non spécifié
    );
  }
}

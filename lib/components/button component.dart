import 'package:flutter/material.dart';

class Buttoncomponent extends StatelessWidget {
  final String textButton;
  final Color? buttonColor; // Optionnel, utilisé si gradient null
  final Gradient? gradient; // Optionnel, si fourni, utilisé en fond
  final Color textColor;
  final VoidCallback? onTap;
  final Widget? child; // Ajout du paramètre child

  const Buttoncomponent({
    super.key,
    required this.textButton,
    this.buttonColor,
    this.gradient,
    required this.textColor,
    this.onTap,
    this.child, // Paramètre child ajouté
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);

    final buttonChild =
        child ??
        Text(textButton, style: TextStyle(color: textColor, fontSize: 17));

    if (gradient != null) {
      // Si un gradient est défini, on l'applique via un DecoratedBox
      return SizedBox(
        height: 50,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadius,
          ),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.transparent, // Important pour voir le gradient
              shadowColor: Colors.transparent, // Supprime l'ombre par défaut
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
            child: buttonChild,
          ),
        ),
      );
    } else {
      // Sinon, on utilise une couleur unie classique
      return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                buttonColor ?? Colors.blue, // Couleur par défaut si null
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: buttonChild,
        ),
      );
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:isar/isar.dart';
import 'package:selection_lead_concours/components/button%20component.dart';
import 'package:selection_lead_concours/components/text_component.dart';
import 'package:selection_lead_concours/db/isar_service.dart';
import 'package:selection_lead_concours/models/user.dart';
import 'package:selection_lead_concours/modules/connexion/view/login.dart';
import 'package:selection_lead_concours/space.dart';

class Otp extends StatefulWidget {
  final String email; // Email reçu de la page précédente

  const Otp({super.key, required this.email});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  // Contrôleurs pour les champs OTP
  List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  // Contrôleurs pour le nouveau mot de passe
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Variables d'état
  bool _isOtpVerified = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Timer pour le compte à rebours
  Timer? _timer;
  int _remainingTime = 90; // 1 minute 30 secondes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  void _verifyOtp() {
    String otp = otpControllers.map((controller) => controller.text).join();

    if (otp.length != 4) {
      _showSnackBar(
        'Veuillez entrer un code OTP à 4 chiffres.',
        Colors.redAccent,
      );
      return;
    }

    // Simuler la vérification
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _isOtpVerified = true;
      });
      _showSnackBar('Code OTP vérifié avec succès !', Colors.green);
    });
  }

  void _resetPassword() async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      _showSnackBar(
        'Veuillez entrer un nouveau mot de passe.',
        Colors.redAccent,
      );
      return;
    }

    if (newPassword.length < 6) {
      _showSnackBar(
        'Le mot de passe doit contenir au moins 6 caractères.',
        Colors.redAccent,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar(
        'Les mots de passe ne correspondent pas.',
        Colors.redAccent,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isar = isarService.getIsar();
      final user =
          await isar.users.where().emailEqualTo(widget.email).findFirst();

      if (user != null) {
        user.setPassword(newPassword); // Remplacez par un hachage sécurisé
        await isar.writeTxn(() async {
          await isar.users.put(user);
        });

        _showSnackBar('Mot de passe réinitialisé avec succès !', Colors.green);

        // Navigation vers la page de connexion après un délai
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        });
      }
    } catch (e) {
      _showSnackBar(
        'Erreur lors de la réinitialisation : ${e.toString()}',
        Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendOtp() {
    if (_remainingTime > 0) {
      _showSnackBar(
        'Veuillez attendre avant de renvoyer le code.',
        Colors.orange,
      );
      return;
    }

    // Réinitialiser le timer
    setState(() {
      _remainingTime = 90;
    });
    _startTimer();

    _showSnackBar(
      'Un nouveau code OTP a été envoyé à ${widget.email}',
      Colors.green,
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              otpControllers[index].text.isNotEmpty
                  ? const Color(0xFF6A5ACD)
                  : const Color(0xFFE0E0E0),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A5ACD).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6A5ACD),
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
          setState(() {}); // Pour mettre à jour la couleur de la bordure
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextComponents(
          txt: label,
          txtSize: 16,
          fw: FontWeight.w600,
          color: const Color(0xFF2D1B69),
          textAlign: TextAlign.left,
        ),
        h(8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF6A5ACD),
              ),
              onPressed: toggleVisibility,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF6A5ACD), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          style: const TextStyle(color: Color(0xFF2D1B69), fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A5ACD), // Violet slate
              Color(0xFF9370DB), // Violet moyen
              Color(0xFFBA55D3), // Orchidée moyen
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personnalisée
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Vérification OTP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ), // Pour équilibrer le bouton retour
                    ],
                  ),
                ),
              ),

              // Contenu principal
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!_isOtpVerified) ...[
                          // Section de vérification OTP
                          FadeInUp(
                            duration: const Duration(milliseconds: 800),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.security,
                                  size: 80,
                                  color: Color(0xFF6A5ACD),
                                ),
                                h(20),
                                TextComponents(
                                  txt: "Entrez le code de vérification",
                                  txtSize: 24,
                                  fw: FontWeight.bold,
                                  color: const Color(0xFF2D1B69),
                                  textAlign: TextAlign.center,
                                  family: "Bold",
                                ),
                                h(10),
                                Text(
                                  'Nous avons envoyé un code à 4 chiffres à\n${widget.email}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          h(40),

                          // Champs OTP
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                4,
                                (index) => _buildOtpField(index),
                              ),
                            ),
                          ),

                          h(30),

                          // Timer
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Text(
                              _remainingTime > 0
                                  ? 'Le code expire dans : ${_formatTime(_remainingTime)}'
                                  : 'Le code a expiré',
                              style: TextStyle(
                                color:
                                    _remainingTime > 0
                                        ? const Color(0xFF666666)
                                        : Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          h(40),

                          // Bouton de vérification
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Color(0xFF6A5ACD),
                                    )
                                    : Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Buttoncomponent(
                                        textButton: "Vérifier le code",
                                        buttonColor: const Color(0xFF6A5ACD),
                                        textColor: Colors.white,
                                        onTap: _verifyOtp,
                                      ),
                                    ),
                          ),

                          h(20),

                          // Bouton renvoyer
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: TextButton(
                              onPressed: _resendOtp,
                              child: RichText(
                                text: TextSpan(
                                  text: "Vous n'avez pas reçu de code ? ",
                                  style: const TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Renvoyer",
                                      style: TextStyle(
                                        color:
                                            _remainingTime > 0
                                                ? Colors.grey
                                                : const Color(0xFF6A5ACD),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // Section de changement de mot de passe
                          FadeInUp(
                            duration: const Duration(milliseconds: 800),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.lock_reset,
                                  size: 80,
                                  color: Color(0xFF6A5ACD),
                                ),
                                h(20),
                                TextComponents(
                                  txt: "Nouveau mot de passe",
                                  txtSize: 24,
                                  fw: FontWeight.bold,
                                  color: const Color(0xFF2D1B69),
                                  textAlign: TextAlign.center,
                                  family: "Bold",
                                ),
                                h(10),
                                const Text(
                                  'Créez un nouveau mot de passe sécurisé',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          h(40),

                          // Champs de mot de passe
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: _buildPasswordField(
                              controller: newPasswordController,
                              label: "Nouveau mot de passe",
                              hintText: "Entrez votre nouveau mot de passe",
                              obscureText: _obscurePassword,
                              toggleVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          h(20),

                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: _buildPasswordField(
                              controller: confirmPasswordController,
                              label: "Confirmer le mot de passe",
                              hintText: "Confirmez votre nouveau mot de passe",
                              obscureText: _obscureConfirmPassword,
                              toggleVisibility: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),

                          // === AJOUT : Bouton pour réinitialiser le mot de passe ===
                          h(40),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Color(0xFF6A5ACD),
                                    )
                                    : Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Buttoncomponent(
                                        textButton:
                                            "Réinitialiser le mot de passe",
                                        buttonColor: const Color(0xFF6A5ACD),
                                        textColor: Colors.white,
                                        onTap: _resetPassword,
                                      ),
                                    ),
                          ),
                          // === Fin de l'ajout ===
                        ],
                      ],
                    ),
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

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:selection_lead_concours/components/button%20component.dart';
import 'package:selection_lead_concours/components/text_component.dart';
import 'package:selection_lead_concours/db/isar_service.dart';
import 'package:selection_lead_concours/models/user.dart';
import 'package:selection_lead_concours/modules/connexion/view/login.dart';
import 'package:selection_lead_concours/modules/otp/view/otp.dart';
import 'package:selection_lead_concours/services/auth_service.dart';
import 'package:selection_lead_concours/space.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Contrôleur pour le champ email
  TextEditingController emailController = TextEditingController();

  late AuthService authService;
  bool _isLoading = false; // Pour gérer l'état de chargement

  @override
  void initState() {
    super.initState();
    // authService = AuthService(isarService.getIsar());
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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

  Future<void> _verifyEmailAndSendOtp() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Veuillez entrer votre email.', Colors.redAccent);
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar('Veuillez entrer un email valide.', Colors.redAccent);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isar = isarService.getIsar();
      final user = await isar.users.where().emailEqualTo(email).findFirst();

      if (user == null) {
        _showSnackBar('Email non trouvé.', Colors.redAccent);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Simulation de l'envoi de l'OTP  je dois le remplace par un vrai appel API plus tard
      await Future.delayed(const Duration(seconds: 2));

      _showSnackBar('Un code OTP a été envoyé à votre email.', Colors.green);

      // Navigation vers la page OTP avec l'email
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Otp(email: email)),
      );
    } catch (e) {
      _showSnackBar(
        'Erreur lors de la vérification : ${e.toString()}',
        Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCustomFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    FormFieldValidator<String>? validator,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextComponents(
            txt: label,
            txtSize: 17,
            fw: FontWeight.w600,
            color: const Color(0xFF1A237E), // Bleu profond
            textAlign: TextAlign.left,
          ),
          h(10),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF90A4AE),
                fontStyle: FontStyle.italic,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2.5),
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            style: const TextStyle(color: Color(0xFF1A237E), fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD), // Bleu très clair
              Color(0xFFBBDEFB), // Bleu clair
              Color(0xFF90CAF9), // Bleu moyen
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 180.0,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 20.0),
                title: FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: TextComponents(
                    txt: "Réinitialisation du Mot de Passe",
                    fw: FontWeight.bold,
                    txtSize: 22,
                    family: "Bold",
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A237E), // Bleu profond
                        Color(0xFF3F51B5), // Bleu indigo
                      ],
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 80,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: TextComponents(
                            txt: "Vérifiez votre identité",
                            textAlign: TextAlign.center,
                            txtSize: 28,
                            fw: FontWeight.bold,
                            color: const Color(0xFF1A237E),
                            family: "Bold",
                          ),
                        ),
                        h(15),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: const Text(
                            'Entrez votre email pour recevoir un code OTP de réinitialisation.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ),
                        h(30),
                        _buildCustomFormField(
                          controller: emailController,
                          label: "Adresse Email",
                          keyboardType: TextInputType.emailAddress,
                          hintText: "example@domaine.com",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email.';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Veuillez entrer un email valide.';
                            }
                            return null;
                          },
                        ),
                        h(40),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child:
                              _isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF4CAF50),
                                    ),
                                  )
                                  : Buttoncomponent(
                                    textButton: "Envoyer le code OTP",
                                    buttonColor: const Color(0xFF4CAF50),
                                    textColor: Colors.white,
                                    onTap: _verifyEmailAndSendOtp,
                                  ),
                        ),
                        h(20),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: TextComponents(
                              txt: "Retour à la connexion",
                              color: const Color(0xFFE57373),
                              txtSize: 18,
                              fw: FontWeight.w600,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

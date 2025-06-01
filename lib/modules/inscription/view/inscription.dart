import 'package:flutter/material.dart';
import 'package:selection_lead_concours/components/button%20component.dart';
import 'package:selection_lead_concours/components/form_component.dart';
import 'package:selection_lead_concours/components/text_component.dart';
import 'package:selection_lead_concours/db/isar_service.dart';
import 'package:selection_lead_concours/modules/connexion/view/login.dart';
import 'package:selection_lead_concours/services/auth_service.dart';
import 'package:selection_lead_concours/space.dart';
import 'package:selection_lead_concours/utils/colors.dart' as AppColors;

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();

  AuthService? authService;
  bool _isPasswordVisible = false;
  bool _isarReady = false;

  @override
  void initState() {
    super.initState();
    _initializeIsarAndAuthService();
  }

  Future<void> _initializeIsarAndAuthService() async {
    // Assurez-vous que isarService est globalement accessible ou passé en paramètre
    await isarService.initializeIsar();
    authService = AuthService(isarService.getIsar());
    setState(() {
      _isarReady = true;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nomController.dispose();
    prenomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double imageSize =
        MediaQuery.of(context).size.width * 0.08; // Taille des icônes ajustée

    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc épuré
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            AppColors.primaryColor, // Couleur d'accent pour l'AppBar
        elevation: 0, // Pas d'ombre pour un design plat
        title: TextComponents(
          txt: "S'inscrire", // Titre simplifié pour le minimalisme
          fw: FontWeight.bold,
          family: "Bold",
          txtSize: 28, // Taille de texte ajustée
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      ),
      body:
          !_isarReady
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ), // Espacement horizontal accru
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h(40), // Espacement vertical
                      TextComponents(
                        txt: "Nom",
                        txtSize: 16,
                        color: AppColors.textColor,
                      ),
                      h(12),
                      FormComponent(
                        controller: nomController,
                        hintText: "Entrez votre nom",
                        hintStyle: const TextStyle(
                          color: AppColors.lightTextColor,
                        ),
                        inputTextStyle: const TextStyle(
                          color: AppColors.textColor,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.primaryColor,
                        ), // Icône pour le nom
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      h(25),
                      TextComponents(
                        txt: "Prénom",
                        txtSize: 16,
                        color: AppColors.textColor,
                      ),
                      h(12),
                      FormComponent(
                        controller: prenomController,
                        hintText: "Entrez votre prénom",
                        hintStyle: const TextStyle(
                          color: AppColors.lightTextColor,
                        ),
                        inputTextStyle: const TextStyle(
                          color: AppColors.textColor,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.primaryColor,
                        ), // Icône pour le prénom
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      h(25),
                      TextComponents(
                        txt: "Email",
                        txtSize: 16,
                        color: AppColors.textColor,
                      ),
                      h(12),
                      FormComponent(
                        controller: emailController,
                        hintText: "Entrez votre email",
                        hintStyle: const TextStyle(
                          color: AppColors.lightTextColor,
                        ),
                        inputTextStyle: const TextStyle(
                          color: AppColors.textColor,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.primaryColor,
                        ), // Icône pour l'email
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      h(25),
                      TextComponents(
                        txt: "N° de téléphone",
                        txtSize: 16,
                        color: AppColors.textColor,
                      ),
                      h(12),
                      FormComponent(
                        controller: phoneController,
                        hintText: "Entrez votre numéro de téléphone",
                        textInputType: TextInputType.phone,
                        hintStyle: const TextStyle(
                          color: AppColors.lightTextColor,
                        ),
                        inputTextStyle: const TextStyle(
                          color: AppColors.textColor,
                        ),
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: AppColors.primaryColor,
                        ), // Icône pour le téléphone
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      h(25),
                      TextComponents(
                        txt: "Mot de passe",
                        txtSize: 16,
                        color: AppColors.textColor,
                      ),
                      h(12),
                      FormComponent(
                        controller: passwordController,
                        hide: !_isPasswordVisible,
                        hintText: "Entrez votre mot de passe",
                        textInputType: TextInputType.visiblePassword,
                        hintStyle: const TextStyle(
                          color: AppColors.lightTextColor,
                        ),
                        inputTextStyle: const TextStyle(
                          color: AppColors.textColor,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryColor,
                        ), // Icône pour le mot de passe
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.borderColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color:
                                AppColors
                                    .lightTextColor, // Couleur plus discrète
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      h(35),
                      Buttoncomponent(
                        textButton: "S'inscrire",
                        buttonColor:
                            AppColors
                                .primaryColor, // Couleur principale pour le bouton
                        textColor: Colors.white,
                        onTap: () async {
                          if (!mounted) return;
                          if (!_isarReady || authService == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'La base de données n\'est pas encore initialisée. Veuillez patienter.',
                                ),
                                backgroundColor:
                                    AppColors.errorColor, // Couleur d'erreur
                              ),
                            );
                            return;
                          }
                          try {
                            await authService!.signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              nom: nomController.text.trim(),
                              prenom: prenomController.text.trim(),
                              phone: phoneController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Inscription réussie !'),
                                backgroundColor:
                                    AppColors.successColor, // Couleur de succès
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur lors de l\'inscription: ${e.toString()}',
                                ),
                                backgroundColor:
                                    AppColors.errorColor, // Couleur d'erreur
                              ),
                            );
                          }
                        },
                      ),
                      h(60),

                      // Barres horizontales + texte "Ou continuer avec"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.borderColor,
                            ), // Couleur de ligne plus douce
                          ),
                          w(20),
                          TextComponents(
                            txt: "Ou continuer avec",
                            txtSize: 15,
                            color: AppColors.lightTextColor,
                          ),
                          w(20),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.borderColor,
                            ),
                          ),
                        ],
                      ),
                      h(60),

                      // Boutons Google et Facebook
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55, // Hauteur ajustée
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ), // Bordure subtile
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Rayon plus doux
                                color: AppColors.lightAccentColor.withOpacity(
                                  0.2,
                                ), // Légère touche de couleur pour le fond
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/google.png",
                                  height: imageSize,
                                  width: imageSize,
                                ),
                              ),
                            ),
                          ),
                          w(20),
                          Expanded(
                            child: Container(
                              height: 55, // Hauteur ajustée
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.lightAccentColor.withOpacity(
                                  0.2,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/facebook.png",
                                  height: imageSize,
                                  width: imageSize,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      h(40),

                      // Lien vers connexion
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextComponents(
                            txt: "Vous avez déjà un compte ?",
                            fw: FontWeight.normal,
                            color: AppColors.textColor,
                          ),
                          w(10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: TextComponents(
                              txt: "Connectez-vous",
                              fw: FontWeight.bold,
                              color: AppColors.accentColor, // Couleur d'accent
                              txtSize: 16,
                            ),
                          ),
                        ],
                      ),
                      h(30), // Ajoute un peu d'espace en bas
                    ],
                  ),
                ),
              ),
    );
  }
}

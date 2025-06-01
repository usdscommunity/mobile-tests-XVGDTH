import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:selection_lead_concours/components/button%20component.dart';
import 'package:selection_lead_concours/components/form_component.dart';
import 'package:selection_lead_concours/components/text_component.dart';
import 'package:selection_lead_concours/db/isar_service.dart';
import 'package:selection_lead_concours/models/user.dart';
import 'package:selection_lead_concours/modules/forgot_password/view/forgot_password.dart';
import 'package:selection_lead_concours/modules/inscription/view/inscription.dart';
import 'package:selection_lead_concours/services/auth_service.dart';
import 'package:selection_lead_concours/space.dart';
import 'package:selection_lead_concours/utils/colors.dart' as AppColors;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController loginController =
      TextEditingController(); // email ou téléphone
  final TextEditingController passwordController = TextEditingController();

  late AuthService authService;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // authService = AuthService(isarService.getIsar());
  }

  Future<void> _login() async {
    final loginInput = loginController.text.trim();
    final passwordInput = passwordController.text.trim();

    if (loginInput.isEmpty || passwordInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    try {
      User? user;

      user = await authService.signIn(
        identifier: loginInput,
        password: passwordInput,
      );

      if (user == null) {
        final isar = isarService.getIsar();
        if (RegExp(r'^[0-9]+$').hasMatch(loginInput)) {
          user = await isar.users.filter().phoneEqualTo(loginInput).findFirst();

          if (user != null && user.verifyPassword(passwordInput)) {
            // Utilisateur trouvé par téléphone et mot de passe correct
          } else {
            user = null; // Mot de passe incorrect ou user null
          }
        }
      }

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie !'),
            backgroundColor: AppColors.successColor,
          ),
        );
        // pas encore implementer la logique de la page identification

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Identification()),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email/Numéro ou mot de passe incorrect'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageSize =
        MediaQuery.of(context).size.width * 0.08; // Taille des icônes ajustée

    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc épuré
      appBar: AppBar(
        backgroundColor:
            AppColors.primaryColor, // Couleur d'accent pour l'AppBar
        elevation: 0, // Pas d'ombre pour un design plat
        title: Center(
          child: TextComponents(
            txt: "Connexion",
            txtSize: 28, // Taille de texte ajustée
            fw: FontWeight.bold,
            family: "Bold",
            color: Colors.white, // Texte blanc sur l'AppBar
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ), // Espacement horizontal accru
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h(50), // Espacement vertical
                TextComponents(
                  txt: "Email / Numéro de Téléphone",
                  txtSize: 16,
                  color: AppColors.textColor,
                ),
                h(12),
                FormComponent(
                  controller: loginController,
                  hintText: "Entrez votre email ou votre numéro de téléphone",
                  hintStyle: const TextStyle(color: AppColors.lightTextColor),
                  inputTextStyle: const TextStyle(color: AppColors.textColor),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.primaryColor,
                  ), // Icône pour le champ email/téléphone
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Rayon plus doux
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color:
                          AppColors
                              .primaryColor, // Bordure plus claire au focus
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
                  textInputType: TextInputType.visiblePassword,
                  hintText: "Entrez votre mot de passe",
                  hintStyle: const TextStyle(color: AppColors.lightTextColor),
                  inputTextStyle: const TextStyle(color: AppColors.textColor),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.primaryColor,
                  ), // Icône pour le champ mot de passe
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.borderColor),
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
                              .lightTextColor, // Couleur plus discrète pour l'icône de visibilité
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                h(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Le "Se souvenir" peut être un switch ou une checkbox si désiré
                    // Pour le minimalisme, on peut le laisser de côté ou le styliser.
                    // Pour l'exemple, je le laisse, mais on peut le rendre moins proéminent.
                    TextComponents(
                      txt: "Se souvenir",
                      family: "Bold",
                      fw: FontWeight.bold,
                      txtSize: 16, // Taille ajustée
                      color: AppColors.lightTextColor, // Couleur plus douce
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: TextComponents(
                        txt: "Mot de passe oublié ?",
                        color: AppColors.accentColor, // Couleur d'accent
                        fw: FontWeight.bold,
                        family: "Bold",
                        txtSize: 16, // Taille ajustée
                      ),
                    ),
                  ],
                ),
                h(35),
                Buttoncomponent(
                  textButton: "Se connecter", // Texte du bouton mis à jour
                  buttonColor:
                      AppColors
                          .primaryColor, // Couleur principale pour le bouton
                  textColor: Colors.white,
                  onTap: _login,
                ),
                h(60),

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
                    ), // Texte plus doux
                    w(20),
                    Expanded(
                      child: Container(height: 1, color: AppColors.borderColor),
                    ),
                  ],
                ),
                h(60),

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
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.lightAccentColor.withOpacity(0.2),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponents(
                      txt: "Vous n'avez pas de compte ?",
                      fw: FontWeight.normal, // Poids de la police ajusté
                      color: AppColors.textColor,
                    ),
                    w(10), // Espacement réduit
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Inscription(),
                          ),
                        );
                      },
                      child: TextComponents(
                        txt: "Inscrivez-vous",
                        fw: FontWeight.bold,
                        color: AppColors.accentColor, // Couleur d'accent
                        txtSize: 16, // Taille ajustée
                      ),
                    ),
                  ],
                ),
                h(30), // Ajoute un peu d'espace en bas
              ],
            ),
          ),
        ),
      ),
    );
  }
}

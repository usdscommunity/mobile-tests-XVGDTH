import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart'; // Pour le hachage SHA256
import 'dart:convert'; // Pour l'encodage UTF8

part 'user.g.dart'; // Fichier généré par Isar, nécessaire pour le bon fonctionnement

@collection // Indique à Isar que cette classe est une collection
class User {
  // L'ID unique de l'utilisateur dans la base de données Isar.
  // `Isar.autoIncrement` gère automatiquement l'attribution d'un ID.
  Id id = Isar.autoIncrement;

  // L'email de l'utilisateur.
  // `@Index(unique: true)` assure que chaque email est unique dans la collection.
  // `replace: true` (optionnel mais souvent utile) signifie que si vous essayez
  // d'insérer un document avec un email déjà existant, l'ancien document sera remplacé.
  @Index(unique: true, replace: true)
  late String email;

  // Le hachage du mot de passe de l'utilisateur.
  // Nous utilisons `passwordHash` comme nom de champ, tel que défini dans votre code.
  late String passwordHash;

  // Le nom de l'utilisateur.
  late String nom;

  // Le prénom de l'utilisateur.
  late String prenom;

  // Le numéro de téléphone de l'utilisateur.
  // `@Index(unique: true)` assure que chaque numéro de téléphone est unique.
  // Cela est crucial pour permettre la connexion par numéro de téléphone.
  @Index(unique: true, replace: true)
  late String phone;

  /// Méthode pour définir et hasher le mot de passe de l'utilisateur.
  ///
  /// Utilise SHA256 pour hacher le mot de passe.
  /// NOTE: Pour une sécurité accrue en production, il est fortement recommandé
  /// d'utiliser des algorithmes de hachage plus robustes comme `bcrypt` ou `scrypt`
  /// qui incluent un salage et sont conçus pour être lents, rendant les attaques
  /// par force brute plus difficiles.
  void setPassword(String password) {
    final bytes = utf8.encode(password); // Convertit le mot de passe en bytes
    final digest = sha256.convert(bytes); // Hache les bytes avec SHA256
    passwordHash = digest.toString(); // Stocke le hachage sous forme de chaîne
  }

  /// Méthode pour vérifier si le mot de passe fourni correspond au hachage stocké.
  bool verifyPassword(String password) {
    final bytes = utf8.encode(
      password,
    ); // Convertit le mot de passe fourni en bytes
    final digest = sha256.convert(bytes); // Hache les bytes
    // Compare le hachage du mot de passe fourni avec le hachage stocké
    return passwordHash == digest.toString();
  }
}

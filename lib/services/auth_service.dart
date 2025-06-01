import 'package:isar/isar.dart';
import '../models/user.dart';

class AuthService {
  final Isar _isar;

  AuthService(this._isar);

  /// Méthode d'inscription
  Future<void> signUp({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String phone,
  }) async {
    // Vérifie si l'email existe déjà
    final existingUser =
        await _isar.users.where().emailEqualTo(email).findFirst();
    if (existingUser != null) {
      throw Exception('Email déjà utilisé');
    }

    // Vérifie si le téléphone existe déjà
    final existingPhone =
        await _isar.users.filter().phoneEqualTo(phone).findFirst();
    if (existingPhone != null) {
      throw Exception('Numéro de téléphone déjà utilisé');
    }

    // Crée le nouvel utilisateur
    final user =
        User()
          ..email = email
          ..nom = nom
          ..prenom = prenom
          ..phone = phone;

    user.setPassword(password);

    await _isar.writeTxn(() async {
      await _isar.users.put(user);
    });
  }

  Future<User?> signIn({
    required String identifier,
    required String password,
  }) async {
    User? user = await _isar.users.where().emailEqualTo(identifier).findFirst();

    user ??= await _isar.users.filter().phoneEqualTo(identifier).findFirst();

    if (user != null && user.verifyPassword(password)) {
      return user;

      return null;
    }
    return null;
  }
}

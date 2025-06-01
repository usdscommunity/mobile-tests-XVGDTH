import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:selection_lead_concours/models/user.dart';

class IsarService {
  Isar? isar;

  // Initialisation de la base Isar avec UserSchema (ProductSchema est retiré)
  Future<void> initializeIsar() async {
    if (isar != null) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [UserSchema], // Seul UserSchema est présent maintenant
      directory: dir.path,
      name: 'appli_ecom_db',
    );
  }

  // Récupérer l'instance Isar (throw si non initialisée)
  Isar getIsar() {
    if (isar == null) {
      throw Exception(
        'Isar n\'est pas initialisé. Appelez initializeIsar() d\'abord.',
      );
    }
    return isar!;
  }

  // -------------------- CRUD UTILISATEURS (existant) --------------------
  // Tu peux ici ajouter d'autres méthodes pour gérer les utilisateurs si besoin
  // Par exemple, pour ajouter, récupérer, mettre à jour ou supprimer des utilisateurs.

  // Exemple de méthode pour ajouter un utilisateur (si tu en as besoin plus tard)
  /*
  Future<void> addUser(User user) async {
    await isar!.writeTxn(() async {
      await isar!.users.put(user);
    });
  }
  */

  // Exemple de méthode pour récupérer tous les utilisateurs
  /*
  Future<List<User>> getAllUsers() async {
    return await isar!.users.where().findAll();
  }
  */
}

final isarService = IsarService(); // Instance globale

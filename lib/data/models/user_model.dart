import 'package:sql_209/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.name, required super.email, required super.noTelp, required super.alamat});
  // method toMap sesuai gambar anda
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'noTelp': noTelp, 'alamat': alamat};
  }

  // factory fromMap sesuai gambar anda
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      noTelp: map['noTelp'] ?? '',
      alamat: map['alamat'] ?? '',
    );
  }
}

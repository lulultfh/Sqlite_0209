import 'package:flutter/material.dart';
import 'package:sql_209/domain/entities/user_entity.dart';

class UserFormPage extends StatefulWidget {
  final UserEntity? user;
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:sql_209/bloc/user_bloc.dart';
import 'package:sql_209/bloc/user_event.dart';
import 'package:sql_209/bloc/user_state.dart';
import 'package:sql_209/domain/entities/user_entity.dart';

class UserFormPage extends StatefulWidget {
  final UserEntity? user;
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();

  String fullPhone = '';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _alamatController.text = widget.user!.alamat;
      fullPhone = widget.user!.noTelp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          Navigator.pop(context);
        }

        if (state is UserError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(isEdit ? "Edit User" : "Tambah User")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: "No Telp",
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'ID',
                initialValue: widget.user?.noTelp,
                onChanged: (phone) {
                  fullPhone = phone.completeNumber;
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final newUser = UserEntity(
                      id: isEdit
                          ? widget.user!.id
                          : DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      email: _emailController.text,
                      noTelp: fullPhone,
                      alamat: _alamatController.text,
                    );
                    if (isEdit) {
                      context.read<UserBloc>().add(UpdateUserEvent(newUser));
                    } else {
                      context.read<UserBloc>().add(AddUserEvent(newUser));
                    }
                    // Navigator.pop(context);
                  },

                  child: Text(isEdit ? "Simpan Perubahan" : "Simpan User Baru"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

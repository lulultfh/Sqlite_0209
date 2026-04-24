import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:sql_209/bloc/user_bloc.dart';
import 'package:sql_209/bloc/user_event.dart';
import 'package:sql_209/bloc/user_state.dart';
import 'package:sql_209/domain/entities/user_entity.dart';
import 'package:sql_209/main_layout.dart';

class UserFormPage extends StatefulWidget {
  final UserEntity? user;
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

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
      child: MainLayout(
        title: (isEdit ? "Edit User" : "Tambah User"),
        showAppBar: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: MainLayout.inputBorderColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  IntlPhoneField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "No Telp",
                      border: OutlineInputBorder(),
                    ),
                    initialCountryCode: 'ID',
                    initialValue: widget.user?.noTelp,
                    onChanged: (phone) {
                      fullPhone = phone.completeNumber;
                    },
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return 'Nomor tidak boleh kosong';
                      }
                      if (!phone.completeNumber.startsWith('+62')) {
                        return 'Harus nomor Indonesia (+62)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style:ElevatedButton.styleFrom(backgroundColor: MainLayout.deleteButton),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        final newUser = UserEntity(
                          id: isEdit
                              ? widget.user!.id
                              : DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                          name: _nameController.text,
                          email: _emailController.text,
                          noTelp: fullPhone,
                          alamat: _alamatController.text,
                        );
                        if (isEdit) {
                          context.read<UserBloc>().add(
                            UpdateUserEvent(newUser),
                          );
                        } else {
                          context.read<UserBloc>().add(AddUserEvent(newUser));
                        }
                        // Navigator.pop(context);
                      },

                      child: Text(
                        isEdit ? "Simpan Perubahan" : "Simpan User Baru",
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

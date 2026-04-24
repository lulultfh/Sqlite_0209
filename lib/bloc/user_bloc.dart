import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_209/bloc/user_event.dart';
import 'package:sql_209/bloc/user_state.dart';
import 'package:sql_209/domain/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.getAllUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Gagal memuat data"));
      }
    });
    on<AddUserEvent>((event, emit) async {
      final noTelp = event.user.noTelp;

      if(!noTelp.startsWith('+62')){
        emit(UserError("Nomor harus diawali dengan +62"));
        return;
      }
      if(noTelp.length > 15){
        emit(UserError("Nomor tidak boleh lebih dari 15 karakter"));
        return;
      }

      await repository.addUser(event.user);
      add(LoadUsers());
    });

    on<UpdateUserEvent>((event, emit) async {
      final noTelp = event.user.noTelp;
      
      if(!noTelp.startsWith('+62')){
        emit(UserError("Nomor harus diawali dengan +62"));
        return;
      }
      if(noTelp.length > 15){
        emit(UserError("Nomor tidak boleh lebih dari 15 karakter"));
        return;
      }
      await repository.updateUser(event.user);
      add(LoadUsers());
    });

    on<DeleteUserEvent>((event, emit) async {
      await repository.deleteUser(event.id);
      add(LoadUsers());
    });
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:fic5_bloc_ecatalog/data/datasources/auth_datasource.dart';
import 'package:fic5_bloc_ecatalog/data/models/request/register_request_model.dart';
import 'package:fic5_bloc_ecatalog/data/models/response/register_response_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthDatasource datasource;
  RegisterBloc(
    this.datasource,
  ) : super(RegisterInitial()) {
    on<DoRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      // Kirim register request model -> data source, menunggu response
      final result = await datasource.register(event.model);
      result.fold(
        (l) => emit(
          RegisterError(message: l),
        ),
        (r) => emit(
          RegisterLoaded(model: r),
        ),
      );
    });
  }
}

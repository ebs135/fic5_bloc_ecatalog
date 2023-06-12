// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:fic5_bloc_ecatalog/data/datasources/product_datasource.dart';
import 'package:fic5_bloc_ecatalog/data/models/request/product_request_model.dart';
import 'package:fic5_bloc_ecatalog/data/models/response/product_response_model.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductDataSource datasource;
  AddProductBloc(
    this.datasource,
  ) : super(AddProductInitial()) {
    on<DoAddProductEvent>((event, emit) async {
      emit(AddProductLoading());
      final result = await datasource.createProduct(event.model);
      result.fold(
        (l) => emit(
          AddProductError(message: l),
        ),
        (r) => emit(
          AddProductLoaded(model: r),
        ),
      );
    });
  }
}

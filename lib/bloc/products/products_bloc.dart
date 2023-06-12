// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:fic5_bloc_ecatalog/data/datasources/product_datasource.dart';
import 'package:fic5_bloc_ecatalog/data/models/response/product_response_model.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource datasource;
  ProductsBloc(
    this.datasource,
  ) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final result = await datasource.getAllProduct();
      result.fold((l) {
        emit(
          ProductsError(message: l),
        );
      }, (r) {
        emit(
          ProductsLoaded(data: r),
        );
      });
    });
  }
}

import 'package:get_it/get_it.dart';
import 'package:opscroll_web/blocs/bloc/scroll_bloc.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ScrollBloc>(() => ScrollBloc());
}

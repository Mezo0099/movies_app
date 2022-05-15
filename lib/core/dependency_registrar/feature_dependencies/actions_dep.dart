import 'package:get_it/get_it.dart';

import '../../../presentation/actions/domain/service/actions_service.dart';
import '../../../presentation/actions/domain/service/actions_service_impl.dart';
import '../../../presentation/actions/presentation/manager/actions_cubit.dart';

Future<void> actionDependencies(GetIt sl) async {
  sl.registerFactory<ActionsService>(
    () => ActionsServiceImpl(),
  );

  sl.registerSingleton<ActionsCubit>(ActionsCubit());
}

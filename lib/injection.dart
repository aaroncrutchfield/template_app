import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:template_app/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

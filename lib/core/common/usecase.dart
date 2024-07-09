import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';

abstract interface class BaseUseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}

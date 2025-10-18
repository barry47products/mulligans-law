/// Auth Feature Test Suite
///
/// Run all auth-related tests together:
/// ```
/// flutter test test/features/auth/auth_test_suite.dart
/// ```
library;

import 'data/repositories/auth_repository_impl_test.dart'
    as auth_repository_tests;
import 'domain/usecases/get_current_user_test.dart' as get_current_user_tests;
import 'domain/usecases/sign_in_test.dart' as sign_in_tests;
import 'domain/usecases/sign_out_test.dart' as sign_out_tests;
import 'domain/usecases/sign_up_test.dart' as sign_up_tests;
import 'presentation/bloc/auth_bloc_test.dart' as auth_bloc_tests;

void main() {
  // Data Layer Tests (16 tests)
  auth_repository_tests.main();

  // Domain Layer Tests (20 tests)
  sign_in_tests.main();
  sign_up_tests.main();
  sign_out_tests.main();
  get_current_user_tests.main();

  // Presentation Layer Tests (13 tests)
  auth_bloc_tests.main();
}

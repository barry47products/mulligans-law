import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// Use case for searching users by name or email
///
/// This use case is used in contexts where we need to find users,
/// such as inviting them to societies or adding them as friends.
class SearchUsers {
  final AuthRepository _repository;

  SearchUsers(this._repository);

  /// Search for users matching the query
  ///
  /// [query] - Search term to match against name or email
  /// [limit] - Maximum number of results (default 20)
  ///
  /// Returns list of matching user profiles
  Future<List<UserProfile>> call({
    required String query,
    int limit = 20,
  }) async {
    return await _repository.searchUsers(query: query, limit: limit);
  }
}

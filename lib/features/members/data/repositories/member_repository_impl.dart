import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/database_constants.dart';
import '../../../../core/errors/member_exceptions.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../../../societies/domain/entities/society_stats.dart';
import '../models/member_model.dart';

/// Implementation of MemberRepository using Supabase
class MemberRepositoryImpl implements MemberRepository {
  final SupabaseClient _supabase;

  MemberRepositoryImpl({required SupabaseClient supabase})
    : _supabase = supabase;

  @override
  Future<List<Member>> getSocietyMembers(String societyId) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.members)
          .select()
          .eq(DatabaseColumns.societyId, societyId)
          .order(DatabaseColumns.name, ascending: true);

      final members = (response as List)
          .map((json) => MemberModel.fromJson(json).toEntity())
          .toList();

      return members;
    } on PostgrestException catch (e) {
      throw MemberDatabaseException('Failed to fetch members: ${e.message}');
    } catch (e) {
      throw MemberDatabaseException('Unexpected error fetching members: $e');
    }
  }

  @override
  Future<int> getMemberCount(String societyId) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.members)
          .select('id')
          .eq(DatabaseColumns.societyId, societyId)
          .count(CountOption.exact);

      return response.count;
    } on PostgrestException catch (e) {
      throw MemberDatabaseException(
        'Failed to fetch member count: ${e.message}',
      );
    } catch (e) {
      throw MemberDatabaseException(
        'Unexpected error fetching member count: $e',
      );
    }
  }

  @override
  Future<SocietyStats> getSocietyStats(String societyId) async {
    try {
      // Fetch all ACTIVE members for the society
      final response = await _supabase
          .from(DatabaseTables.members)
          .select(
            '${DatabaseColumns.name}, ${DatabaseColumns.role}, ${DatabaseColumns.handicap}',
          )
          .eq(DatabaseColumns.societyId, societyId)
          .eq(DatabaseColumns.status, MemberStatus.active);

      final members = response as List;

      // If no members, return empty stats
      if (members.isEmpty) {
        return const SocietyStats(
          memberCount: 0,
          ownerNames: [],
          captainNames: [],
          averageHandicap: 0.0,
        );
      }

      // Extract owner names (OWNER and CO_OWNER)
      final ownerNames = members
          .where(
            (m) =>
                m[DatabaseColumns.role] == MemberRole.owner ||
                m[DatabaseColumns.role] == MemberRole.coOwner,
          )
          .map((m) => m[DatabaseColumns.name] as String)
          .toList();

      // Extract captain names
      final captainNames = members
          .where((m) => m[DatabaseColumns.role] == MemberRole.captain)
          .map((m) => m[DatabaseColumns.name] as String)
          .toList();

      // Calculate average handicap
      final handicaps = members
          .map((m) => (m[DatabaseColumns.handicap] as num).toDouble())
          .toList();

      final averageHandicap = handicaps.isEmpty
          ? 0.0
          : handicaps.reduce((a, b) => a + b) / handicaps.length;

      return SocietyStats(
        memberCount: members.length,
        ownerNames: ownerNames,
        captainNames: captainNames,
        averageHandicap: averageHandicap,
      );
    } on PostgrestException catch (e) {
      throw MemberDatabaseException(
        'Failed to fetch society stats: ${e.message}',
      );
    } catch (e) {
      throw MemberDatabaseException(
        'Unexpected error fetching society stats: $e',
      );
    }
  }

  @override
  Future<Member> addMember({
    required String societyId,
    required String userId,
    required String name,
    required String email,
    String? avatarUrl,
    required double handicap,
    required String role,
  }) async {
    try {
      final data = {
        DatabaseColumns.societyId: societyId,
        DatabaseColumns.userId: userId,
        DatabaseColumns.name: name,
        DatabaseColumns.email: email,
        if (avatarUrl != null) DatabaseColumns.avatarUrl: avatarUrl,
        DatabaseColumns.handicap: handicap,
        DatabaseColumns.role: role,
      };

      final response = await _supabase
          .from(DatabaseTables.members)
          .insert(data)
          .select()
          .single();

      return MemberModel.fromJson(response).toEntity();
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw MemberAlreadyExistsException(
          'Member already exists in this society',
        );
      }
      throw MemberDatabaseException('Failed to add member: ${e.message}');
    } catch (e) {
      throw MemberDatabaseException('Unexpected error adding member: $e');
    }
  }

  @override
  Future<Member> updateMember({
    required String memberId,
    String? name,
    String? email,
    String? avatarUrl,
    double? handicap,
    String? role,
  }) async {
    try {
      final data = <String, dynamic>{
        if (name != null) DatabaseColumns.name: name,
        if (email != null) DatabaseColumns.email: email,
        if (avatarUrl != null) DatabaseColumns.avatarUrl: avatarUrl,
        if (handicap != null) DatabaseColumns.handicap: handicap,
        if (role != null) DatabaseColumns.role: role,
      };

      if (data.isEmpty) {
        throw InvalidMemberDataException(
          'At least one field must be provided for update',
        );
      }

      final response = await _supabase
          .from(DatabaseTables.members)
          .update(data)
          .eq(DatabaseColumns.id, memberId)
          .select()
          .single();

      return MemberModel.fromJson(response).toEntity();
    } on PostgrestException catch (e) {
      if (e.code == '23503') {
        throw MemberNotFoundException('Member not found');
      }
      throw MemberDatabaseException('Failed to update member: ${e.message}');
    } catch (e) {
      if (e is InvalidMemberDataException) rethrow;
      throw MemberDatabaseException('Unexpected error updating member: $e');
    }
  }

  @override
  Future<void> removeMember(String memberId) async {
    try {
      await _supabase
          .from(DatabaseTables.members)
          .delete()
          .eq(DatabaseColumns.id, memberId);
    } on PostgrestException catch (e) {
      throw MemberDatabaseException('Failed to remove member: ${e.message}');
    } catch (e) {
      throw MemberDatabaseException('Unexpected error removing member: $e');
    }
  }

  @override
  Future<Member> getMemberById(String memberId) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.members)
          .select()
          .eq(DatabaseColumns.id, memberId)
          .single();

      return MemberModel.fromJson(response).toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw MemberNotFoundException('Member not found');
      }
      throw MemberDatabaseException('Failed to fetch member: ${e.message}');
    } catch (e) {
      throw MemberDatabaseException('Unexpected error fetching member: $e');
    }
  }

  @override
  Future<Member> getPrimaryMember(String userId) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.members)
          .select()
          .eq(DatabaseColumns.userId, userId)
          .isFilter(DatabaseColumns.societyId, null)
          .single();

      return MemberModel.fromJson(response).toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw MemberNotFoundException('Primary member not found');
      }
      throw MemberDatabaseException(
        'Failed to fetch primary member: ${e.message}',
      );
    } catch (e) {
      throw MemberDatabaseException(
        'Unexpected error fetching primary member: $e',
      );
    }
  }

  @override
  Future<Member> createPrimaryMember({
    required String userId,
    required String name,
    required String email,
    required double handicap,
    String? avatarUrl,
  }) async {
    try {
      final data = {
        DatabaseColumns.userId: userId,
        DatabaseColumns.name: name,
        DatabaseColumns.email: email,
        DatabaseColumns.handicap: handicap,
        if (avatarUrl != null) DatabaseColumns.avatarUrl: avatarUrl,
        // societyId and role are null for primary members (not included in data)
      };

      final response = await _supabase
          .from(DatabaseTables.members)
          .insert(data)
          .select()
          .single();

      return MemberModel.fromJson(response).toEntity();
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw MemberAlreadyExistsException(
          'Primary member already exists for this user',
        );
      }
      throw MemberDatabaseException(
        'Failed to create primary member: ${e.message}',
      );
    } catch (e) {
      throw MemberDatabaseException(
        'Unexpected error creating primary member: $e',
      );
    }
  }

  @override
  Future<Member> updatePrimaryMember({
    required String userId,
    String? name,
    String? email,
    double? handicap,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        if (name != null) DatabaseColumns.name: name,
        if (email != null) DatabaseColumns.email: email,
        if (handicap != null) DatabaseColumns.handicap: handicap,
        if (avatarUrl != null) DatabaseColumns.avatarUrl: avatarUrl,
      };

      if (data.isEmpty) {
        throw InvalidMemberDataException(
          'At least one field must be provided for update',
        );
      }

      final response = await _supabase
          .from(DatabaseTables.members)
          .update(data)
          .eq(DatabaseColumns.userId, userId)
          .isFilter(DatabaseColumns.societyId, null)
          .select()
          .single();

      return MemberModel.fromJson(response).toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw MemberNotFoundException('Primary member not found');
      }
      throw MemberDatabaseException(
        'Failed to update primary member: ${e.message}',
      );
    } catch (e) {
      if (e is InvalidMemberDataException) rethrow;
      throw MemberDatabaseException(
        'Unexpected error updating primary member: $e',
      );
    }
  }

  @override
  Future<Member> updateMemberRole({
    required String memberId,
    required String role,
  }) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.members)
          .update({DatabaseColumns.role: role})
          .eq(DatabaseColumns.id, memberId)
          .select()
          .single();

      return MemberModel.fromJson(response).toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw MemberNotFoundException('Member not found');
      }
      throw MemberDatabaseException(
        'Failed to update member role: ${e.message}',
      );
    } catch (e) {
      throw MemberDatabaseException(
        'Unexpected error updating member role: $e',
      );
    }
  }

  @override
  Future<void> removeSocietyMember(String memberId) async {
    try {
      await _supabase
          .from(DatabaseTables.members)
          .delete()
          .eq(DatabaseColumns.id, memberId);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw MemberNotFoundException('Member not found');
      }
      throw MemberDatabaseException('Failed to remove member: ${e.message}');
    } catch (e) {
      throw MemberDatabaseException('Unexpected error removing member: $e');
    }
  }
}

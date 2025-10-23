import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/society_invitation.dart';
import '../../domain/repositories/invitation_repository.dart';
import '../../../../core/errors/invitation_exceptions.dart';
import '../../../../core/errors/auth_exceptions.dart';
import '../models/society_invitation_model.dart';

/// Implementation of [InvitationRepository] using Supabase
class InvitationRepositoryImpl implements InvitationRepository {
  final SupabaseClient _supabase;

  InvitationRepositoryImpl({required SupabaseClient supabase})
    : _supabase = supabase;

  @override
  Future<SocietyInvitation> sendInvitation({
    required String societyId,
    required String invitedUserId,
    required String invitedByUserId,
    String? message,
  }) async {
    try {
      // First, get the invited user's info
      final userResponse = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', invitedUserId)
          .single();

      final invitedUserEmail = userResponse['email'] as String;
      final invitedUserName = userResponse['name'] as String;
      final invitedUserHandicap = userResponse['handicap'] as int?;

      // Get the inviter's info
      final inviterResponse = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', invitedByUserId)
          .single();

      final invitedByName = inviterResponse['name'] as String;

      // Get the society info
      final societyResponse = await _supabase
          .from('societies')
          .select('name, enforce_handicap_limits, min_handicap, max_handicap')
          .eq('id', societyId)
          .single();

      final societyName = societyResponse['name'] as String;
      final enforceHandicapLimits =
          societyResponse['enforce_handicap_limits'] as bool;

      // Check handicap limits if enforced
      if (enforceHandicapLimits) {
        if (invitedUserHandicap == null) {
          throw const HandicapValidationException(
            'User has no handicap set and society enforces handicap limits',
          );
        }

        final minHandicap = societyResponse['min_handicap'] as int;
        final maxHandicap = societyResponse['max_handicap'] as int;

        if (invitedUserHandicap < minHandicap ||
            invitedUserHandicap > maxHandicap) {
          throw HandicapValidationException(
            'User handicap $invitedUserHandicap is outside society limits ($minHandicap - $maxHandicap)',
          );
        }
      }

      // Create the invitation
      final response = await _supabase
          .from('society_invitations')
          .insert({
            'society_id': societyId,
            'invited_user_id': invitedUserId,
            'invited_by_user_id': invitedByUserId,
            'message': message,
            'status': 'PENDING',
          })
          .select()
          .single();

      // Manually construct the full invitation model with all required fields
      final invitationData = {
        ...response,
        'society_name': societyName,
        'invited_user_email': invitedUserEmail,
        'invited_user_name': invitedUserName,
        'invited_by_name': invitedByName,
      };

      return SocietyInvitationModel.fromJson(invitationData).toDomain();
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint violation
        if (e.message.contains('society_invitations_unique_pending')) {
          throw const PendingInvitationExistsException(
            'User already has a pending invitation to this society',
          );
        }
      }
      throw DatabaseException('Failed to send invitation: ${e.message}');
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      if (e is HandicapValidationException) rethrow;
      throw DatabaseException('Failed to send invitation: ${e.toString()}');
    }
  }

  @override
  Future<SocietyInvitation?> getInvitation(String invitationId) {
    // TODO: implement getInvitation
    throw UnimplementedError();
  }

  @override
  Future<List<SocietyInvitation>> getPendingInvitationsForUser(String userId) {
    // TODO: implement getPendingInvitationsForUser
    throw UnimplementedError();
  }

  @override
  Future<List<SocietyInvitation>> getInvitationsSentBy({
    required String userId,
    String? societyId,
  }) {
    // TODO: implement getInvitationsSentBy
    throw UnimplementedError();
  }

  @override
  Future<List<SocietyInvitation>> getSocietyInvitations({
    required String societyId,
    InvitationStatus? status,
  }) {
    // TODO: implement getSocietyInvitations
    throw UnimplementedError();
  }

  @override
  Future<SocietyInvitation> acceptInvitation(String invitationId) {
    // TODO: implement acceptInvitation
    throw UnimplementedError();
  }

  @override
  Future<SocietyInvitation> declineInvitation(String invitationId) {
    // TODO: implement declineInvitation
    throw UnimplementedError();
  }

  @override
  Future<SocietyInvitation> cancelInvitation(String invitationId) {
    // TODO: implement cancelInvitation
    throw UnimplementedError();
  }

  @override
  Stream<List<SocietyInvitation>> watchPendingInvitationsForUser(
    String userId,
  ) {
    // TODO: implement watchPendingInvitationsForUser
    throw UnimplementedError();
  }
}

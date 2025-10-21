import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/database_constants.dart';
import '../../../../core/errors/auth_exceptions.dart';
import '../../../../core/errors/society_exceptions.dart';
import '../../domain/entities/society.dart';
import '../../domain/repositories/society_repository.dart';
import '../models/society_model.dart';

/// Implementation of [SocietyRepository] using Supabase
class SocietyRepositoryImpl implements SocietyRepository {
  final SupabaseClient _supabase;

  SocietyRepositoryImpl({required SupabaseClient supabase})
    : _supabase = supabase;

  @override
  Future<Society> createSociety({
    required String name,
    String? description,
    String? logoUrl,
  }) async {
    try {
      developer.log('Creating society: $name', name: 'SocietyRepository');

      // Use RPC function to create society and add creator as captain
      final response = await _supabase.rpc(
        'create_society_with_captain',
        params: {
          'p_name': name,
          if (description != null) 'p_description': description,
          if (logoUrl != null) 'p_logo_url': logoUrl,
        },
      );

      developer.log('RPC response: $response', name: 'SocietyRepository');

      // The RPC function returns a single row, access it from the list
      final result = (response as List).first;

      // Convert the response which has prefixed column names
      final societyData = {
        DatabaseColumns.id: result['society_id'],
        DatabaseColumns.name: result['society_name'],
        if (result['society_description'] != null)
          DatabaseColumns.description: result['society_description'],
        if (result['society_logo_url'] != null)
          DatabaseColumns.logoUrl: result['society_logo_url'],
        DatabaseColumns.createdAt: result['society_created_at'],
        DatabaseColumns.updatedAt: result['society_updated_at'],
      };

      developer.log(
        'Society created successfully: ${result['society_id']}',
        name: 'SocietyRepository',
      );

      return SocietyModel.fromJson(societyData);
    } on SocketException catch (e) {
      developer.log(
        'Network error creating society',
        name: 'SocietyRepository',
        error: e,
      );
      throw const NetworkException();
    } catch (e, stackTrace) {
      developer.log(
        'Error creating society',
        name: 'SocietyRepository',
        error: e,
        stackTrace: stackTrace,
      );
      throw SocietyDatabaseException(
        'Failed to create society: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Society>> getUserSocieties() async {
    try {
      final response = await _supabase.from(DatabaseTables.societies).select();

      return (response as List)
          .map((json) => SocietyModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw SocietyDatabaseException(
        'Failed to fetch societies: ${e.toString()}',
      );
    }
  }

  @override
  Future<Society> getSocietyById(String id) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.societies)
          .select()
          .eq(DatabaseColumns.id, id)
          .single();

      return SocietyModel.fromJson(response);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('no rows') || message.contains('not found')) {
        throw const SocietyNotFoundException();
      }
      throw SocietyDatabaseException(
        'Failed to fetch society: ${e.toString()}',
      );
    }
  }

  @override
  Future<Society> updateSociety({
    required String id,
    String? name,
    String? description,
    String? logoUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data[DatabaseColumns.name] = name;
      if (description != null) data[DatabaseColumns.description] = description;
      if (logoUrl != null) data[DatabaseColumns.logoUrl] = logoUrl;

      final response = await _supabase
          .from(DatabaseTables.societies)
          .update(data)
          .eq(DatabaseColumns.id, id)
          .select()
          .single();

      return SocietyModel.fromJson(response);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('no rows') || message.contains('not found')) {
        throw const SocietyNotFoundException();
      }
      throw SocietyDatabaseException(
        'Failed to update society: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteSociety(String id) async {
    try {
      final response = await _supabase
          .from(DatabaseTables.societies)
          .delete()
          .eq(DatabaseColumns.id, id)
          .select();

      if ((response as List).isEmpty) {
        throw const SocietyNotFoundException();
      }
    } on SocketException {
      throw const NetworkException();
    } on SocietyNotFoundException {
      rethrow;
    } catch (e) {
      throw SocietyDatabaseException(
        'Failed to delete society: ${e.toString()}',
      );
    }
  }

  @override
  Stream<List<Society>> watchUserSocieties() {
    // Stream controller for managing society updates
    final controller = StreamController<List<Society>>();

    // Subscribe to Supabase real-time changes
    final subscription = _supabase
        .from(DatabaseTables.societies)
        .stream(primaryKey: [DatabaseColumns.id])
        .listen(
          (data) {
            final societies = (data as List)
                .map(
                  (json) => SocietyModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
            controller.add(societies);
          },
          onError: (error) {
            controller.addError(
              SocietyDatabaseException('Stream error: ${error.toString()}'),
            );
          },
        );

    // Clean up subscription when stream is cancelled
    controller.onCancel = () {
      subscription.cancel();
      controller.close();
    };

    return controller.stream;
  }
}

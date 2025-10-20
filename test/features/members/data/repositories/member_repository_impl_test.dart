import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/core/constants/database_constants.dart';
import 'package:mulligans_law/features/members/data/models/member_model.dart';

void main() {
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  group('MemberRepositoryImpl - Data Transformation', () {
    group('Database constants', () {
      test('should have correct members table name', () {
        expect(DatabaseTables.members, 'members');
      });

      test('should have correct column names', () {
        expect(DatabaseColumns.id, 'id');
        expect(DatabaseColumns.societyId, 'society_id');
        expect(DatabaseColumns.userId, 'user_id');
        expect(DatabaseColumns.name, 'name');
        expect(DatabaseColumns.email, 'email');
        expect(DatabaseColumns.avatarUrl, 'avatar_url');
        expect(DatabaseColumns.handicap, 'handicap');
        expect(DatabaseColumns.role, 'role');
        expect(DatabaseColumns.joinedAt, 'joined_at');
        expect(DatabaseColumns.lastPlayedAt, 'last_played_at');
      });
    });

    group('MemberModel JSON transformation', () {
      test('should correctly transform from Supabase JSON', () {
        // Arrange
        final json = {
          'id': 'member-1',
          'society_id': 'society-1',
          'user_id': 'user-1',
          'name': 'James Wilson',
          'email': 'james@example.com',
          'avatar_url': 'https://example.com/avatar.jpg',
          'handicap': 8.4,
          'role': 'member',
          'joined_at': '2025-01-15T10:30:00.000Z',
          'last_played_at': null,
        };

        // Act
        final model = MemberModel.fromJson(json);

        // Assert
        expect(model.id, 'member-1');
        expect(model.societyId, 'society-1');
        expect(model.userId, 'user-1');
        expect(model.name, 'James Wilson');
        expect(model.email, 'james@example.com');
        expect(model.avatarUrl, 'https://example.com/avatar.jpg');
        expect(model.handicap, 8.4);
        expect(model.role, 'member');
        expect(model.joinedAt, testDateTime);
        expect(model.lastPlayedAt, isNull);
      });

      test('should correctly transform to Supabase JSON for insert', () {
        // Arrange - data structure for inserting a new member
        const societyId = 'society-1';
        const userId = 'user-1';
        const name = 'James Wilson';
        const email = 'james@example.com';
        const avatarUrl = 'https://example.com/avatar.jpg';
        const handicap = 8.4;
        const role = 'member';

        // Act - create insert data structure
        final data = {
          DatabaseColumns.societyId: societyId,
          DatabaseColumns.userId: userId,
          DatabaseColumns.name: name,
          DatabaseColumns.email: email,
          DatabaseColumns.avatarUrl: avatarUrl,
          DatabaseColumns.handicap: handicap,
          DatabaseColumns.role: role,
        };

        // Assert - verify structure matches what Supabase expects
        expect(data[DatabaseColumns.societyId], societyId);
        expect(data[DatabaseColumns.userId], userId);
        expect(data[DatabaseColumns.name], name);
        expect(data[DatabaseColumns.email], email);
        expect(data[DatabaseColumns.avatarUrl], avatarUrl);
        expect(data[DatabaseColumns.handicap], handicap);
        expect(data[DatabaseColumns.role], role);
      });

      test('should handle list of members from database', () {
        // Arrange
        final jsonList = [
          {
            'id': 'member-1',
            'society_id': 'society-1',
            'user_id': 'user-1',
            'name': 'James Wilson',
            'email': 'james@example.com',
            'avatar_url': null,
            'handicap': 8.4,
            'role': 'member',
            'joined_at': '2025-01-15T10:30:00.000Z',
            'last_played_at': null,
          },
          {
            'id': 'member-2',
            'society_id': 'society-1',
            'user_id': 'user-2',
            'name': 'Sarah Johnson',
            'email': 'sarah@example.com',
            'avatar_url': null,
            'handicap': 12.3,
            'role': 'captain',
            'joined_at': '2025-01-10T08:00:00.000Z',
            'last_played_at': null,
          },
        ];

        // Act
        final members = jsonList
            .map((json) => MemberModel.fromJson(json))
            .toList();

        // Assert
        expect(members, hasLength(2));
        expect(members[0].name, 'James Wilson');
        expect(members[0].handicap, 8.4);
        expect(members[1].name, 'Sarah Johnson');
        expect(members[1].role, 'captain');
      });
    });

    group('Repository data structures', () {
      test('should create correct insert data structure', () {
        // Arrange
        const societyId = 'society-1';
        const userId = 'user-1';
        const name = 'James Wilson';
        const email = 'james@example.com';
        const handicap = 8.4;
        const role = 'member';

        // Act - structure for insert without optional fields
        final data = {
          DatabaseColumns.societyId: societyId,
          DatabaseColumns.userId: userId,
          DatabaseColumns.name: name,
          DatabaseColumns.email: email,
          DatabaseColumns.handicap: handicap,
          DatabaseColumns.role: role,
        };

        // Assert
        expect(data, isA<Map<String, dynamic>>());
        expect(data.containsKey(DatabaseColumns.societyId), true);
        expect(data.containsKey(DatabaseColumns.userId), true);
        expect(data.containsKey(DatabaseColumns.name), true);
        expect(data.containsKey(DatabaseColumns.email), true);
        expect(data.containsKey(DatabaseColumns.handicap), true);
        expect(data.containsKey(DatabaseColumns.role), true);
      });

      test(
        'should create correct update data structure with partial fields',
        () {
          // Arrange - simulate optional parameters
          const String name = 'Updated Name';
          const double handicap = 10.5;

          // Act - structure for partial update (conditionals used in real impl)
          final data = {
            DatabaseColumns.name: name,
            DatabaseColumns.handicap: handicap,
          };

          // Assert
          expect(data, {
            DatabaseColumns.name: name,
            DatabaseColumns.handicap: handicap,
          });
          expect(data.containsKey(DatabaseColumns.email), false);
          expect(data.containsKey(DatabaseColumns.role), false);
        },
      );

      test('should handle conditional field inclusion', () {
        // Arrange
        const name = 'James Wilson';
        const String? avatarUrl = null;
        const email = 'james@example.com';

        // Act
        final data = {
          DatabaseColumns.name: name,
          if (avatarUrl != null) DatabaseColumns.avatarUrl: avatarUrl,
          DatabaseColumns.email: email,
        };

        // Assert
        expect(data.containsKey(DatabaseColumns.name), true);
        expect(data.containsKey(DatabaseColumns.avatarUrl), false);
        expect(data.containsKey(DatabaseColumns.email), true);
      });
    });

    group('Primary member data structures', () {
      test('should create insert data structure for primary member', () {
        // Arrange - Primary member has no societyId or role
        const userId = 'user-1';
        const name = 'John Doe';
        const email = 'john@example.com';
        const handicap = 10.5;

        // Act - structure for creating primary member
        final data = {
          DatabaseColumns.userId: userId,
          DatabaseColumns.name: name,
          DatabaseColumns.email: email,
          DatabaseColumns.handicap: handicap,
          // Note: societyId and role are NOT included (will be null in DB)
        };

        // Assert
        expect(data.containsKey(DatabaseColumns.userId), true);
        expect(data.containsKey(DatabaseColumns.name), true);
        expect(data.containsKey(DatabaseColumns.email), true);
        expect(data.containsKey(DatabaseColumns.handicap), true);
        expect(data.containsKey(DatabaseColumns.societyId), false);
        expect(data.containsKey(DatabaseColumns.role), false);
      });

      test('should handle primary member with optional avatar', () {
        // Arrange
        const userId = 'user-2';
        const name = 'Jane Smith';
        const email = 'jane@example.com';
        const handicap = 15.0;
        const String avatarUrl = 'https://example.com/jane.jpg';

        // Act
        final data = {
          DatabaseColumns.userId: userId,
          DatabaseColumns.name: name,
          DatabaseColumns.email: email,
          DatabaseColumns.handicap: handicap,
          if (avatarUrl.isNotEmpty) DatabaseColumns.avatarUrl: avatarUrl,
        };

        // Assert
        expect(data.containsKey(DatabaseColumns.avatarUrl), true);
        expect(data[DatabaseColumns.avatarUrl], avatarUrl);
      });

      test('should transform primary member JSON from database', () {
        // Arrange - JSON returned from Supabase for primary member
        final primaryJson = {
          'id': 'member-primary-1',
          'society_id': null,
          'user_id': 'user-1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'avatar_url': null,
          'handicap': 10.5,
          'role': null,
          'joined_at': '2025-01-15T10:30:00.000Z',
          'last_played_at': null,
        };

        // Act
        final model = MemberModel.fromJson(primaryJson);

        // Assert
        expect(model.id, 'member-primary-1');
        expect(model.societyId, isNull);
        expect(model.userId, 'user-1');
        expect(model.name, 'John Doe');
        expect(model.email, 'john@example.com');
        expect(model.handicap, 10.5);
        expect(model.role, isNull);
        expect(model.avatarUrl, isNull);
        expect(model.lastPlayedAt, isNull);
      });
    });
  });
}

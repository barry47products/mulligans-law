import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/societies/data/models/society_model.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';

void main() {
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSociety = Society(
    id: 'society-123',
    name: 'Mulligans Golf Society',
    description: 'A friendly golf society',
    logoUrl: 'https://example.com/logo.png',
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  final testJson = {
    'id': 'society-123',
    'name': 'Mulligans Golf Society',
    'description': 'A friendly golf society',
    'logo_url': 'https://example.com/logo.png',
    'created_at': '2025-01-15T10:30:00.000Z',
    'updated_at': '2025-01-15T10:30:00.000Z',
  };

  group('SocietyModel', () {
    test('should be a subclass of Society entity', () {
      // Arrange
      final model = SocietyModel(
        id: 'society-123',
        name: 'Test Society',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      // Assert
      expect(model, isA<Society>());
    });

    group('fromJson', () {
      test('should return a valid SocietyModel from JSON', () {
        // Act
        final result = SocietyModel.fromJson(testJson);

        // Assert
        expect(result.id, testSociety.id);
        expect(result.name, testSociety.name);
        expect(result.description, testSociety.description);
        expect(result.logoUrl, testSociety.logoUrl);
        expect(result.createdAt, testSociety.createdAt);
        expect(result.updatedAt, testSociety.updatedAt);
      });

      test('should handle null description', () {
        // Arrange
        final jsonWithNullDescription = {
          'id': 'society-123',
          'name': 'Test Society',
          'description': null,
          'logo_url': 'https://example.com/logo.png',
          'created_at': '2025-01-15T10:30:00.000Z',
          'updated_at': '2025-01-15T10:30:00.000Z',
        };

        // Act
        final result = SocietyModel.fromJson(jsonWithNullDescription);

        // Assert
        expect(result.description, isNull);
      });

      test('should handle null logoUrl', () {
        // Arrange
        final jsonWithNullLogo = {
          'id': 'society-123',
          'name': 'Test Society',
          'description': 'Description',
          'logo_url': null,
          'created_at': '2025-01-15T10:30:00.000Z',
          'updated_at': '2025-01-15T10:30:00.000Z',
        };

        // Act
        final result = SocietyModel.fromJson(jsonWithNullLogo);

        // Assert
        expect(result.logoUrl, isNull);
      });

      test('should handle missing optional fields', () {
        // Arrange
        final minimalJson = {
          'id': 'society-123',
          'name': 'Test Society',
          'created_at': '2025-01-15T10:30:00.000Z',
          'updated_at': '2025-01-15T10:30:00.000Z',
        };

        // Act
        final result = SocietyModel.fromJson(minimalJson);

        // Assert
        expect(result.id, 'society-123');
        expect(result.name, 'Test Society');
        expect(result.description, isNull);
        expect(result.logoUrl, isNull);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Arrange
        final model = SocietyModel(
          id: testSociety.id,
          name: testSociety.name,
          description: testSociety.description,
          logoUrl: testSociety.logoUrl,
          createdAt: testSociety.createdAt,
          updatedAt: testSociety.updatedAt,
        );

        // Act
        final result = model.toJson();

        // Assert
        expect(result, testJson);
      });

      test('should handle null description in JSON output', () {
        // Arrange
        final model = SocietyModel(
          id: 'society-123',
          name: 'Test Society',
          description: null,
          logoUrl: 'https://example.com/logo.png',
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        // Act
        final result = model.toJson();

        // Assert
        expect(result['description'], isNull);
      });

      test('should handle null logoUrl in JSON output', () {
        // Arrange
        final model = SocietyModel(
          id: 'society-123',
          name: 'Test Society',
          description: 'Description',
          logoUrl: null,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        // Act
        final result = model.toJson();

        // Assert
        expect(result['logo_url'], isNull);
      });
    });

    group('fromEntity', () {
      test('should convert Society entity to SocietyModel', () {
        // Act
        final result = SocietyModel.fromEntity(testSociety);

        // Assert
        expect(result.id, testSociety.id);
        expect(result.name, testSociety.name);
        expect(result.description, testSociety.description);
        expect(result.logoUrl, testSociety.logoUrl);
        expect(result.createdAt, testSociety.createdAt);
        expect(result.updatedAt, testSociety.updatedAt);
      });
    });

    group('toEntity', () {
      test('should convert SocietyModel to Society entity', () {
        // Arrange
        final model = SocietyModel(
          id: testSociety.id,
          name: testSociety.name,
          description: testSociety.description,
          logoUrl: testSociety.logoUrl,
          createdAt: testSociety.createdAt,
          updatedAt: testSociety.updatedAt,
        );

        // Act
        final result = model.toEntity();

        // Assert
        expect(result, isA<Society>());
        expect(result.id, testSociety.id);
        expect(result.name, testSociety.name);
        expect(result.description, testSociety.description);
        expect(result.logoUrl, testSociety.logoUrl);
        expect(result.createdAt, testSociety.createdAt);
        expect(result.updatedAt, testSociety.updatedAt);
      });
    });

    group('JSON serialization round-trip', () {
      test('should maintain data integrity through encode/decode cycle', () {
        // Arrange
        final model = SocietyModel(
          id: testSociety.id,
          name: testSociety.name,
          description: testSociety.description,
          logoUrl: testSociety.logoUrl,
          createdAt: testSociety.createdAt,
          updatedAt: testSociety.updatedAt,
        );

        // Act
        final json = model.toJson();
        final jsonString = jsonEncode(json);
        final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
        final result = SocietyModel.fromJson(decodedJson);

        // Assert
        expect(result.id, model.id);
        expect(result.name, model.name);
        expect(result.description, model.description);
        expect(result.logoUrl, model.logoUrl);
        expect(result.createdAt, model.createdAt);
        expect(result.updatedAt, model.updatedAt);
      });
    });
  });
}

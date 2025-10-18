# Test Fixtures

This directory contains test fixture data used across the test suite.

## Purpose

Fixtures are sample data files (JSON, YAML, etc.) that represent typical data your app will work with. They help keep tests consistent and maintainable.

## Usage

### JSON Fixtures

Create JSON files representing API responses or database data:

```dart
// test/fixtures/scores/score_response.json
{
  "id": "score-1",
  "round_id": "round-1",
  "player_id": "player-1",
  "hole_scores": [4, 3, 5, 4, 4, 3, 5, 4, 4, 5, 4, 3, 4, 5, 4, 4, 3, 5],
  "total_gross": 75,
  "total_net": 72,
  "total_stableford": 36,
  "status": "SUBMITTED"
}
```

### Loading Fixtures in Tests

```dart
import 'dart:io';
import 'dart:convert';

String fixture(String name) {
  return File('test/fixtures/$name').readAsStringSync();
}

void main() {
  test('should parse score from JSON', () {
    // Arrange
    final jsonString = fixture('scores/score_response.json');
    final jsonMap = json.decode(jsonString);

    // Act
    final score = Score.fromJson(jsonMap);

    // Assert
    expect(score.id, 'score-1');
  });
}
```

## Organization

Organize fixtures by feature:

```bash
test/fixtures/
├── scores/
│   ├── score_response.json
│   └── score_list_response.json
├── rounds/
│   ├── round_response.json
│   └── round_list_response.json
├── members/
│   └── member_response.json
└── courses/
    └── course_response.json
```

## Best Practices

1. **Keep fixtures realistic** - Use actual data structures your app will encounter
2. **Use minimal data** - Only include fields necessary for the test
3. **Version control** - Commit fixtures to track changes over time
4. **Document edge cases** - Create fixtures for error states, empty lists, etc.

## Example Fixtures to Create

- `scores/score_in_progress.json` - Score being captured
- `scores/score_submitted.json` - Completed score awaiting approval
- `scores/score_approved.json` - Approved final score
- `rounds/round_upcoming.json` - Future round
- `rounds/round_in_progress.json` - Active round
- `rounds/round_completed.json` - Past round
- `errors/validation_error.json` - API validation error response
- `errors/network_error.json` - Network error response

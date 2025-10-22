import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/validation_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/society.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart' as auth;
import '../bloc/society_bloc.dart';
import '../bloc/society_event.dart';
import '../bloc/society_state.dart';

/// Screen for creating or editing a society with enhanced features
///
/// Includes:
/// - Basic info (name, description)
/// - Privacy settings (public/private)
/// - Handicap limits with range slider
/// - Location (placeholder)
/// - Society rules
/// - Logo upload (placeholder)
class SocietyFormScreen extends StatefulWidget {
  /// The society to edit. If null, creates a new society.
  final Society? society;

  const SocietyFormScreen({super.key, this.society});

  @override
  State<SocietyFormScreen> createState() => _SocietyFormScreenState();
}

class _SocietyFormScreenState extends State<SocietyFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _rulesController;

  // Toggle states
  late bool _isPublic;
  late bool _handicapLimitEnabled;

  // Handicap range values (+8 to 36)
  late RangeValues _handicapRange;

  // Handicap constants
  static const double _handicapMinValue = -8.0; // +8 handicap
  static const double _handicapMaxValue = 36.0;
  static const double _handicapDefaultMin = 0.0;
  static const double _handicapDefaultMax = 24.0;

  bool get _isEditMode => widget.society != null;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _nameController = TextEditingController(text: widget.society?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.society?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.society?.location ?? '',
    );
    _rulesController = TextEditingController(text: widget.society?.rules ?? '');

    // Initialize toggle states
    _isPublic = widget.society?.isPublic ?? false;
    _handicapLimitEnabled = widget.society?.handicapLimitEnabled ?? false;

    // Initialize handicap range
    if (_handicapLimitEnabled && widget.society != null) {
      _handicapRange = RangeValues(
        (widget.society!.handicapMin ?? _handicapDefaultMin).toDouble(),
        (widget.society!.handicapMax ?? _handicapDefaultMax).toDouble(),
      );
    } else {
      _handicapRange = const RangeValues(
        _handicapDefaultMin,
        _handicapDefaultMax,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Society' : 'Create Society'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<SocietyBloc, SocietyState>(
        listener: (context, state) {
          if (state is SocietyOperationSuccess) {
            Navigator.of(context).pop();
          } else if (state is SocietyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SocietyOperationInProgress;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingHorizontal,
                    vertical: AppSpacing.screenPaddingVertical,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBasicInformationSection(),
                        SizedBox(height: AppSpacing.space6),
                        _buildPrivacySettingsSection(),
                        SizedBox(height: AppSpacing.space6),
                        _buildHandicapRequirementsSection(),
                        SizedBox(height: AppSpacing.space6),
                        _buildLocationSection(),
                        SizedBox(height: AppSpacing.space6),
                        _buildRulesSection(),
                        SizedBox(height: AppSpacing.space6),
                        _buildLogoSection(),
                        SizedBox(height: AppSpacing.space8),
                      ],
                    ),
                  ),
                ),
              ),
              _buildSaveButton(context, isLoading),
            ],
          );
        },
      ),
    );
  }

  // =========================================================================
  // SECTION: Basic Information
  // =========================================================================

  Widget _buildBasicInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameField(),
        SizedBox(height: AppSpacing.space4),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Society Name *',
        hintText: 'Enter society name',
        helperText:
            'Maximum ${ValidationConstants.societyNameMaxLength} characters',
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Society name is required';
        }
        if (value.trim().length > ValidationConstants.societyNameMaxLength) {
          return 'Society name must be ${ValidationConstants.societyNameMaxLength} characters or less';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        hintText: 'Tell members about your society',
        helperText: 'Tell members about your society',
        border: OutlineInputBorder(),
      ),
      maxLines: 4,
      validator: (value) {
        if (value != null &&
            value.trim().length >
                ValidationConstants.societyDescriptionMaxLength) {
          return 'Description must be ${ValidationConstants.societyDescriptionMaxLength} characters or less';
        }
        return null;
      },
    );
  }

  // =========================================================================
  // SECTION: Privacy Settings
  // =========================================================================

  Widget _buildPrivacySettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionDivider(),
        SizedBox(height: AppSpacing.space4),
        _buildSectionHeader('Privacy Settings'),
        SizedBox(height: AppSpacing.space3),
        _buildPrivacyToggle(),
      ],
    );
  }

  Widget _buildPrivacyToggle() {
    return SwitchListTile(
      title: const Text('Make society public'),
      subtitle: const Text(
        'Private: Only invited members can join\n'
        'Public: Anyone can discover and request to join\n'
        'Both require approval',
        style: TextStyle(fontSize: 12),
      ),
      value: _isPublic,
      activeTrackColor: AppColors.primary,
      onChanged: (value) {
        setState(() {
          _isPublic = value;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  // =========================================================================
  // SECTION: Handicap Requirements
  // =========================================================================

  Widget _buildHandicapRequirementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionDivider(),
        SizedBox(height: AppSpacing.space4),
        _buildSectionHeader('Handicap Requirements'),
        SizedBox(height: AppSpacing.space3),
        _buildHandicapLimitToggle(),
        if (_handicapLimitEnabled) ...[
          SizedBox(height: AppSpacing.space4),
          _buildHandicapRangeSlider(),
        ],
      ],
    );
  }

  Widget _buildHandicapLimitToggle() {
    return SwitchListTile(
      title: const Text('Enforce handicap limits'),
      value: _handicapLimitEnabled,
      activeTrackColor: AppColors.primary,
      onChanged: (value) {
        setState(() {
          _handicapLimitEnabled = value;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildHandicapRangeSlider() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slider labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '+8',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '0',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '18',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '36',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          // Range slider
          RangeSlider(
            values: _handicapRange,
            min: _handicapMinValue,
            max: _handicapMaxValue,
            divisions: 44, // +8 to 36 = 44 steps
            activeColor: AppColors.primary,
            labels: RangeLabels(
              _formatHandicap(_handicapRange.start),
              _formatHandicap(_handicapRange.end),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _handicapRange = values;
              });
            },
          ),
          // Current values display
          Center(
            child: Text(
              'Handicap Range: ${_formatHandicap(_handicapRange.start)} - ${_formatHandicap(_handicapRange.end)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          SizedBox(height: AppSpacing.space2),
          // Helper text
          Text(
            'Members outside this range cannot join\n'
            'In golf, +8 is better than 0 (scratch)',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _formatHandicap(double value) {
    final intValue = value.round();
    if (intValue < 0) {
      return '+${intValue.abs()}';
    }
    return intValue.toString();
  }

  // =========================================================================
  // SECTION: Location (Placeholder)
  // =========================================================================

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionDivider(),
        SizedBox(height: AppSpacing.space4),
        _buildSectionHeader('Location (Coming Soon)'),
        SizedBox(height: AppSpacing.space3),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            hintText: 'City or course name',
            helperText: 'Location picker coming soon',
            border: OutlineInputBorder(),
            enabled: false,
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // SECTION: Society Rules
  // =========================================================================

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionDivider(),
        SizedBox(height: AppSpacing.space4),
        _buildSectionHeader('Society Rules (Optional)'),
        SizedBox(height: AppSpacing.space3),
        TextFormField(
          controller: _rulesController,
          decoration: const InputDecoration(
            hintText: 'Enter any rules or guidelines...',
            border: OutlineInputBorder(),
          ),
          maxLines: 6,
        ),
      ],
    );
  }

  // =========================================================================
  // SECTION: Society Logo (Placeholder)
  // =========================================================================

  Widget _buildLogoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionDivider(),
        SizedBox(height: AppSpacing.space4),
        _buildSectionHeader('Society Logo (Optional)'),
        SizedBox(height: AppSpacing.space3),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.surfaceVariant,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppSpacing.space2),
                Text(
                  'Tap to upload',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.space2),
        Text(
          'Image upload coming soon',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // =========================================================================
  // SECTION: Common Widgets
  // =========================================================================

  Widget _buildSectionDivider() {
    return Divider(color: AppColors.grey300, height: 1);
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isLoading) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: isLoading ? null : () => _handleSave(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _isEditMode ? 'Save Changes' : 'Save Society',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          if (isLoading) ...[
            SizedBox(height: AppSpacing.space3),
            const CircularProgressIndicator(),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION: Form Submission
  // =========================================================================

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final rules = _rulesController.text.trim();

    // Get handicap values only if limits are enabled
    final handicapMin = _handicapLimitEnabled
        ? _handicapRange.start.round()
        : null;
    final handicapMax = _handicapLimitEnabled
        ? _handicapRange.end.round()
        : null;

    if (_isEditMode) {
      context.read<SocietyBloc>().add(
        SocietyUpdateRequested(
          id: widget.society!.id,
          name: name,
          description: description.isEmpty ? null : description,
          isPublic: _isPublic,
          handicapLimitEnabled: _handicapLimitEnabled,
          handicapMin: handicapMin,
          handicapMax: handicapMax,
          location: location.isEmpty ? null : location,
          rules: rules.isEmpty ? null : rules,
        ),
      );
    } else {
      // Get current user ID from AuthBloc
      final authState = context.read<AuthBloc>().state;
      if (authState is auth.AuthAuthenticated) {
        context.read<SocietyBloc>().add(
          SocietyCreateRequested(
            userId: authState.user.id,
            name: name,
            description: description.isEmpty ? null : description,
            isPublic: _isPublic,
            handicapLimitEnabled: _handicapLimitEnabled,
            handicapMin: handicapMin,
            handicapMax: handicapMax,
            location: location.isEmpty ? null : location,
            rules: rules.isEmpty ? null : rules,
          ),
        );
      }
    }
  }
}

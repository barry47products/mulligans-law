import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/validation_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/society.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart' as auth;
import '../bloc/society_bloc.dart';
import '../bloc/society_event.dart';
import '../bloc/society_state.dart';

/// Screen for creating or editing a society
class SocietyFormScreen extends StatefulWidget {
  /// The society to edit. If null, creates a new society.
  final Society? society;

  const SocietyFormScreen({super.key, this.society});

  @override
  State<SocietyFormScreen> createState() => _SocietyFormScreenState();
}

class _SocietyFormScreenState extends State<SocietyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool get _isEditMode => widget.society != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.society?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.society?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Society' : 'Create Society'),
      ),
      body: BlocConsumer<SocietyBloc, SocietyState>(
        listener: (context, state) {
          if (state is SocietyOperationSuccess) {
            // Pop the screen on success
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isLoading = state is SocietyOperationInProgress;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.space4),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNameField(),
                  SizedBox(height: AppSpacing.space4),
                  _buildDescriptionField(),
                  SizedBox(height: AppSpacing.space6),
                  _buildSaveButton(context, isLoading),
                  if (isLoading) ...[
                    SizedBox(height: AppSpacing.space4),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Society Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a society name';
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

  Widget _buildSaveButton(BuildContext context, bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => _handleSave(context),
      child: Text(_isEditMode ? 'Save Changes' : 'Create Society'),
    );
  }

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (_isEditMode) {
      context.read<SocietyBloc>().add(
        SocietyUpdateRequested(
          id: widget.society!.id,
          name: name,
          description: description.isEmpty ? null : description,
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
          ),
        );
      }
    }
  }
}

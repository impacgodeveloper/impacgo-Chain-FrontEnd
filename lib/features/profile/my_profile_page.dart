import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/providers/topnav_providers.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/ig_colors.dart';
import '../../core/theme/ig_dimensions.dart';
import '../../shared/widgets/cards/app_card.dart';
import '../../shared/widgets/layout/app_page_header.dart';
import '../../shared/widgets/layout/app_page_scaffold.dart';
import '../../shared/widgets/forms/app_text_field.dart';
import '../../shared/widgets/forms/ig_form_field.dart';
import '../../shared/widgets/forms/app_dropdown_compact.dart';
import '../../shared/widgets/buttons/app_button.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({super.key});

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: 'Sarah');
    _lastNameCtrl = TextEditingController(text: 'Alvarez');
    _emailCtrl = TextEditingController(text: 'sarah.alvarez@impacgo.com');
    _phoneCtrl = TextEditingController(text: '+1 (555) 123-4567');
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final company = ref.watch(selectedCompanyProvider);
    final branch = ref.watch(selectedBranchProvider);
    final isNarrow = MediaQuery.of(context).size.width < IgDimensions.breakpointMobile;

    return AppPageScaffold(
      header: const AppPageHeader(
        title: 'My Profile',
        subtitle: 'Manage your account settings and preferences.',
        icon: 'user',
        actions: [],
      ),
      body: AppCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Avatar Row ---
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2F6FED),
                  ),
                  child: Text('SA', style: AppTypography.tnLogoMark),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sarah Alvarez',
                        style: AppTypography.wfTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'SCM Administrator',
                        style: AppTypography.wfDesc,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Personal Information ---
            Text('Personal Information', style: AppTypography.wfTitle),
            const SizedBox(height: 16),
            IgFormGrid(
              children: [
                IgFormField(
                  label: 'First Name',
                  required: true,
                  child: AppTextField(controller: _firstNameCtrl),
                ),
                IgFormField(
                  label: 'Last Name',
                  required: true,
                  child: AppTextField(controller: _lastNameCtrl),
                ),
                IgFormField(
                  label: 'Email Address',
                  required: true,
                  child: AppTextField(controller: _emailCtrl),
                ),
                IgFormField(
                  label: 'Phone Number',
                  child: AppTextField(controller: _phoneCtrl),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Organization Defaults ---
            Text('Organization Defaults', style: AppTypography.wfTitle),
            const SizedBox(height: 16),
            IgFormGrid(
              children: [
                IgFormField(
                  label: 'Default Company',
                  child: AppDropdownCompact<String>(
                    value: company.name,
                    items: [DropdownMenuItem(value: company.name, child: Text(company.name))],
                    onChanged: (v) {},
                  ),
                ),
                IgFormField(
                  label: 'Default Branch',
                  child: AppDropdownCompact<String>(
                    value: branch,
                    items: [DropdownMenuItem(value: branch, child: Text(branch))],
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(height: 1, color: IgColors.border),
            const SizedBox(height: 24),

            // --- Action Buttons ---
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 12,
              runSpacing: 8,
              children: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.standard,
                  onPressed: () => context.go('/'),
                ),
                AppButton(
                  label: 'Save Changes',
                  variant: AppButtonVariant.primary,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

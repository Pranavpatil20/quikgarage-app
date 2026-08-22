import 'package:flutter/material.dart';

import '../../../../core/constants/support_contact.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/support_contact_card.dart';
import '../../../../l10n/app_strings.dart';

class SupportFeedbackScreen extends StatelessWidget {
  const SupportFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.supportFeedback),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          AppBottomNavBar.contentBottomPadding(context),
        ),
        children: [
          Icon(Icons.support_agent, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            s.supportFeedback,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          const SupportContactCard(),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '${s.versionLabel} ${SupportContact.appVersion}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

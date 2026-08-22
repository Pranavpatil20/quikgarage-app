import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_strings.dart';
import '../constants/support_contact.dart';
import 'glass_card.dart';

class SupportContactCard extends StatelessWidget {
  const SupportContactCard({super.key});

  Future<void> _open(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          s.supportHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          onTap: () => _open(Uri(scheme: 'mailto', path: SupportContact.email)),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
            title: Text(s.supportEmailLabel),
            subtitle: Text(SupportContact.email),
            trailing: const Icon(Icons.open_in_new, size: 18),
          ),
        ),
        for (final phone in SupportContact.phones) ...[
          const SizedBox(height: 12),
          GlassCard(
            onTap: () => _open(Uri(scheme: 'tel', path: phone.$2)),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.call_outlined, color: theme.colorScheme.primary),
              title: Text(s.supportCallLabel),
              subtitle: Text(phone.$1),
              trailing: const Icon(Icons.open_in_new, size: 18),
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../widgets/webview_screen.dart';

const String kPrivacyPolicyUrl = 'https://baseflow.ee/privacy/';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewScreen(
      url: kPrivacyPolicyUrl,
      title: AppLocalizations.of(context).privacyPolicy,
    );
  }
}

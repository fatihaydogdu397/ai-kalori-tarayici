import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../widgets/webview_screen.dart';

const String kTermsOfServiceUrl = 'https://baseflow.ee/terms/';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewScreen(
      url: kTermsOfServiceUrl,
      title: AppLocalizations.of(context).termsOfService,
    );
  }
}

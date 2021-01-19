// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter/material.dart';
import 'package:pictural/generated/l10n.dart';
import 'package:pictural/ui/utils/app_theme.dart';

import 'menu.dart';

// WIDGETS

/// Basic Scaffold to avoid boilerplate code in the application.
/// Contains a loader controlled by [_isLoading]
class BaseScaffold extends StatelessWidget {
  final AppBar appBar;

  final Widget body;

  final FloatingActionButton floatingActionButton;

  final bool _showNavigationRail;

  final bool _isLoading;

  /// If true, interactions with the UI is limited while loading.
  final bool _isInteractionLimitedWhileLoading;

  const BaseScaffold({this.appBar,
    this.body,
    this.floatingActionButton,
    bool isLoading = false,
    bool isInteractionLimitedWhileLoading = true,
    bool showNavigationRail = true})
      : _showNavigationRail = showNavigationRail,
        _isLoading = isLoading,
        _isInteractionLimitedWhileLoading = isInteractionLimitedWhileLoading;

  @override
  Widget build(BuildContext context) {
    AppTheme.instance.init(MediaQuery.of(context));
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                if (_showNavigationRail) Menu(),
                body,
              ],
            ),
            if (_isLoading) _buildLoading() else
              const SizedBox()
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildLoading() =>
      Stack(
        children: [
          if (_isInteractionLimitedWhileLoading)
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
          const Center(child: CircularProgressIndicator())
        ],
      );
}

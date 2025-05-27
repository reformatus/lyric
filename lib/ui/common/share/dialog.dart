import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lyric/ui/common/share/fullscreen_qr_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Shows an adaptive share dialog with QR code and native sharing functionality.
///
/// [title] - The title displayed at the top of the dialog\
/// [description] - Optional description text below the title\
/// [sharedTitle] - The name/title of the item being shared\
/// [sharedDescription] - Optional description of the item being shared\
/// [sharedIcon] - Optional icon for the shared item\
/// [sharedLink] - The URL/link to be shared and displayed as QR code
Future<void> showShareDialog(
  BuildContext context, {
  required String title,
  String? description,
  required String sharedTitle,
  String? sharedDescription,
  IconData? sharedIcon,
  required String sharedLink,
}) async {
  return showDialog<void>(
    context: context,
    builder: (context) => ShareDialog(
      title: title,
      description: description,
      sharedTitle: sharedTitle,
      sharedDescription: sharedDescription,
      sharedIcon: sharedIcon,
      sharedLink: sharedLink,
    ),
  );
}

class ShareDialog extends StatefulWidget {
  const ShareDialog({
    required this.title,
    this.description,
    required this.sharedTitle,
    this.sharedDescription,
    this.sharedIcon,
    required this.sharedLink,
    super.key,
  });

  final String title;
  final String? description;

  final String sharedTitle;
  final String? sharedDescription;
  final IconData? sharedIcon;
  final String sharedLink;

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  bool _copySuccess = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(widget.title)),
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              minimumSize: const Size(24, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      backgroundColor: colorScheme.surfaceContainerHighest,
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Description if provided
            if (widget.description != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Text(
                  widget.description!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],

            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                border: BoxBorder.fromLTRB(
                  top: BorderSide(
                    color: colorScheme.outline.withAlpha(60),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Shared item header
                  Row(
                    children: [
                      if (widget.sharedIcon != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.sharedIcon,
                            size: 24,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.sharedTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.sharedDescription != null)
                              Text(
                                widget.sharedDescription!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withAlpha(60),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      child: Tooltip(
                        message: 'Kód nagyítása',
                        child: InkWell(
                          onTap: () => _showFullscreenQr(context),
                          child: Hero(
                            tag: 'ShareDialogQr',
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SizedBox.square(
                                dimension: 200,
                                child: QrImageView(
                                  data: widget.sharedLink,
                                  version: QrVersions.auto,
                                  gapless: true,
                                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Link text box with copy button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outline.withAlpha(80),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.surface,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: SelectableText(
                                widget.sharedLink,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: colorScheme.outline.withAlpha(80),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: Tooltip(
                              message: 'Másolás',
                              child: InkWell(
                                onTap: () => _copyToClipboard(context),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                child: Container(
                                  width: 48,
                                  decoration: _copySuccess
                                      ? BoxDecoration(
                                          color: Colors.green.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        )
                                      : null,
                                  child: Icon(
                                    _copySuccess ? Icons.check : Icons.copy,
                                    size: 18,
                                    color: _copySuccess
                                        ? Colors.green
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Share button integrated into the dialog body
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _shareLink(context),
                      icon: const Icon(Icons.share, size: 20),
                      label: const Text('Megosztás'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: widget.sharedLink));
    if (mounted) {
      setState(() {
        _copySuccess = true;
      });
      // Reset the button state after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _copySuccess = false;
          });
        }
      });
    }
  }

  Future<void> _showFullscreenQr(BuildContext context) async {
    await showFullscreenQrDialog(
      context,
      data: widget.sharedLink,
      title: widget.sharedTitle,
    );
  }

  Future<void> _shareLink(BuildContext context) async {
    try {
      await Share.share(widget.sharedLink, subject: widget.sharedTitle);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Megosztás közben hiba lépett fel: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

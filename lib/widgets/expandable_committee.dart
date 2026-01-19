import 'package:flutter/material.dart';
import 'package:bgisp/utils/language_helper.dart';

class ExpandableCommittee extends StatefulWidget {
  final IconData icon;
  final String titleKey;
  final List<DrawerSubItem> children;
  final VoidCallback? onTap;
  final bool initiallyExpanded;

  const ExpandableCommittee({
    super.key,
    required this.icon,
    required this.titleKey,
    required this.children,
    this.onTap,
    required this.initiallyExpanded,
  });

  @override
  State<ExpandableCommittee> createState() => _ExpandableCommitteeItemState();
}

class _ExpandableCommitteeItemState extends State<ExpandableCommittee> {
  bool _isExpanded = false;
  final LanguageHelper _languageHelper = LanguageHelper();

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _languageHelper.addListener(_updateText);
  }

  @override
  void dispose() {
    _languageHelper.removeListener(_updateText);
    super.dispose();
  }

  void _updateText() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main drawer item
        ListTile(
          leading: Icon(widget.icon, color: const Color(0xFF0D47A1)),
          title: Text(
            _languageHelper.translate(widget.titleKey),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: widget.children.isNotEmpty
              ? Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF0D47A1),
                )
              : null,
          onTap: () {
            if (widget.children.isNotEmpty) {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            } else {
              widget.onTap?.call();
            }
          },
        ),

        // Expandable children
        if (_isExpanded && widget.children.isNotEmpty)
          Column(
            children: widget.children.map((child) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListTile(
                  leading: Icon(
                    child.icon,
                    size: 20,
                    color: child.color ?? Colors.blue[900],
                  ),
                  title: Text(
                    _languageHelper.translate(child.titleKey),
                    style: TextStyle(
                      fontSize: 14,
                      color: child.color ?? Colors.blue[900],
                    ),
                  ),
                  onTap: child.onTap,
                  contentPadding: const EdgeInsets.only(left: 32.0),
                  minLeadingWidth: 24,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class DrawerSubItem {
  final String titleKey;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const DrawerSubItem({
    required this.titleKey,
    required this.icon,
    required this.onTap,
    this.color,
  });
}
import 'package:flutter/material.dart';
import 'package:sharezone_widgets/widgets.dart';

class CardWithIconAndText extends StatelessWidget {
  const CardWithIconAndText({
    Key key,
    this.icon,
    this.text,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final Widget icon, trailing;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CustomCard(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
              child: Row(
                children: <Widget>[
                  icon,
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (trailing != null) trailing else const SizedBox(width: 8)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

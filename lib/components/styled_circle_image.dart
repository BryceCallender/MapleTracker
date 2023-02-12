import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/decorated_container.dart';

class StyledCircleImage extends StatelessWidget {
  const StyledCircleImage({Key? key, required this.url, this.padding, this.isBig})
      : super(key: key);

  final EdgeInsets? padding;
  final String? url;
  final bool? isBig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 1,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: DecoratedContainer(
            clipChild: true,
            color: Color(0xFF41464b),
            borderColor: Colors.white,
            borderWidth: 1,
            borderRadius: 99,
            child: url != null
                ? HostedImage(url!, fit: BoxFit.cover)
                : Icon(
                    Icons.person_rounded,
                    color: Colors.black,
              size: isBig != null ? 48 : null,
                  ),
          ),
        ),
      ),
    );
  }
}

class HostedImage extends StatelessWidget {
  const HostedImage(this.url, {Key? key, this.fit = BoxFit.cover})
      : super(key: key);
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    String secureUrl = url;
    if (url.contains("http://")) {
      secureUrl = secureUrl.replaceAll("http://", "https://");
    }
    return Image.network(secureUrl, fit: fit);
  }
}

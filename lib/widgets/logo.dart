import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/colors.dart';

class Logo extends StatelessWidget {
  final double size;
  final bool showText;

  const Logo({
    super.key,
    this.size = 36,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(size * 0.22),
            border: Border.all(color: AppColors.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Image.network(
              'https://raw.githubusercontent.com/NathFavour/whisperr-assets/main/whisperrflow.png',
              width: size * 0.7,
              height: size * 0.7,
              errorBuilder: (_, __, ___) => Icon(
                Icons.bolt,
                color: AppColors.electric,
                size: size * 0.6,
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Text(
            'WHISPERRFLOW',
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w900,
              fontSize: size * 0.5,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}

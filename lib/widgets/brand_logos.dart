import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Official sign-in marks for the social login buttons.
///
/// Before shipping, check each provider's branding rules:
/// Google: https://developers.google.com/identity/branding-guidelines
/// Apple: https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple
/// Facebook: https://about.meta.com/brand/resources/facebookapp/logo/
class BrandLogo extends StatelessWidget {
  const BrandLogo._(this._svg, this.size);

  const BrandLogo.google({double size = 40}) : this._(_google, size);
  const BrandLogo.apple({double size = 40}) : this._(_apple, size);
  const BrandLogo.facebook({double size = 40}) : this._(_facebook, size);

  final String _svg;
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.string(_svg, width: size, height: size);

  // Google "G" mark.
  static const _google = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
<path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
<path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
<path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
<path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
</svg>''';

  // Apple logo.
  static const _apple = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512">
<path fill="#000000" d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"/>
</svg>''';

  // Facebook "f" logo (2019+).
  static const _facebook = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
<path fill="#1877F2" d="M1024,512C1024,229.23,794.77,0,512,0S0,229.23,0,512c0,255.55,187.23,467.37,432,505.78V660H302V512H432V399.2C432,270.88,508.44,200,625.39,200,681.41,200,740,210,740,210V336H675.44c-63.6,0-83.44,39.47-83.44,79.96V512H734L711.3,660H592v357.78C836.77,979.37,1024,767.55,1024,512Z"/>
<path fill="#FFFFFF" d="M711.3,660,734,512H592V415.96C592,375.47,611.84,336,675.44,336H740V210s-58.59-10-114.61-10C508.44,200,432,270.88,432,399.2V512H302V660H432v357.78a517.396,517.396,0,0,0,160,0V660Z"/>
</svg>''';
}

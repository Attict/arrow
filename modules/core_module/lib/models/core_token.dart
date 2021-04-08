///
/// core_token.dart
/// ~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: November 11, 2019
///
///
part of core_module;

///
/// CoreToken
///
/// This is a client-side only data model, which controls secure
/// tokens.  Primarily used to control the refresh and access tokens,
/// and potentially any other tokens.
///
class CoreToken {
  ///
  /// empty
  ///
  /// Returns an empty formatted string for the named token.
  ///
  static String empty(String name, {String path: '/'}) {
    return '$name=;expires=Thu, 01 Jan 1970 00:00:01 GMT;path=$path';
  }

  ///
  /// name
  ///
  /// The name of the token.  Used to get, and delete tokens.
  ///
  final String name;

  ///
  /// value
  ///
  /// The token itself, as a string.
  ///
  final String value;

  ///
  /// expires
  ///
  /// When the token expires.
  ///
  final DateTime expires;

  ///
  /// path
  ///
  /// The root path, which the token has access too.
  ///
  final String path;

  ///
  /// httpOnly
  ///
  final bool httpOnly;

  ///
  /// secure
  ///
  final bool secure;

  ///
  /// TODO: Domain, Origin, etc.
  ///

  ///
  /// CoreToken
  ///
  CoreToken(this.name, this.value, {this.expires: null,
    this.path: null, this.httpOnly: false, this.secure: false});

  ///
  /// CoreToken.fromString
  ///
  /// Creates a token from a formatted string, separated by semi-colon.
  ///
  factory CoreToken.fromString(String s) {
    String name;
    String value;
    DateTime expires;
    String path;
    bool httpOnly = false;
    bool secure = false;


    final parts = s.split(';');
    for (final p in parts) {
      if (p == 'HttpOnly') {
        httpOnly = true;
      } else if (p == 'Secure') {
        secure = true;
      } else {
        final exp = RegExp(r'(.*?)=(.*?)($|;|,(?! ))');
        final result = exp.allMatches(p);
        for (final r in result) {
          if (r.group(1) == 'Expires') {
            expires = DateTime.parse(r.group(2));
          } else if (r.group(1) == 'Path') {
            path = r.group(2);
          } else {
            // Assume name
            name = r.group(1);
            value = r.group(2);
          }
        }
      }
    }

    return CoreToken(name, value,
        expires: expires, path: path, httpOnly: httpOnly, secure: secure);
  }

  ///
  /// add
  ///
  /// Ease-of-use function which calls the storage to add the token.
  ///
  void add() => CoreApplication.instance.storage.addToken(this);

  ///
  /// remove
  ///
  /// Ease-of-use function which calls the storage to remove the token.
  ///
  void remove() => CoreApplication.instance.storage.removeToken(name);

  ///
  /// formatted
  ///
  /// Returns the token as a formatted string, which can be used
  /// to be stored in the application as a cookie or other form.
  ///
  String formatted() {
    final expiresString = (expires != null)
        ? 'Expires=${formattedDate()};' : '';
    final pathString = (path != null) ? 'Path=$path;' : '';
    final httpOnlyString = (httpOnly) ? 'HttpOnly;' : '';
    final secureString = (secure) ? 'Secure;' : '';
    return '$name=$value;$expiresString$pathString$httpOnlyString$secureString';
  }

  ///
  /// formattedDate
  ///
  /// Matches the formatting for cookies.
  ///
  String formattedDate() {
    final List<String> weekdays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Api',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final utc = expires.toUtc();
    final weekday = weekdays[utc.weekday - 1];
    final day = utc.day;
    final month = months[utc.month - 1];
    final year = utc.year;
    final hour = utc.hour.toString().padLeft(2, '0');
    final minute = utc.minute.toString().padLeft(2, '0');

    return '$weekday, $day $month $year $hour:$minute:00 GMT';
  }
}

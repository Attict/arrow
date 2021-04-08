///
/// core_exception.dart
/// ~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <attictt@gmail.com>
///
///
part of core_module;

///
/// CoreException
///
/// This is how all exceptions from the server should be handled.  This
/// provides a way for the client application to share common errors.
///
/// When an exception is thrown of this type, it should be passed to the
/// `CoreApplication` and handled appropriately by the client to show the error.
/// Which will probably be a dialog.
///
class CoreException implements Exception {
  ///
  /// codes
  ///
  /// Default status code responses incase the server does not response with a
  /// message.
  ///
  static const codes = <int, List<String>> {
    0: [
      'Error',
      'Something went wrong.',
    ],
    400: [
      '400 - Bad Request',
      'The request you made, is no good.',
    ],
    401: [
      '401 - Unauthorized',
      'You are not authorized to make this request.',
    ],
    403: [
      '403 - Forbidden',
      'You are forbidden from making this request.',
    ],
    404: [
      '404 - Not Found',
      'What you were looking for was not found.',
    ],
    500: [
      '500 - Internal Server Error',
      'Something went wrong with the server.',
    ],
    502: [
      '502 - Bad Gateway',
      'The response from the server was invalid.',
    ],
  };

  ///
  /// title
  ///
  /// The title of the exception, which will give passed to the dialog's title.
  /// By default, this will just be 'Error', if none is provided.
  ///
  final String title;

  ///
  /// message
  ///
  /// The exception message, which will also be passed to the dialog as it's
  /// message.  This is required to be provided.
  ///
  final String message;

  ///
  /// code
  ///
  /// *Optional* defaults to null.
  ///
  /// The error code number for reference.
  ///
  final int code;

  ///
  /// CoreException
  ///
  /// Construct with a message, and optionally a title.
  ///
  const CoreException(this.message, {
    this.title: 'Error',
    this.code,
  });


  ///
  /// CoreException.fromCode
  ///
  /// Returns an Exception from an HTTP status code.  This allows for the
  /// message to be overridden.
  ///
  factory CoreException.fromCode(int code, {String message}) {
    if (codes[code] == null) {
      code = 0;
    }
    return CoreException(
      message ?? codes[code][1],
      title: codes[code][0],
      code: code,
    );
  }

  ///
  /// CodeException.fromResponse
  ///
  /// Returns an Exception from an HTTP response, and uses the response
  /// data to determine the title and the message if they exist.
  /// Otherwise uses the default message and title from the code list above.
  ///
  factory CoreException.fromResponse(http.Response response) {
    final data = response.body.isNotEmpty ? json.decode(response.body) : null;
    final code = response.statusCode;
    final message = data != null && data['message'] != null
        ? data['message'] : codes[code][1];
    final title = data != null && data['title'] != null && data['title'] != ""
        ? data['title'] : codes[code][0];
    if (data['logout'] != null && data['logout'] == true) {
      CoreApplication.instance.logout();
    }
    return CoreException(message, title: title, code: code);
  }
}


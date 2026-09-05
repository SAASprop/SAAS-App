/// Route paths as constants so no screen types a raw string.
///
/// Only the routes that exist are listed. The rest of the app's routes
/// (`/home`, `/team`, `/profile/:id`, `/leave`, `/approvals/:ref` …) get added
/// as their screens are built.
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
}

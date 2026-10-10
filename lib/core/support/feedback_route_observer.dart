import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Tracks the root navigator's route stack so the floating «كلّمنا» button
/// (features/support/feedback_fab.dart) knows which screen is on top — also
/// screens opened with Navigator.push, which don't change the URL.
class FeedbackRouteObserver extends NavigatorObserver with ChangeNotifier {
  final List<Route<dynamic>> _stack = [];
  bool _scheduled = false;

  List<Route<dynamic>> get stack => List.unmodifiable(_stack);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
    _changed();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _changed();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _changed();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final i = oldRoute == null ? -1 : _stack.indexOf(oldRoute);
    if (newRoute != null) {
      if (i >= 0) {
        _stack[i] = newRoute;
      } else {
        _stack.add(newRoute);
      }
    } else if (i >= 0) {
      _stack.removeAt(i);
    }
    _changed();
  }

  // Route changes arrive while the navigator is building; the button sits
  // above it, so it rebuilds after the frame.
  void _changed() {
    if (_scheduled) return;
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      notifyListeners();
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }
}

/// The one instance, registered on the app's GoRouter (core/routing/app_router.dart).
final feedbackRouteObserver = FeedbackRouteObserver();

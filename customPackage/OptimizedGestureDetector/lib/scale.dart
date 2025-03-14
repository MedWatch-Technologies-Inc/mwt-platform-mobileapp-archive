import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

/// Signature for when the pointers in contact with the screen have established
/// a focal point and initial scale of 1.0.
typedef GestureScaleStartCallback = void Function(OpsSStartDetails details);

/// Signature for when the pointers in contact with the screen have indicated a
/// new focal point and/or scale.
typedef GestureScaleUpdateCallback = void Function(
    OpsSUpdateDetails details);

/// Signature for when the pointers are no longer in contact with the screen.
typedef GestureScaleEndCallback = void Function(OpsSEndDetails details);

/// The possible states of a [ScaleGestureRecognizer].
enum _ScaleState {
  /// The recognizer is ready to start recognizing a gesture.
  ready,

  /// The sequence of pointer events seen thus far is consistent with a scale
  /// gesture but the gesture has not been accepted definitively.
  possible,

  /// The sequence of pointer events seen thus far has been accepted
  /// definitively as a scale gesture.
  accepted,

  /// The sequence of pointer events seen thus far has been accepted
  /// definitively as a scale gesture and the pointers established a focal point
  /// and initial scale.
  started,
}

/// Details for [GestureScaleStartCallback].
class OpsSStartDetails {
  /// Creates details for [GestureScaleStartCallback].
  ///
  /// The [focalPoint] argument must not be null.
  OpsSStartDetails({
    this.globalPointerLocations,
    this.localPointerLocations,
    this.focalPoint = Offset.zero,
    Offset? localFocalPoint,
  })  : assert(focalPoint != null),
        localFocalPoint = localFocalPoint ?? focalPoint;

  final Map<int, Offset>? globalPointerLocations;
  final Map<int, Offset>? localPointerLocations;
  final Offset focalPoint;
  final Offset localFocalPoint;

  @override
  String toString() =>
      'ScaleStartDetails(globalPointerLocations: $globalPointerLocations,\n localPointerLocations: $localPointerLocations,\nfocalPoint: $focalPoint, localFocalPoint: $localFocalPoint)';
}

/// Details for [GestureScaleUpdateCallback].
class OpsSUpdateDetails {
  /// Creates details for [GestureScaleUpdateCallback].
  ///
  /// The [focalPoint], [scale], [horizontalScale], [verticalScale], [rotation]
  /// arguments must not be null. The [scale], [horizontalScale], and [verticalScale]
  /// argument must be greater than or equal to zero.
  OpsSUpdateDetails({
    this.globalPointerLocations,
    this.localPointerLocations,
    this.focalPoint = Offset.zero,
    Offset? localFocalPoint,
    this.scale = 1.0,
    this.horizontalScale = 1.0,
    this.verticalScale = 1.0,
    this.rotation = 0.0,
  })  : assert(focalPoint != null),
        assert(scale != null && scale >= 0.0),
        assert(horizontalScale != null && horizontalScale >= 0.0),
        assert(verticalScale != null && verticalScale >= 0.0),
        assert(rotation != null),
        localFocalPoint = localFocalPoint ?? focalPoint;

  final Map<int, Offset>? globalPointerLocations;
  final Map<int, Offset>? localPointerLocations;
  final Offset focalPoint;
  final Offset localFocalPoint;
  final double scale;
  final double horizontalScale;
  final double verticalScale;
  final double rotation;

  @override
  String toString() =>
      'ScaleUpdateDetails(globalPointerLocations: $globalPointerLocations,\n localPointerLocations: $localPointerLocations,\n focalPoint: $focalPoint, localFocalPoint: $localFocalPoint, scale: $scale, horizontalScale: $horizontalScale, verticalScale: $verticalScale, rotation: $rotation)';
}

/// Details for [GestureScaleEndCallback].
class OpsSEndDetails {
  /// Creates details for [GestureScaleEndCallback].
  ///
  /// The [velocity] argument must not be null.
  OpsSEndDetails(
      {this.globalPointerLocations,
      this.localPointerLocations,
      this.velocity = Velocity.zero})
      : assert(velocity != null);

  final Map<int, Offset>? globalPointerLocations;
  final Map<int, Offset>? localPointerLocations;

  /// The velocity of the last pointer to be lifted off of the screen.
  final Velocity velocity;

  @override
  String toString() =>
      'ScaleEndDetails(globalPointerLocations: $globalPointerLocations,\n localPointerLocations: $localPointerLocations,\nvelocity: $velocity)';
}

bool _isFlingGesture(Velocity velocity) {
  assert(velocity != null);
  final double speedSquared = velocity.pixelsPerSecond.distanceSquared;
  return speedSquared > kMinFlingVelocity * kMinFlingVelocity;
}

/// Defines a line between two pointers on screen.
///
/// [_LineBetweenPointers] is an abstraction of a line between two pointers in
/// contact with the screen. Used to track the rotation of a scale gesture.
class _LineBetweenPointers {
  /// Creates a [_LineBetweenPointers]. None of the [pointerStartLocation], [pointerStartId]
  /// [pointerEndLocation] and [pointerEndId] must be null. [pointerStartId] and [pointerEndId]
  /// should be different.
  _LineBetweenPointers({
    this.pointerStartLocation = Offset.zero,
    this.pointerStartId = 0,
    this.pointerEndLocation = Offset.zero,
    this.pointerEndId = 1,
  })  : assert(pointerStartLocation != null && pointerEndLocation != null),
        assert(pointerStartId != null && pointerEndId != null),
        assert(pointerStartId != pointerEndId);

  // The location and the id of the pointer that marks the start of the line.
  final Offset? pointerStartLocation;
  final int pointerStartId;

  // The location and the id of the pointer that marks the end of the line.
  final Offset? pointerEndLocation;
  final int pointerEndId;
}

/// Recognizes a scale gesture.
///
/// [ScaleGestureRecognizer] tracks the pointers in contact with the screen and
/// calculates their focal point, indicated scale, and rotation. When a focal
/// pointer is established, the recognizer calls [onStart]. As the focal point,
/// scale, rotation change, the recognizer calls [onUpdate]. When the pointers
/// are no longer in contact with the screen, the recognizer calls [onEnd].
class OpsScaleGestureRecognizer extends OneSequenceGestureRecognizer {
  /// Create a gesture recognizer for interactions intended for scaling content.
  ///
  /// {@macro flutter.gestures.gestureRecognizer.kind}
  OpsScaleGestureRecognizer({
    Object? debugOwner,
    PointerDeviceKind? kind,
  }) : super(debugOwner: debugOwner,);

  /// The pointers in contact with the screen have established a focal point and
  /// initial scale of 1.0.
  GestureScaleStartCallback? onStart;

  /// The pointers in contact with the screen have indicated a new focal point
  /// and/or scale.
  GestureScaleUpdateCallback? onUpdate;

  /// The pointers are no longer in contact with the screen.
  GestureScaleEndCallback? onEnd;

  _ScaleState _state = _ScaleState.ready;

  Matrix4? _lastTransform;

  Offset? _initialFocalPoint;
  Offset? _currentFocalPoint;
  double? _initialSpan;
  double? _currentSpan;
  double? _initialHorizontalSpan;
  double? _currentHorizontalSpan;
  double? _initialVerticalSpan;
  double? _currentVerticalSpan;
  _LineBetweenPointers? _initialLine;
  _LineBetweenPointers? _currentLine;
  Map<int, Offset>? _pointerLocations;
  late List<int> _pointerQueue; // A queue to sort pointers in order of entrance
  final Map<int, VelocityTracker> _velocityTrackers = <int, VelocityTracker>{};

  double get _scaleFactor =>
      _initialSpan! > 0.0 ? _currentSpan! / _initialSpan! : 1.0;

  double get _horizontalScaleFactor => _initialHorizontalSpan! > 0.0
      ? _currentHorizontalSpan! / _initialHorizontalSpan!
      : 1.0;

  double get _verticalScaleFactor => _initialVerticalSpan! > 0.0
      ? _currentVerticalSpan! / _initialVerticalSpan!
      : 1.0;

  double _computeRotationFactor() {
    if (_initialLine == null || _currentLine == null) {
      return 0.0;
    }
    final double fx = _initialLine!.pointerStartLocation!.dx;
    final double fy = _initialLine!.pointerStartLocation!.dy;
    final double sx = _initialLine!.pointerEndLocation!.dx;
    final double sy = _initialLine!.pointerEndLocation!.dy;

    final double nfx = _currentLine!.pointerStartLocation!.dx;
    final double nfy = _currentLine!.pointerStartLocation!.dy;
    final double nsx = _currentLine!.pointerEndLocation!.dx;
    final double nsy = _currentLine!.pointerEndLocation!.dy;

    final double angle1 = math.atan2(fy - sy, fx - sx);
    final double angle2 = math.atan2(nfy - nsy, nfx - nsx);

    return angle2 - angle1;
  }

  @override
  void addAllowedPointer(PointerEvent event) {
    startTrackingPointer(event.pointer, event.transform);
    _velocityTrackers[event.pointer] = VelocityTracker.withKind(event.kind);
    if (_state == _ScaleState.ready) {
      _state = _ScaleState.possible;
      _initialSpan = 0.0;
      _currentSpan = 0.0;
      _initialHorizontalSpan = 0.0;
      _currentHorizontalSpan = 0.0;
      _initialVerticalSpan = 0.0;
      _currentVerticalSpan = 0.0;
      _pointerLocations = <int, Offset>{};
      _pointerQueue = <int>[];
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    assert(_state != _ScaleState.ready);
    bool didChangeConfiguration = false;
    bool shouldStartIfAccepted = false;
    if (event is PointerMoveEvent) {
      final VelocityTracker tracker = _velocityTrackers[event.pointer]!;
      assert(tracker != null);
      if (!event.synthesized)
        tracker.addPosition(event.timeStamp, event.position);
      _pointerLocations![event.pointer] = event.position;
      shouldStartIfAccepted = true;
      _lastTransform = event.transform;
    } else if (event is PointerDownEvent) {
      _pointerLocations![event.pointer] = event.position;
      _pointerQueue.add(event.pointer);
      didChangeConfiguration = true;
      shouldStartIfAccepted = true;
      _lastTransform = event.transform;
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _pointerLocations!.remove(event.pointer);
      _pointerQueue.remove(event.pointer);
      didChangeConfiguration = true;
      _lastTransform = event.transform;
    }

    _updateLines();
    _update();

    if (!didChangeConfiguration || _reconfigure(event.pointer))
      _advanceStateMachine(shouldStartIfAccepted);
    stopTrackingIfPointerNoLongerDown(event);
  }

  void _update() {
    final int count = _pointerLocations!.keys.length;

    // Compute the focal point
    Offset focalPoint = Offset.zero;
    for (int pointer in _pointerLocations!.keys) {
      focalPoint += _pointerLocations![pointer]!;
    }
    _currentFocalPoint =
        count > 0 ? focalPoint / count.toDouble() : Offset.zero;

    // Span is the average deviation from focal point. Horizontal and vertical
    // spans are the average deviations from the focal point's horizontal and
    // vertical coordinates, respectively.
    double totalDeviation = 0.0;
    double totalHorizontalDeviation = 0.0;
    double totalVerticalDeviation = 0.0;
    for (int pointer in _pointerLocations!.keys) {
      totalDeviation +=
          (_currentFocalPoint! - _pointerLocations![pointer]!).distance;
      totalHorizontalDeviation +=
          (_currentFocalPoint!.dx - _pointerLocations![pointer]!.dx).abs();
      totalVerticalDeviation +=
          (_currentFocalPoint!.dy - _pointerLocations![pointer]!.dy).abs();
    }
    _currentSpan = count > 0 ? totalDeviation / count : 0.0;
    _currentHorizontalSpan = count > 0 ? totalHorizontalDeviation / count : 0.0;
    _currentVerticalSpan = count > 0 ? totalVerticalDeviation / count : 0.0;
  }

  /// Updates [_initialLine] and [_currentLine] accordingly to the situation of
  /// the registered pointers
  void _updateLines() {
    final int count = _pointerLocations!.keys.length;
    assert(_pointerQueue.length >= count);

    /// In case of just one pointer registered, reconfigure [_initialLine]
    if (count < 2) {
      _initialLine = _currentLine;
    } else if (_initialLine != null &&
        _initialLine!.pointerStartId == _pointerQueue[0] &&
        _initialLine!.pointerEndId == _pointerQueue[1]) {
      /// Rotation updated, set the [_currentLine]
      _currentLine = _LineBetweenPointers(
        pointerStartId: _pointerQueue[0],
        pointerStartLocation: _pointerLocations![_pointerQueue[0]],
        pointerEndId: _pointerQueue[1],
        pointerEndLocation: _pointerLocations![_pointerQueue[1]],
      );
    } else {
      /// A new rotation process is on the way, set the [_initialLine]
      _initialLine = _LineBetweenPointers(
        pointerStartId: _pointerQueue[0],
        pointerStartLocation: _pointerLocations![_pointerQueue[0]],
        pointerEndId: _pointerQueue[1],
        pointerEndLocation: _pointerLocations![_pointerQueue[1]],
      );
      _currentLine = null;
    }
  }

  bool _reconfigure(int pointer) {
    _initialFocalPoint = _currentFocalPoint;
    _initialSpan = _currentSpan;
    _initialLine = _currentLine;
    _initialHorizontalSpan = _currentHorizontalSpan;
    _initialVerticalSpan = _currentVerticalSpan;
    if (_state == _ScaleState.started) {
      if (onEnd != null) {
        final VelocityTracker tracker = _velocityTrackers[pointer]!;
        assert(tracker != null);

        Velocity velocity = tracker.getVelocity();
        if (_isFlingGesture(velocity)) {
          final Offset pixelsPerSecond = velocity.pixelsPerSecond;
          if (pixelsPerSecond.distanceSquared >
              kMaxFlingVelocity * kMaxFlingVelocity)
            velocity = Velocity(
                pixelsPerSecond: (pixelsPerSecond / pixelsPerSecond.distance) *
                    kMaxFlingVelocity);
          invokeCallback<void>(
              'onEnd',
              () => onEnd!(OpsSEndDetails(
                  globalPointerLocations: _pointerLocations,
                  localPointerLocations: toLocalLocations(_pointerLocations!),
                  velocity: velocity)));
        } else {
          invokeCallback<void>(
              'onEnd',
              () => onEnd!(OpsSEndDetails(
                  globalPointerLocations: _pointerLocations,
                  localPointerLocations: toLocalLocations(_pointerLocations!),
                  velocity: Velocity.zero)));
        }
      }
      _state = _ScaleState.accepted;
      return false;
    }
    return true;
  }

  void _advanceStateMachine(bool shouldStartIfAccepted) {
    if (_state == _ScaleState.ready) _state = _ScaleState.possible;

    if (_state == _ScaleState.possible) {
      final double spanDelta = (_currentSpan! - _initialSpan!).abs();
      final double focalPointDelta =
          (_currentFocalPoint! - _initialFocalPoint!).distance;
      if (spanDelta > kScaleSlop || focalPointDelta > kPanSlop)
        resolve(GestureDisposition.accepted);
    } else if (_state.index >= _ScaleState.accepted.index) {
      resolve(GestureDisposition.accepted);
    }

    if (_state == _ScaleState.accepted && shouldStartIfAccepted) {
      _state = _ScaleState.started;
      _dispatchOnStartCallbackIfNeeded();
    }

    if (_state == _ScaleState.started && onUpdate != null)
      invokeCallback<void>('onUpdate', () {
        onUpdate!(OpsSUpdateDetails(
          globalPointerLocations: _pointerLocations,
          localPointerLocations: toLocalLocations(_pointerLocations!),
          scale: _scaleFactor,
          horizontalScale: _horizontalScaleFactor,
          verticalScale: _verticalScaleFactor,
          focalPoint: _currentFocalPoint!,
          localFocalPoint: PointerEvent.transformPosition(
              _lastTransform, _currentFocalPoint!),
          rotation: _computeRotationFactor(),
        ));
      });
  }

  void _dispatchOnStartCallbackIfNeeded() {
    assert(_state == _ScaleState.started);
    if (onStart != null)
      invokeCallback<void>('onStart', () {
        onStart!(OpsSStartDetails(
          globalPointerLocations: _pointerLocations,
          localPointerLocations: toLocalLocations(_pointerLocations!),
          focalPoint: _currentFocalPoint!,
          localFocalPoint: PointerEvent.transformPosition(
              _lastTransform, _currentFocalPoint!),
        ));
      });
  }

  Map<int, Offset> toLocalLocations(Map<int, Offset> globalLocations) {
    var localMap = Map<int, Offset>();
    globalLocations.forEach((k, v) {
      localMap[k] = v;
    });
    return localMap;
  }

  @override
  void acceptGesture(int pointer) {
    if (_state == _ScaleState.possible) {
      _state = _ScaleState.started;
      _dispatchOnStartCallbackIfNeeded();
    }
  }

  @override
  void rejectGesture(int pointer) {
    stopTrackingPointer(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    switch (_state) {
      case _ScaleState.possible:
        resolve(GestureDisposition.rejected);
        break;
      case _ScaleState.ready:
        assert(false); // We should have not seen a pointer yet
        break;
      case _ScaleState.accepted:
        break;
      case _ScaleState.started:
        assert(false); // We should be in the accepted state when user is done
        break;
    }
    _state = _ScaleState.ready;
  }

  @override
  void dispose() {
    _velocityTrackers.clear();
    super.dispose();
  }

  @override
  String get debugDescription => 'scale';
}

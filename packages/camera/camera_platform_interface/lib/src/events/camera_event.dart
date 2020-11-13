/// Generic Event coming from the native side of Camera.
///
/// All [CameraEvent]s contain the `cameraId` that originated the event. This
/// should never be `null`.
///
/// This class is used as a base class for all the events that might be
/// triggered from a Camera, but it is never used directly as an event type.
///
/// Do NOT instantiate new events like `CameraEvent(cameraId)` directly,
/// use a specific class instead:
///
/// Do `class NewEvent extend CameraEvent` when creating your own events.
/// See below for examples: `CameraClosingEvent`, `CameraErrorEvent`...
/// These events are more semantic and more pleasant to use than raw generics.
/// They can be (and in fact, are) filtered by the `instanceof`-operator.
abstract class CameraEvent {
  /// The ID of the Camera this event is associated to.
  final int cameraId;

  /// Build a Camera Event, that relates a `cameraId`.
  ///
  /// The `cameraId` is the ID of the camera that triggered the event.
  CameraEvent(this.cameraId);
}

/// An event fired when the resolution preset of the camera has changed.
class ResolutionChangedEvent extends CameraEvent {
  /// The capture width in pixels.
  final int captureWidth;

  /// The capture height in pixels.
  final int captureHeight;

  /// The width of the preview in pixels.
  final int previewWidth;

  /// The height of the preview in pixels.
  final int previewHeight;

  /// Build a ResolutionChanged event triggered from the camera represented by
  /// `cameraId`.
  ///
  /// The `captureSize` represents the size of the resulting image in pixels.
  /// The `previewSize` represents the size of the generated preview in pixels.
  ResolutionChangedEvent(
    int cameraId,
    this.captureWidth,
    this.captureHeight,
    this.previewWidth,
    this.previewHeight,
  ) : super(cameraId);

  ResolutionChangedEvent.fromJson(Map<String, dynamic> json)
      : captureWidth = json['captureWidth'],
        captureHeight = json['captureHeight'],
        previewWidth = json['previewWidth'],
        previewHeight = json['previewHeight'],
        super(json['cameraId']);

  Map<String, dynamic> toJson() => {
        'cameraId': cameraId,
        'captureWidth': captureWidth,
        'captureHeight': captureHeight,
        'previewWidth': previewWidth,
        'previewHeight': previewHeight,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolutionChangedEvent &&
          runtimeType == other.runtimeType &&
          captureWidth == other.captureWidth &&
          captureHeight == other.captureHeight &&
          previewWidth == other.previewWidth &&
          previewHeight == other.previewHeight;

  @override
  int get hashCode =>
      captureWidth.hashCode ^
      captureHeight.hashCode ^
      previewWidth.hashCode ^
      previewHeight.hashCode;
}

/// An event fired when the camera is going to close.
class CameraClosingEvent extends CameraEvent {
  /// Build a CameraClosing event triggered from the camera represented by
  /// `cameraId`.
  CameraClosingEvent(int cameraId) : super(cameraId);

  CameraClosingEvent.fromJson(Map<String, dynamic> json)
      : super(json['cameraId']);

  Map<String, dynamic> toJson() => {
        'cameraId': cameraId,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraClosingEvent && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

/// An event fired when an error occured while operating the camera.
class CameraErrorEvent extends CameraEvent {
  /// Description of the error.
  final String description;

  /// Build a CameraError event triggered from the camera represented by
  /// `cameraId`.
  ///
  /// The `description` represents the error occured on the camera.
  CameraErrorEvent(int cameraId, this.description) : super(cameraId);

  CameraErrorEvent.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        super(json['cameraId']);

  Map<String, dynamic> toJson() => {
        'cameraId': cameraId,
        'description': description,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraErrorEvent &&
          runtimeType == other.runtimeType &&
          description == other.description;

  @override
  int get hashCode => description.hashCode;
}
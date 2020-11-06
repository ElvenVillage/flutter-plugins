// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:camera_platform_interface/src/types/camera_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$CameraImage tests', () {
    test('$CameraImage can be created', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      CameraImage cameraImage = CameraImage.fromPlatformData(<dynamic, dynamic>{
        'format': 35,
        'height': 1,
        'width': 4,
        'planes': [
          {
            'bytes': Uint8List.fromList([1, 2, 3, 4]),
            'bytesPerPixel': 1,
            'bytesPerRow': 4,
            'height': 1,
            'width': 4
          }
        ]
      });
      expect(cameraImage.height, 1);
      expect(cameraImage.width, 4);
      expect(cameraImage.format.group, ImageFormatGroup.yuv420);
      expect(cameraImage.planes.length, 1);
    });

    test('$CameraImage has ImageFormatGroup.yuv420 for iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      CameraImage cameraImage = CameraImage.fromPlatformData(<dynamic, dynamic>{
        'format': 875704438,
        'height': 1,
        'width': 4,
        'planes': [
          {
            'bytes': Uint8List.fromList([1, 2, 3, 4]),
            'bytesPerPixel': 1,
            'bytesPerRow': 4,
            'height': 1,
            'width': 4
          }
        ]
      });
      expect(cameraImage.format.group, ImageFormatGroup.yuv420);
    });

    test('$CameraImage has ImageFormatGroup.yuv420 for Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      CameraImage cameraImage = CameraImage.fromPlatformData(<dynamic, dynamic>{
        'format': 35,
        'height': 1,
        'width': 4,
        'planes': [
          {
            'bytes': Uint8List.fromList([1, 2, 3, 4]),
            'bytesPerPixel': 1,
            'bytesPerRow': 4,
            'height': 1,
            'width': 4
          }
        ]
      });
      expect(cameraImage.format.group, ImageFormatGroup.yuv420);
    });

    test('$CameraImage has ImageFormatGroup.bgra8888 for iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      CameraImage cameraImage = CameraImage.fromPlatformData(<dynamic, dynamic>{
        'format': 1111970369,
        'height': 1,
        'width': 4,
        'planes': [
          {
            'bytes': Uint8List.fromList([1, 2, 3, 4]),
            'bytesPerPixel': 1,
            'bytesPerRow': 4,
            'height': 1,
            'width': 4
          }
        ]
      });
      expect(cameraImage.format.group, ImageFormatGroup.bgra8888);
    });
    test('$CameraImage has ImageFormatGroup.unknown', () {
      CameraImage cameraImage = CameraImage.fromPlatformData(<dynamic, dynamic>{
        'format': null,
        'height': 1,
        'width': 4,
        'planes': [
          {
            'bytes': Uint8List.fromList([1, 2, 3, 4]),
            'bytesPerPixel': 1,
            'bytesPerRow': 4,
            'height': 1,
            'width': 4
          }
        ]
      });
      expect(cameraImage.format.group, ImageFormatGroup.unknown);
    });
  });
}

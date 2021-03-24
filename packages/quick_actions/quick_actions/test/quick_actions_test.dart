// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:quick_actions_platform_interface/platform_interface/quick_actions_platform.dart';
import 'package:quick_actions_platform_interface/quick_actions_platform_interface.dart';
import 'package:quick_actions_platform_interface/types/shortcut_item.dart';

void main() {
  group('$QuickActions', () {
    setUp(() {
      QuickActionsPlatform.instance = MockQuickActionsPlatform();
    });

    test('initialize() PlatformInterface', () async {
      QuickActions quickActions = QuickActions();
      QuickActionHandler handler = (type) {};

      await quickActions.initialize(handler);
      verify(QuickActionsPlatform.instance.initialize(handler)).called(1);
    });

    test('setShortcutItems() PlatformInterface', () {
      QuickActions quickActions = QuickActions();
      QuickActionHandler handler = (type) {};
      quickActions.initialize(handler);
      quickActions.setShortcutItems([]);

      verify(QuickActionsPlatform.instance.initialize(handler)).called(1);
      verify(QuickActionsPlatform.instance.setShortcutItems([])).called(1);
    });

    test('clearShortcutItems() PlatformInterface', () {
      QuickActions quickActions = QuickActions();
      QuickActionHandler handler = (type) {};

      quickActions.initialize(handler);
      quickActions.clearShortcutItems();

      verify(QuickActionsPlatform.instance.initialize(handler)).called(1);
      verify(QuickActionsPlatform.instance.clearShortcutItems()).called(1);
    });
  });
}

class MockQuickActionsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements QuickActionsPlatform {
  @override
  Future<void> clearShortcutItems() async =>
      super.noSuchMethod(Invocation.method(#clearShortcutItems, []));

  @override
  Future<void> initialize(QuickActionHandler? handler) async =>
      super.noSuchMethod(Invocation.method(#initialize, [handler]));

  @override
  Future<void> setShortcutItems(List<ShortcutItem>? items) async =>
      super.noSuchMethod(Invocation.method(#setShortcutItems, [items]));
}

class MockQuickActions extends QuickActions {}

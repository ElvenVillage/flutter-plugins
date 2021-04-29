//
//  ImagePickerFromLimitedGalleryUITests.m
//  RunnerUITests
//
//  Created by Yusuf Dag on 28/04/2021.
//  Copyright © 2021 The Flutter Authors. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <os/log.h>

const int kLimitedElementWaitingTime = 30;

@interface ImagePickerFromLimitedGalleryUITests : XCTestCase

@property(nonatomic, strong) XCUIApplication* app;

@end

@implementation ImagePickerFromLimitedGalleryUITests

- (void)setUp {
  [super setUp];
  // Delete the app if already exists, to test permission popups

  self.continueAfterFailure = NO;
  self.app = [[XCUIApplication alloc] init];
  [self.app launch];
  __weak typeof(self) weakSelf = self;
  [self addUIInterruptionMonitorWithDescription:@"Permission popups"
                                        handler:^BOOL(XCUIElement* _Nonnull interruptingElement) {
                                          if (@available(iOS 14, *)) {
                                            XCUIElement* limitedPhotoPermission =
                                                [interruptingElement.buttons elementBoundByIndex:0];
                                            if (![limitedPhotoPermission
                                                    waitForExistenceWithTimeout:
                                                        kLimitedElementWaitingTime]) {
                                              os_log_error(OS_LOG_DEFAULT, "%@",
                                                           weakSelf.app.debugDescription);
                                              XCTFail(@"Failed due to not able to find "
                                                      @"selectPhotos butt   on with %@ seconds",
                                                      @(kLimitedElementWaitingTime));
                                            }
                                            [limitedPhotoPermission tap];
                                          } else {
                                            XCUIElement* ok = interruptingElement.buttons[@"OK"];
                                            if (![ok waitForExistenceWithTimeout:
                                                         kLimitedElementWaitingTime]) {
                                              os_log_error(OS_LOG_DEFAULT, "%@",
                                                           weakSelf.app.debugDescription);
                                              XCTFail(@"Failed due to not able to find ok button "
                                                      @"with %@ seconds",
                                                      @(kLimitedElementWaitingTime));
                                            }
                                            [ok tap];
                                          }
                                          return YES;
                                        }];
}

- (void)tearDown {
  [super tearDown];
  [self.app terminate];
}

- (void)testSelectingFromGallery {
  [self launchPickerAndSelect];
}

- (void)launchPickerAndSelect {
  // Find and tap on the pick from gallery button.
  NSPredicate* predicateToFindImageFromGalleryButton =
      [NSPredicate predicateWithFormat:@"label == %@", @"image_picker_example_from_gallery"];

  XCUIElement* imageFromGalleryButton =
      [self.app.otherElements elementMatchingPredicate:predicateToFindImageFromGalleryButton];
  if (![imageFromGalleryButton waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
    os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
    XCTFail(@"Failed due to not able to find image from gallery button with %@ seconds",
            @(kLimitedElementWaitingTime));
  }

  XCTAssertTrue(imageFromGalleryButton.exists);
  [imageFromGalleryButton tap];

  // Find and tap on the `pick` button.
  NSPredicate* predicateToFindPickButton =
      [NSPredicate predicateWithFormat:@"label == %@", @"PICK"];

  XCUIElement* pickButton = [self.app.buttons elementMatchingPredicate:predicateToFindPickButton];
  if (![pickButton waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
    os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
    XCTFail(@"Failed due to not able to find pick button with %@ seconds",
            @(kLimitedElementWaitingTime));
  }

  XCTAssertTrue(pickButton.exists);
  [pickButton tap];

  // There is a known bug where the permission popups interruption won't get fired until a tap
  // happened in the app. We expect a permission popup so we do a tap here.
  [self.app tap];

  // Find an image and tap on it. (IOS 14 UI, images are showing directly)
  XCUIElement* aImage;
  if (@available(iOS 14, *)) {
    aImage = [self.app.scrollViews.firstMatch.images elementBoundByIndex:1];
  } else {
    XCUIElement* selectedPhotosCell = [self.app.cells
        elementMatchingPredicate:[NSPredicate
                                     predicateWithFormat:@"label == %@", @"Selected Photos"]];
    if (![selectedPhotosCell waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
      os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
      XCTFail(@"Failed due to not able to find \"Selected Photos\" cell with %@ seconds",
              @(kLimitedElementWaitingTime));
    }
    [selectedPhotosCell tap];
    aImage = [self.app.collectionViews elementMatchingType:XCUIElementTypeCollectionView
                                                identifier:@"PhotosGridView"]
                 .cells.firstMatch;
  }
  os_log_error(OS_LOG_DEFAULT, "description before picking image %@", self.app.debugDescription);
  if (![aImage waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
    os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
    XCTFail(@"Failed due to not able to find an image with %@ seconds",
            @(kLimitedElementWaitingTime));
  }
  XCTAssertTrue(aImage.exists);
  [aImage tap];

  // Find and tap on the `Done` button.
  NSPredicate* predicateToFindDoneButton =
      [NSPredicate predicateWithFormat:@"label == %@", @"Done"];

  XCUIElement* doneButton = [self.app.buttons elementMatchingPredicate:predicateToFindDoneButton];
  if (![doneButton waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
    os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
    XCTFail(@"Failed due to not able to find Cancel button with %@ seconds",
            @(kLimitedElementWaitingTime));
  }

  XCTAssertTrue(doneButton.exists);
  [doneButton tap];

  // Find an image and tap on it to have access to selected photos.
  if (@available(iOS 14, *)) {
    aImage = [self.app.scrollViews.firstMatch.images elementBoundByIndex:1];
  } else {
    XCUIElement* selectedPhotosCell = [self.app.cells
        elementMatchingPredicate:[NSPredicate
                                     predicateWithFormat:@"label == %@", @"Selected Photos"]];
    if (![selectedPhotosCell waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
      os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
      XCTFail(@"Failed due to not able to find \"Selected Photos\" cell with %@ seconds",
              @(kLimitedElementWaitingTime));
    }
    [selectedPhotosCell tap];
    aImage = [self.app.collectionViews elementMatchingType:XCUIElementTypeCollectionView
                                                identifier:@"PhotosGridView"]
                 .cells.firstMatch;
  }
  os_log_error(OS_LOG_DEFAULT, "description before picking image %@", self.app.debugDescription);
  if (![aImage waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
    os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
    XCTFail(@"Failed due to not able to find an image with %@ seconds",
            @(kLimitedElementWaitingTime));
  }
  XCTAssertTrue(aImage.exists);
  [aImage tap];

  // Find the picked image.
  NSPredicate* predicateToFindPickedImage =
      [NSPredicate predicateWithFormat:@"label == %@", @"image_picker_example_picked_image"];

  XCUIElement* pickedImage = [self.app.images elementMatchingPredicate:predicateToFindPickedImage];
  if (![pickedImage waitForExistenceWithTimeout:kLimitedElementWaitingTime]) {
    os_log_error(OS_LOG_DEFAULT, "%@", self.app.debugDescription);
    XCTFail(@"Failed due to not able to find pickedImage with %@ seconds",
            @(kLimitedElementWaitingTime));
  }

  XCTAssertTrue(pickedImage.exists);
}

@end

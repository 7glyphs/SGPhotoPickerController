//
//  SGPhotoPickerController.h
//  Whip Around
//
//  Created by Igor Anany on 31/03/16.
//  Copyright © 2016 7 glyphs Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGPhotoPickerController;

@protocol SGPhotoPickerControllerDelegate <NSObject>

- (void)photoPickerControllerDidPickImage:(SGPhotoPickerController *)photoPicker image:(UIImage *)image;

@end

@interface SGPhotoPickerController : UIViewController

@property (nonatomic, weak) id<SGPhotoPickerControllerDelegate> delegate;
@property (nonatomic, strong) id object;
@property (nonatomic, assign) BOOL libraryEnabled;
@property (nonatomic, assign) BOOL cameraEnabled;

- (instancetype)initWithViewController:(UIViewController *)controller;
- (void)pickPhoto;

@end

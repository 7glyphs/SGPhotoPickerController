//
//  SGPhotoPickerController.m
//  Whip Around
//
//  Created by Igor Anany on 31/03/16.
//  Copyright © 2016 7 glyphs Ltd. All rights reserved.
//

#import "SGPhotoPickerController.h"

@interface SGPhotoPickerController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL canGetFromCamera;
@property (nonatomic, strong) UIViewController * controller;

- (void)takeControll;
- (void)resignControll;
- (void)selectPhoto;
- (void)takePhoto;

@end

@implementation SGPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithViewController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.canGetFromCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    }
    return self;
}

- (void)takeControll {
    [self.controller addChildViewController:self];
}

- (void)resignControll {
    [self removeFromParentViewController];
}

- (void)pickPhoto {
    [self takeControll];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", self.canGetFromCamera ? @"Camera" : nil, nil];
    [actionSheet showInView:self.controller.view];
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.controller presentViewController:picker animated:YES completion:NULL];
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self.controller presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self selectPhoto];
    }
    else if (buttonIndex == 1 && self.canGetFromCamera) {
        [self takePhoto];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ((buttonIndex == 2 && self.canGetFromCamera) || (buttonIndex == 1 && !self.canGetFromCamera)) {
        [self resignControll];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.delegate) {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        [self.delegate photoPickerControllerDidPickImage:self image:chosenImage];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self resignControll];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self resignControll];
    }];
}
@end

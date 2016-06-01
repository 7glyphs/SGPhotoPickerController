//
//  SGPhotoPickerController.m
//  Whip Around
//
//  Created by Igor Anany on 31/03/16.
//  Copyright © 2016 7 glyphs Ltd. All rights reserved.
//

#import "SGPhotoPickerController.h"

@interface SGPhotoPickerController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
        self.cameraEnabled = YES;
        self.libraryEnabled = YES;
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
    if (self.libraryEnabled && self.cameraEnabled && self.canGetFromCamera) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self resignControll];
            [actionSheet dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self selectPhoto];
            [actionSheet dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self takePhoto];
            [actionSheet dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [self.controller presentViewController:actionSheet animated:YES completion:nil];
    }
    else {
        if (self.cameraEnabled && !self.canGetFromCamera) {
            NSLog(@"Camera source is not available");
            if (self.libraryEnabled) {
                [self selectPhoto];
            }
        }
        else if (self.cameraEnabled && self.canGetFromCamera) {
            [self takePhoto];
        }
        else if (self.libraryEnabled) {
            [self selectPhoto];
        }
    }
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

//
//  ViewController.m
//  SGPhotoPickerControllerExample
//
//  Created by Igor Anany on 1/06/16.
//  Copyright © 2016 Igor Anany. All rights reserved.
//

#import "ViewController.h"
#import "SGPhotoPickerController.h"

@interface ViewController () <SGPhotoPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickPhotoPressed:(id)sender {
    SGPhotoPickerController * photoPickerController = [[SGPhotoPickerController alloc] initWithViewController:self];
    [photoPickerController setDelegate:self];
    [photoPickerController pickPhoto];
}

#pragma mark - SGPhotoPickerControllerDelegate

- (void)photoPickerControllerDidPickImage:(SGPhotoPickerController *)photoPicker image:(UIImage *)image {
    [self.photoImageView setImage:image];
}

@end

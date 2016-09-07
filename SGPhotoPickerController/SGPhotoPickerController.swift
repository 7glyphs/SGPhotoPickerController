//
//  SGPhotoPickerController.swift
//  SGPhotoPickerControllerExample
//
//  Created by Igor Anany on 7/09/16.
//  Copyright © 2016 7 glyphs Ltd. All rights reserved.
//

import UIKit

protocol SGPhotoPickerControllerDelegate: class {
    func photoPickerController(photoPickerController: SGPhotoPickerController, didPickImage image: UIImage)
}

class SGPhotoPickerController: UIViewController {
    
    // Private properties
    
    private var canGetFromCamera: Bool
    private var controller: UIViewController
    
    // Public properties
    
    weak var delegate: SGPhotoPickerControllerDelegate?
    var object: AnyObject?
    var libraryEnabled = true
    var cameraEnabled = true
    
    // Private methods
    
    private func takeControll() {
        self.controller.addChildViewController(self)
    }
    
    private func resignControll() {
        self.removeFromParentViewController()
    }
    
    private func openPicker(type: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = type
        self.controller.presentViewController(picker, animated: true, completion: nil)
    }
    
    // Public methods
    
    init(controller: UIViewController) {
        self.controller = controller
        self.canGetFromCamera = UIImagePickerController.isSourceTypeAvailable(.Camera)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pickPhoto() {
        self.takeControll()
        if self.libraryEnabled && self.cameraEnabled && self.canGetFromCamera {
            let actionSheet = UIAlertController(title: "Add photo", message: nil, preferredStyle: .ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
                self.resignControll()
                actionSheet.dismissViewControllerAnimated(true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action) in
                self.openPicker(.PhotoLibrary)
                actionSheet.dismissViewControllerAnimated(true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action) in
                self.openPicker(.Camera)
                actionSheet.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.controller.presentViewController(actionSheet, animated: true, completion: nil)
        }
        else {
            if self.cameraEnabled && !self.canGetFromCamera {
                print("Camera source is not available")
                if self.libraryEnabled {
                    self.openPicker(.PhotoLibrary)
                }
            }
            else if self.cameraEnabled && self.canGetFromCamera {
                self.openPicker(.Camera)
            }
            else if self.libraryEnabled {
                self.openPicker(.PhotoLibrary)
            }
        }
    }
}

extension SGPhotoPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.delegate?.photoPickerController(self, didPickImage: image)
        picker.dismissViewControllerAnimated(true) {
            self.resignControll()
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) { 
            self.resignControll()
        }
    }
}
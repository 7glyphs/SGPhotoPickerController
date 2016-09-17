//
//  SGPhotoPickerController.swift
//  SGPhotoPickerControllerExample
//
//  Created by Igor Anany on 7/09/16.
//  Copyright © 2016 7 glyphs Ltd. All rights reserved.
//

import UIKit

protocol SGPhotoPickerControllerDelegate: class {
    func photoPickerController(_ photoPickerController: SGPhotoPickerController, didPickImage image: UIImage)
}

class SGPhotoPickerController: UIViewController {
    
    // Private properties
    
    fileprivate var canGetFromCamera: Bool
    fileprivate var controller: UIViewController
    
    // Public properties
    
    weak var delegate: SGPhotoPickerControllerDelegate?
    var object: AnyObject?
    var libraryEnabled = true
    var cameraEnabled = true
    
    // Private methods
    
    fileprivate func takeControll() {
        self.controller.addChildViewController(self)
    }
    
    fileprivate func resignControll() {
        self.removeFromParentViewController()
    }
    
    fileprivate func openPicker(_ type: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = type
        self.controller.present(picker, animated: true, completion: nil)
    }
    
    // Public methods
    
    init(controller: UIViewController) {
        self.controller = controller
        self.canGetFromCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pickPhoto() {
        self.takeControll()
        if self.libraryEnabled && self.cameraEnabled && self.canGetFromCamera {
            let actionSheet = UIAlertController(title: "Add photo", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.resignControll()
                actionSheet.dismiss(animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                self.openPicker(.photoLibrary)
                actionSheet.dismiss(animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.openPicker(.camera)
                actionSheet.dismiss(animated: true, completion: nil)
            }))
            self.controller.present(actionSheet, animated: true, completion: nil)
        }
        else {
            if self.cameraEnabled && !self.canGetFromCamera {
                print("Camera source is not available")
                if self.libraryEnabled {
                    self.openPicker(.photoLibrary)
                }
            }
            else if self.cameraEnabled && self.canGetFromCamera {
                self.openPicker(.camera)
            }
            else if self.libraryEnabled {
                self.openPicker(.photoLibrary)
            }
        }
    }
}

extension SGPhotoPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.delegate?.photoPickerController(self, didPickImage: image)
        picker.dismiss(animated: true) {
            self.resignControll()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { 
            self.resignControll()
        }
    }
}

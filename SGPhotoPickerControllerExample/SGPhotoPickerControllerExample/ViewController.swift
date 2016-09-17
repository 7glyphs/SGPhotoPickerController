//
//  ViewController.swift
//  SGPhotoPickerControllerExample
//
//  Created by Igor Anany on 7/09/16.
//  Copyright © 2016 7 glyphs Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickPhotoPressed(_ sender: UIButton) {
        let photoPicker = SGPhotoPickerController(controller: self)
        photoPicker.delegate = self
        photoPicker.pickPhoto()
    }

}
extension ViewController: SGPhotoPickerControllerDelegate {
    func photoPickerController(_ photoPickerController: SGPhotoPickerController, didPickImage image: UIImage) {
        self.photoImageView.image = image
    }
}

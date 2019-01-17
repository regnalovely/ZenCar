//
//  CameraViewController.swift
//  AppFive
//
//  Created by etudiant on 03/12/2018.
//  Copyright © 2018 L3P-IEM. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageName:String!
    var albumName:String!
    var imagePath:String!
    let fileManager = FileManager.default
    var documentPath:String!
    
    var imagePickerController:UIImagePickerController!
    var assetCollection:PHAssetCollection!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePath = "Images/\(albumName!)"
        btnSave.isEnabled = false
        
        PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
            ()
        })
    }
    
    @IBAction func prendrePhoto(){
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func choisirImage() {
        //
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "FR_fr")
        formatter.dateFormat = "IMG-dd-MM-yyyy-HH-mm-ss"
        let imageName = formatter.string(from: date)
        imageView.image = image
        saveImageDocumentDirectory(image: image, imageName: imageName)
    }
    
    func saveImageDocumentDirectory(image: UIImage, imageName: String) {
        documentPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imagePath)
        if !fileManager.fileExists(atPath: documentPath) {
            try! fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let imageData = image.pngData()
        fileManager.createFile(atPath: documentPath as String, contents: imageData, attributes: nil)
    }
    
    func getDirectoryPath() -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imagePath)
        let url = NSURL(string: path)
        return url!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PhotoViewController.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/21.
//

import UIKit
import CoreData

class PhotoViewController: UIViewController {

    var photoImage: UIImage? = nil
    var photoPath = ""
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var textTitle: UITextField!
    
    override var prefersStatusBarHidden: Bool {
		return true
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()

	}

    override func viewWillAppear(_ animated: Bool) {
        
        self.imageViewPhoto.image = self.photoImage
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = formatter.string(from: Date())
        self.photoPath = "\(dateString).png"
        
        self.textTitle.placeholder = dateString
        self.textTitle.placeHolderColor = UIColor.lightGray
        self.textTitle.addDoneButtonOnKeyboard()
        
    }
    
    @IBAction func actionGoBackCamera(_ sender: Any) {
        performSegue(withIdentifier: "goBackCamera", sender: self)
    }
    
    @IBAction func actionSavePhoto(_ sender: Any) {
        var soundTitle = self.textTitle.text!
        if soundTitle == "" {
            soundTitle  = self.textTitle.placeholder!
        }
        _ = self.savePhoto(path: self.photoPath, title: soundTitle)
        performSegue(withIdentifier: "goBackCamera", sender: self)
    }
    
    func savePhoto(path: String, title: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Album", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(path, forKey: "path")
        object.setValue(Date(), forKey: "date")
        object.setValue(false, forKey: "isvideo")
        
        do{
            try context.save()
            if savePhotoImage() == false {
                context.rollback()
                return false
            }
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    
    func savePhotoImage() -> Bool {
        guard let data = self.photoImage!.jpegData(compressionQuality: 1) ?? self.photoImage!.pngData() else {
            return false
        }
        do {
            try data.write(to: GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(self.photoPath))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}

//
//  DiaryInputViewController.swift
//  PetPhotoDiary
//
//  Created by Simon on 2021/05/29.
//

import UIKit
import CoreData

class DiaryInputViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var textContent: UITextView!
    @IBOutlet weak var buttonBackPhoto: UIButton!
    var imagePath = ""
    var contentText = ""
    var diaryId = ""
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textContent.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(DiaryInputViewController.handleKeyboardDidShow(notification:)),
                   name: UIResponder.keyboardDidShowNotification,
                   object: nil
               )
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(DiaryInputViewController.handleKeyboardWillHide),
                   name: UIResponder.keyboardWillHideNotification,
                   object: nil
               )
    
        self.textContent.addDoneButtonOnKeyboard()
        
        let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(imagePath)
        self.imageViewPhoto.image = UIImage(named: tmpUrl.path)
        
        if self.contentText == "" {
            self.textContent.text = ""
        }
        else {
            self.textContent.text = self.contentText
        }
        self.textContent.becomeFirstResponder()
    }
    
    func saveDiary() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: context)
        object.setValue(self.textContent.text, forKey: "content")
        object.setValue(Date(), forKey: "date")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = formatter.string(from: Date())
        object.setValue(dateString, forKey: "id")
        object.setValue(self.imagePath, forKey: "image")
        
        do{
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func updateDiary() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "id == %@", self.diaryId)
        let result = try! context.fetch(fetchRequest)
        let object = result[0]
        object.setValue(self.textContent.text, forKey: "content")
        object.setValue(self.diaryId, forKey: "id")
        object.setValue(Date(), forKey: "date")
        object.setValue(self.imagePath, forKey: "image")
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    @objc func handleKeyboardDidShow(notification: NSNotification) {
        guard let endframeKeyboard = notification
                    .userInfo![UIResponder.keyboardFrameEndUserInfoKey]
                    as? CGRect else { return }
        
        for constraint in self.view.constraints {
            if constraint.identifier == "textHeight" {
                print("endframeKeyboard.size.height=\(endframeKeyboard.size.height)")
               constraint.constant = endframeKeyboard.size.height + 10
            }
        }
        self.view.layoutIfNeeded()
        //self.textContent.constant = endframeKeyboard.size.height-85
    }

    @objc func handleKeyboardWillHide()  {
        for constraint in self.view.constraints {
            if constraint.identifier == "textHeight" {
               constraint.constant = 10
            }
        }
        self.view.layoutIfNeeded()
        //textViewBottomConstraint.constant =  // set the previous value here
    }
    
    @IBAction func actionDiaryCancel(_ sender: Any) {
        performSegue(withIdentifier: "goBackDiaryList", sender: sender)
    }
    
    @IBAction func actionDiarySave(_ sender: Any) {
        if self.isEditing == true {
            _ = self.updateDiary()
        }
        else {
            _ = self.saveDiary()
        }
        performSegue(withIdentifier: "goBackDiaryList", sender: sender)
    }
    
    @IBAction func actionBackToPhotoSelect(_ sender: Any) {
        performSegue(withIdentifier: "goPhotoSelectBack", sender: sender)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIButton == self.buttonBackPhoto {
            guard let photoSelectViewController = segue.destination as? PhotoSelectViewController else {
                return
            }
            photoSelectViewController.isEdit = self.isEdit
            photoSelectViewController.editContet = self.textContent.text
            photoSelectViewController.editDiaryId = self.diaryId
        }
    }


}


extension UITextView{
        
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

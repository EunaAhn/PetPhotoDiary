//
//  ViewController.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/20.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.labelTitle.text = ""
        self.labelDate.text = ""
        let list = fetchAlbum() as [NSManagedObject]
        if list.count == 0 {
            
            return
        }
        
        let object = list[0]
        if let title = object.value(forKey: "title") as? String,
           let path = object.value(forKey: "path") as? String,
           let date = object.value(forKey: "date") as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: date)
            let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(path)
            self.imageTitle.image = UIImage(named: tmpUrl.path)
            self.labelTitle.text = title
            self.labelDate.text = dateString
        }
        
    }
    
    
    func fetchAlbum() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Album")
        
        // sort
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }

}


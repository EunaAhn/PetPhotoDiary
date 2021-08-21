//
//  DiaryListViewController.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/21.
//

import UIKit
import CoreData

class AlbumListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableAlbum: UITableView!
    var albumList: [NSManagedObject]?
    var photoPath = ""
    var titleText = ""
    var isSelect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableAlbum.delegate = self
        self.tableAlbum.dataSource = self
        
        //_ = saveAlbum(path: "image01.png", title: "댕댕이와 춘천여행 출발", isVideo: false)
        //_ = saveAlbum(path: "image02.png", title: "댕댕이 하트 선글라스 뽕뽕", isVideo: false)
        //_ = saveAlbum(path: "image03.png", title: "코코 미용실 다녀왔어요", isVideo: false)
        //_ = saveAlbum(path: "image04.png", title: "코코 미용 기념 인증사진", isVideo: false)
        
//        let albumList = fetchAlbum()
//        for object in list {
//            if let title = object.value(forKey: "title") as? String,
//               let path = object.value(forKey: "path") as? String,
//               let date = object.value(forKey: "date") as? Date {
//                //let formatter = DateFormatter()
//                //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                //let dateString = formatter.string(from: date)
//                //print(title, path, dateString)
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let albumViewController = segue.destination as? AlbumViewController else {
            return
        }
        albumViewController.photoPath = self.photoPath
        albumViewController.titleText = self.titleText
    }
    
    // read the data
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

    func saveAlbum(path: String, title: String, isVideo:Bool) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Album", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(path, forKey: "path")
        object.setValue(Date(), forKey: "date")
        object.setValue(isVideo, forKey: "isvideo")
        
        do{
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func deleteAlbum(obejct: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(obejct)
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchAlbum().count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAlbumList", for: indexPath) as! AlbumTableViewCell
        if albumList == nil {
            albumList = fetchAlbum()
        }
        let object = albumList?[indexPath.row]
        if let title = object?.value(forKey: "title") as? String,
           let path = object?.value(forKey: "path") as? String,
           let date = object?.value(forKey: "date") as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: date)
            let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(path)
            cell.imagePhoto.image = UIImage(named: tmpUrl.path)
            cell.labelTitle.text = title
            cell.labelDate.text = dateString
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = albumList?[indexPath.row]
        if let title = object?.value(forKey: "title") as? String,
           let path = object?.value(forKey: "path") as? String {
            self.titleText = title
            self.photoPath = path
            performSegue(withIdentifier: "goPhotoView", sender: self)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let object = self.albumList?[indexPath.row] {
                if self.deleteAlbum(obejct: object) == true {
                    self.albumList?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}


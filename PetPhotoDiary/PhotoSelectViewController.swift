//
//  PhotoSelectViewController.swift
//  PetPhotoDiary
//
//  Created by Simon on 2021/05/29.
//

import UIKit
import CoreData

class PhotoSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collectPhoto: UICollectionView!
    var photoList: [NSManagedObject]!
    var selectedImage = ""
    var editDiaryId = ""
    var editContet = ""
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectPhoto.delegate = self
        self.collectPhoto.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photoList = self.fetchAlbum()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectCellPhoto", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let object = self.photoList?[indexPath.row]
        if let path = object?.value(forKey: "path") as? String {
            let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(path)
            cell.imagePhoto.image = UIImage(named: tmpUrl.path)
            cell.imagePath = path
        }
        return cell
    }

    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width / 3 - 1 // 3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
        let size = CGSize(width: width, height: width)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.photoList?[indexPath.row]
        if let path = object?.value(forKey: "path") as? String {
            print("selected : \(path)")
            self.selectedImage = path
            self.performSegue(withIdentifier: "goDiaryInput", sender: self)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let diaryInputViewController = segue.destination as? DiaryInputViewController else {
            return
        }
        diaryInputViewController.isEditing = self.isEdit
        diaryInputViewController.diaryId = self.editDiaryId
        diaryInputViewController.contentText = self.editContet
        diaryInputViewController.imagePath = self.selectedImage
    }
    

}

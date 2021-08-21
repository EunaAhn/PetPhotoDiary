//
//  DiaryListViewController.swift
//  PetPhotoDiary
//
//  Created by Simon on 2021/05/27.
//

import UIKit
import CoreData

class DiaryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var diaryList: [NSManagedObject] = []
    
    @IBOutlet weak var tableViewDiary: UITableView!
    @IBOutlet weak var buttonNewDiary: UIButton!
    @IBOutlet weak var searchDiary: UISearchBar!
    
    var selectContent = ""
    var selectImagePath = ""
    var selectDate = ""
    var editIndex = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDiary.delegate = self
        self.tableViewDiary.dataSource = self
        self.searchDiary.delegate = self
        self.getDiaryList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIBarButtonItem == self.buttonNewDiary {
            guard let photoSelectViewController = segue.destination as? PhotoSelectViewController else {
                return
            }
            photoSelectViewController.isEditing = false
            photoSelectViewController.editContet = ""
            photoSelectViewController.editDiaryId = ""
        }
        else if sender as? UITableView == self.tableViewDiary {
            guard let diaryViewController = segue.destination as? DiaryViewController else {
                return
            }
            diaryViewController.imagePath = self.selectImagePath
            diaryViewController.dateStr = self.selectDate
            diaryViewController.contentStr = self.selectContent
        }
        else { // 다이어리 편집 케이스
            guard let diaryInputViewController = segue.destination as? DiaryInputViewController else {
                return
            }
            let object = self.diaryList[self.editIndex]
            if let id = object.value(forKey: "id") as? String,
            let content = object.value(forKey: "content") as? String,
            let image = object.value(forKey: "image") as? String {
                diaryInputViewController.isEdit = true
                diaryInputViewController.diaryId = id
                diaryInputViewController.contentText = content
                diaryInputViewController.imagePath = image
            }
        }
    }

    func editDiary(index: Int) {
        self.editIndex = index
        performSegue(withIdentifier: "goDiaryEdit", sender: self)
    }
    
    func getDiaryList() {
        
//// TEST : Remove all diary list on db
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let objectsDiaryList = self.fetchDiary()
//
//        for object in objectsDiaryList {
//            context.delete(object)
//            do {
//                try context.save()
//            } catch {
//                context.rollback()
//            }
//        }
//        return
    
        
//// TEST : sample data write to db
//        let dic1 = ["content": "별군이는 경추장애견으로 일어서지도 못하던 아이지만 재활에 성공해 앞마당이며 동네를 얼마든지 걸어다닌다. 사랑이는 주인으로부터 버림받은 뒤 뇌전증세까지 보여 위험했지만(주인의 가족이 가까이 있어 얼굴은 보지만 정작 사료와 물은 다른 이웃이 챙길만큼 2차 주인의 돌봄은 거의 받지 못한다. 원주인은 한 달에 한 번 정도 와서 목욕 시켜주고 머리를 쓰다듬지만 사랑의 양이 절대부족하다), 그때부터 이웃집 아저씨인 내가 별군이 산책 때 하루 3~4회 산책을 시켜주니 금세 진짜 '사랑이'가 되어 뇌전증 증세를 보이지 않는다. 둘 다 불임 수술을 받았지만 사랑이는 암컷, 별군이는 수컷이라 매우 친하다. 별군이는 아직 후유증이 남아 있어 지치지 않도록 시간을 나누어 하루 5회 산책을 한다. 시각없는 맥스는 별군이 운동할 때마다 유모차를 타고 산책한다.", "date": "2021-05-25 21:28:50", "image": "2021-05-25-21-28-20.png"]
//        let dic2 = ["content": "우리집 별군이는 무조건 마당에 나가 쉬한다. 그렇게 버릇을 들여 놓아 쉬를 하려면 눈이 오나 비가 오나 바람이 부나 밖으로 나가야만 한다. 나야 뭐 우산 들고 뛰어야지 어쩌겠나. 방금 비가 내리는데도 기어이 나가서 쉬하고 왔다. 쉬할 때 뒷다리를 못들었는데 지금은 잘 한다. 시골집 높은 계단도 오르내리고, 대문 턱도 펄쩍 뛰어넘는다. 그러고 나니 빗줄기가 더 굵어지길래, 이 기회를 놓칠 수 없어 걸레를 들고나가 차를 닦았다. 비 많이 올 때 세차하면 참 편하다. 게으른 사람들은 알아두자. 쉬도 시키고 차도 닦고.", "date": "2021-05-25 20:58:57", "image": "2021-05-25-20-58-46.png"]
//        let dic3 = ["date": "2021-05-25 20:58:13", "image": "2021-05-25-20-57-29.png", "content": "우리 별군이는 하루 다섯 번 정도 쉬하러 마당에 나간다. 다섯 집이 공동으로 쓰는 마당이라 굉장히 넓다. 그런데 별군이는 밖에 나갈 때마다 일단 쉬를 하고 나서 마당에 사는 개 세 마리를 차례로 찾아가 인사한다. 별군이는 인사성이 워낙 밝아 아무리 추운 겨울에도, 아무리 더운 여름에도 인사를 빠뜨리는 적이 없다. 비가 와도 한다. 그럴 때마다 서로 냄새를 맡고 꼬리를 치며 서로 좋다고 난리다. 마당에 사는 세 마리 중 두 마리는 옆집이 기르는 '사랑 받는' 개들이고, 나머지 한 마리는 하얀 개인데 사랑이라는 이름과는 달리 사랑을 전혀 받지 못하는 개다. 한때 사랑이는 가족들의 사랑을 듬뿍 받으면서 실내에서 자랐다고 한다. 그런데 우리 옆집에 사는 그 집 딸이 손자를 낳으면서, 딸이 기르던 뚱보 말티즈를 맡아 기르게 되어 도리없이 덩치가 있는 편인 사랑이를 데려와 우리 마당의 밤나무에 묶어 놓았다. 그러고는 밥도 주지 않고 물도 주지 않는다. 무슨 묵계인지 마당에서 두 마리를 기르는 옆집에서 물도 주고 사료도 주고 똥도 치워준다.?"]
//        let dic4 = ["content": "사랑이만 데리고 산책 나가면 옆집 개들이 악을 쓰며 짖어댄다. 그러면 옆집 아저씨가 웃으면서 이 아이들 산책도 시켜주니 괜찮다. 사랑이는 두 달 간 아침 저녁으로 내게 이끌려 동네를 한 바퀴 돌다가 온다. 이제는 내가 마당에 나가면 반갑다고 꼬리를 치고, 산책 시간이 되면 소리도 지른다. 적어도 하루 두 번은 사랑이에게 무슨 희망이라도 생긴 것이다. 이제 6월, 사랑이는 오늘까지 발작을 일으키지 않고 있다. 언제까지 이 상태가 지속될지 알 수가 없다. 약을 안먹이고도 뇌전증이 고쳐진다면 얼마나 좋겠는가. 사람이나 개나, 생명 가진 것은 그것이 기어가는 것이든 날아가는 것이든 걸어가는 것이든 다 사랑 없이는 살 수가 없다. 개를 20마리 이상 길러 보니 개가 원하는 건 맛난 사료, 맛난 고기가 아니라 주인의 사랑이다. 주인이 저를 사랑한다는 사실을 알기만 해도 개는 건강해진다. 틀림없는 법칙이다.", "date": "2021-05-25 14:39:33", "image": "2021-05-25-14-39-06.png"]
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        self.diaryList.append(dic1)
//        self.diaryList.append(dic2)
//        self.diaryList.append(dic3)
//        self.diaryList.append(dic4)
//
//        for item in self.diaryList {
//            let object = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: context)
//            object.setValue(item["content"] as! String, forKey: "content")
//            object.setValue(item["image"] as! String, forKey: "image")
//            object.setValue(Date(), forKey: "date")
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
//            let dateString = formatter.string(from: Date())
//            object.setValue(dateString, forKey: "id")
//
//            do{
//                try context.save()
//                    context.rollback()
//            } catch {
//                context.rollback()
//            }
//            sleep(3)
//        }
        
        
        self.diaryList = self.fetchDiary()
    }
    
    // read the data
    func fetchDiary() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
        
        // sort
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    func searchDiary(searchText : String) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
        
        if searchText != "" {
            fetchRequest.predicate = NSPredicate(format: "content CONTAINS %@", searchText)
        }
        // sort
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
       
    func deleteDiary(obejct: NSManagedObject) -> Bool {
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
    
    @IBAction func actionNewDiary(_ sender: Any) {
        performSegue(withIdentifier: "goPhotoSelect", sender: sender)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.diaryList = self.searchDiary(searchText: searchText)
        self.tableViewDiary.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchDiary.setValue("취소", forKey: "cancelButtonText")
        self.searchDiary.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchDiary.showsCancelButton = false
        self.searchDiary.text = ""
        self.diaryList = self.searchDiary(searchText: "")
        self.searchDiary.resignFirstResponder()
        self.tableViewDiary.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDiary", for: indexPath) as! DiaryTableViewCell
        
        let object =  diaryList[indexPath.row]
        if let content = object.value(forKey: "content") as? String,
           let image = object.value(forKey: "image") as? String,
           let date = object.value(forKey: "date") as? Date {
            let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(image)
            cell.delegate = self
            cell.imagePhoto.image = UIImage(named: tmpUrl.path)
            cell.labelContent.text = content
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: date)
            cell.labelDate.text = dateString
            cell.index = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = diaryList[indexPath.row]
        if let content = object.value(forKey: "content") as? String,
           let image = object.value(forKey: "image") as? String,
           let date = object.value(forKey: "date") as? Date {
            self.selectContent = content
            let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(image)
            self.selectImagePath = tmpUrl.path
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.selectDate = formatter.string(from: date)
            performSegue(withIdentifier: "goDiaryView", sender: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = self.diaryList[indexPath.row]
            if self.deleteDiary(obejct: object) == true {
                self.diaryList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }

}

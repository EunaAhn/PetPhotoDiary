//
//  SoundListViewController.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/24.
//

import UIKit
import AVFoundation
import CoreData

class SoundListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {

    var audioPlayer : AVAudioPlayer?
    var customSoundList: [NSManagedObject] = []
    
    @IBOutlet weak var tableviewSoundList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableviewSoundList.delegate = self
        self.tableviewSoundList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
               
        var userIndex = GlobalData.sharedInstance.setPrefixSound()
        
        self.customSoundList = fetchSound()
        for object in self.customSoundList {
            if let title = object.value(forKey: "title") as? String,
               let path = object.value(forKey: "path") as? String {
            
                let tmpDic: Dictionary<String, Any> = ["id": userIndex,  "title": title, "path": path ]
                GlobalData.sharedInstance.cameraSoundList.append(tmpDic)
                userIndex += 1
            }
        }
    }
    
    // read the data
    func fetchSound() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sound")
        
        // sort
        let sort = NSSortDescriptor(key: "path", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    func deleteSound(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(object)
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func previewSound(path: String)
    {
        DispatchQueue.global().async {
            
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try! AVAudioSession.sharedInstance().setActive(true)
            
            do{
                try self.audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            } catch {
                print("Error Audio Player")
            }
            
            self.audioPlayer?.delegate = self
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.volume = 10.0
            self.audioPlayer?.play()
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalData.sharedInstance.cameraSoundList.count

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = GlobalData.sharedInstance.cameraSoundList[indexPath.row]
        if let filepath = item["path"] as? String,
           let id = item["id"] as? Int {
            if id < GlobalData.sharedInstance.cameraSoundPrefixCount {
                let filename = String(filepath.split(separator: ".").first!)
                let stringPath = Bundle.main.path(forResource: filename, ofType: "mp3")!
                self.previewSound(path: stringPath)
            }
            else {
                let stringPath = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(filepath).path
                self.previewSound(path: stringPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath) as! SoundListTableViewCell
        
        cell.delegate = self
        cell.indexList = indexPath.row
        
        let item = GlobalData.sharedInstance.cameraSoundList[indexPath.row]
        if let tmpValue = item["title"] as? String {
            cell.labelTitle.text = tmpValue
        }
        if let tmpPath = item["path"] as? String {
            if GlobalData.sharedInstance.cameraSoundSelected == tmpPath {
                cell.switchSelect.setOn(true, animated: true)
            }
            else {
                cell.switchSelect.setOn(false, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var filePath = ""
        let item = GlobalData.sharedInstance.cameraSoundList[indexPath.row]
        if let tmpPath = item["path"] as? String {
            filePath = tmpPath
        }
        
        // 프리픽스 사운드나 선택된 사운드는 삭제할 수 없다.
        if indexPath.row >= GlobalData.sharedInstance.cameraSoundPrefixCount  && filePath != GlobalData.sharedInstance.cameraSoundSelected {
            if editingStyle == .delete {
                _ = soundFileRemove(at: indexPath.row)
                GlobalData.sharedInstance.cameraSoundList.remove(at: indexPath.row)
                if self.deleteSound(object: self.customSoundList[indexPath.row - GlobalData.sharedInstance.cameraSoundPrefixCount]) == true {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    func soundFileRemove(at: Int) -> Bool {
        let item = GlobalData.sharedInstance.cameraSoundList[at]
        if  let tmpFilePath = item["path"] as? String {
            let filePath = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(tmpFilePath).path
            do {
                 let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    try fileManager.removeItem(atPath: filePath)
                } else {
                    print("File does not exist")
                    return false
                }
             
            }
            catch let error as NSError {
                print("An error took place: \(error)")
                return false
            }
        }
        return true
    }
    
}

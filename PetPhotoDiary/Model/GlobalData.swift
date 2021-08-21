//
//  GlobalData.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/24.
//

import UIKit

class GlobalData {
    
    static let sharedInstance = GlobalData()
   
    init() {
   
    }
   
    var cameraSoundList: Array<Dictionary<String, Any>> = []
    var cameraSoundSelected = "dog1.mp3"
    var cameraSoundPrefixCount = 8
    
    func setPrefixSound() -> Int {
        GlobalData.sharedInstance.cameraSoundList.removeAll()
        
        let dog1: Dictionary<String, Any> = ["id": 0,  "title": "강아지 짓는 소리 1", "path": "dog1.mp3" ]
        let dog2: Dictionary<String, Any> = ["id": 1,  "title": "강아지 짓는 소리 2", "path": "dog2.mp3" ]
        let cat1: Dictionary<String, Any> = ["id": 2,  "title": "고양이 울음 소리 1", "path": "cat1.mp3" ]
        let cat2: Dictionary<String, Any> = ["id": 3,  "title": "고양이 울음 소리 2", "path": "cat2.mp3" ]
        let toys :Dictionary<String, Any> = ["id": 4,  "title": "장난감 만지면 나는 소리", "path": "toy.mp3" ]
        let whst: Dictionary<String, Any> = ["id": 5,  "title": "사람입 휘파람 소리", "path": "whistle.mp3" ]
        let bird: Dictionary<String, Any> = ["id": 6,  "title": "아기새 울음 소리", "path": "bird.mp3" ]
        let brok: Dictionary<String, Any> = ["id": 7,  "title": "유리 깨지는 소리와 비명", "path": "break.mp3" ]
        
        GlobalData.sharedInstance.cameraSoundList.append(dog1)
        GlobalData.sharedInstance.cameraSoundList.append(dog2)
        GlobalData.sharedInstance.cameraSoundList.append(cat1)
        GlobalData.sharedInstance.cameraSoundList.append(cat2)
        GlobalData.sharedInstance.cameraSoundList.append(toys)
        GlobalData.sharedInstance.cameraSoundList.append(whst)
        GlobalData.sharedInstance.cameraSoundList.append(bird)
        GlobalData.sharedInstance.cameraSoundList.append(brok)
        
        return GlobalData.sharedInstance.cameraSoundList.count
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

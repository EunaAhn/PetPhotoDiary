//
//  SoundListTableViewCell.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/24.
//

import UIKit

class SoundListTableViewCell: UITableViewCell {

    var delegate: SoundListViewController!
    var indexList = 0
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var switchSelect: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func actionSelect(_ sender: Any) {
        let item = GlobalData.sharedInstance.cameraSoundList[indexList] as Dictionary<String, Any>
        print("indexList : \(String(describing: item["title"]))")
        if let tmpPath = item["path"] as? String {
            if GlobalData.sharedInstance.cameraSoundSelected != tmpPath {
                GlobalData.sharedInstance.cameraSoundSelected = tmpPath
                UserDefaults.standard.set(tmpPath, forKey: "cameraSoundSelected")
            }
            else {
                GlobalData.sharedInstance.cameraSoundSelected = ""
                UserDefaults.standard.set(tmpPath, forKey: "cameraSoundSelected")
            }
            self.delegate.tableviewSoundList.reloadData()
        }
    }
    
}

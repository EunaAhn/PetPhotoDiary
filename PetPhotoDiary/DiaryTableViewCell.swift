//
//  DairyTableViewCell.swift
//  PetPhotoDiary
//
//  Created by Simon on 2021/05/27.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    
    var delegate: DiaryListViewController?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func actionDiaryEdit(_ sender: Any) {
        delegate?.editDiary(index: index)
    }
    
}

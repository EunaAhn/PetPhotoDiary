//
//  AlbumTableViewCell.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/21.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

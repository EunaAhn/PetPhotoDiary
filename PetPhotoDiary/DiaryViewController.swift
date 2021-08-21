//
//  DiaryViewController.swift
//  PetPhotoDiary
//
//  Created by Simon on 2021/05/27.
//

import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var textContent: UITextView!
    @IBOutlet weak var labelDate: UILabel!
    
    var contentStr = ""
    var dateStr = ""
    var imagePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imagePhoto.image = UIImage(named: imagePath)
        self.labelDate.text = dateStr
        self.textContent.isScrollEnabled = false
        self.textContent.text = contentStr
    }

    override func viewDidAppear(_ animated: Bool) {
        self.textContent.isScrollEnabled = true
    }
}

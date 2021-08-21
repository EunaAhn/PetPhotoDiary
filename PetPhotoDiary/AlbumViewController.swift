//
//  PhotoViewController.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/25.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var textTitle: UILabel!
    
    var titleText = ""
    var photoPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(self.photoPath)
        self.imagePhoto.image = UIImage(named: tmpUrl.path)
        self.textTitle.text = titleText
    }
    
    @IBAction func actionShareSNS(_ sender: Any) {
        let tmpUrl = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(self.photoPath)
        let image = UIImage(named: tmpUrl.path)
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        performSegue(withIdentifier: "goBackAlbum", sender: self)
    }
        
}

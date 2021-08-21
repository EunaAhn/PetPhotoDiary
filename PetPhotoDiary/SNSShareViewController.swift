//
//  SNSShareViewController.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/20.
//

import UIKit

class SNSShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionShareImage(_ sender: Any) {
//        let text = "This is some text that I want to share."
//          // set up activity view controller
//          let textToShare = [ text ]
//          let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//          activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//          // exclude some activity types from the list (optional)
//          activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
//
//          // present the view controller
//          self.present(activityViewController, animated: true, completion: nil)
        
        let image = UIImage(named: "image01.png")
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func actionShareVideo(_ sender: Any) {
    
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SoundRecViewController.swift
//  PetPhotoDiary
//
//  Created by Euna Ahn on 2021/05/24.
//

import UIKit
import AVFoundation
import CoreData

class SoundRecViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //MARK: IB Outlets
    @IBOutlet weak var buttonRecord: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var imageViewRec: UIImageView!
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    var imageViewGif: UIImageView!
    
    //MARK: Properties
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer?
    var isPlayingAudio = false
    var soundPath = ""
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()

        initialiseRecorder()
    }

    //MARK: Initialisation
    func initialiseRecorder() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = formatter.string(from: Date())
        
        self.soundPath = "\(dateString).m4a"
        self.textTitle.placeholder = dateString
        self.textTitle.placeHolderColor = UIColor.lightGray
        self.textTitle.addDoneButtonOnKeyboard()
        self.buttonSave.isEnabled = false
        self.buttonPlay.isEnabled = false
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("MIL GYI PERMISSION")
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
            print("failed to record!")
        }
        
        guard let imageView = UIImageView.fromGif(frame: view.frame, resourceName: "SoundRecord") else { return }
       
        self.imageViewGif = imageView
        self.imageViewGif.frame = self.imageViewRec.bounds
        self.imageViewRec.addSubview(self.imageViewGif)
        
        self.imageViewRec.clipsToBounds = true
        self.imageViewRec.layer.cornerRadius = self.imageViewRec.frame.size.height / 6

    }
    
    func preparePlayer()
    {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(self.soundPath))
        } catch {
            print("Somethingwrong with the Sound Player")
        }
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        audioPlayer?.volume = 10.0
    }
    
    @IBAction func actionGoBack(_ sender: Any) {
        performSegue(withIdentifier: "goBackSoundList", sender: self)
    }
    
    @IBAction func actionSoundSave(_ sender: Any) {
        var soundTitle = self.textTitle.text!
        if soundTitle == "" {
            soundTitle  = self.textTitle.placeholder!
        }
        _ = self.saveSound(path: self.soundPath, title: soundTitle)
        performSegue(withIdentifier: "goBackSoundList", sender: self)
    }
    
    
    @IBAction func actionPlayAudio(_ sender: UIButton) {
        if isPlayingAudio {
            //stop playing
            audioPlayer?.stop()
            sender.setTitle("재생", for: .normal)
            isPlayingAudio = false
            self.imageViewGif.stopAnimating()
        } else {
            //play recording
            isPlayingAudio = true
            sender.setTitle("종료", for: .normal)
            preparePlayer()
            audioPlayer?.play()
            self.imageViewGif.startAnimating()
        }
    }

    @IBAction func actionStartRecording(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        let audioFilename = GlobalData.sharedInstance.getDocumentsDirectory().appendingPathComponent(self.soundPath)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            buttonRecord.setTitle("종료", for: .normal)
            self.imageViewGif.startAnimating()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func saveSound(path: String, title: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Sound", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(path, forKey: "path")
        do{
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
     
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            buttonRecord.setTitle("다시 녹음", for: .normal)
            self.buttonSave.isEnabled = true
            self.buttonPlay.isEnabled = true
        } else {
            buttonRecord.setTitle("녹음", for: .normal)
            // recording failed :(
        }
        self.imageViewGif.stopAnimating()
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}

extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
         get {
             return self.placeHolderColor
         }
         set {
             self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
         }
     }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

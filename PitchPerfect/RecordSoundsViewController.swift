//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by مي الدغيلبي on 13/01/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    
    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var RecordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stoprecordButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stoprecordButton.isEnabled=false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    
    @IBAction func recourdAudio(_ sender: AnyObject) {
        
        setButtons(forRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath as Any)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        setButtons(forRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else
        {
            print(" Recording was not Successfully")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as!PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
    func setButtons(forRecording recording: Bool) {
        stoprecordButton.isEnabled = recording
        recordButton.isEnabled = !recording
        RecordingLabel.text = recording ? "Recording..." : "Tap to record"
    }
    
}


//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by SAMUEL HAVARD on 3/4/15.
//  Copyright (c) 2015 SAMUEL HAVARD. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //declare global variables
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var micDisabe: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    
    var count = 0
    
    var audioRecorder: AVAudioRecorder!
    var recordAudio: RecordAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }   //ends viewDidLoad
    
    override func viewWillAppear(animated: Bool) {
        recordLabel.hidden = true
        pauseLabel.hidden = true
        pauseButton.hidden = true
        stopButton.hidden = true
        micDisabe.enabled = true
        tapLabel.hidden = false
    }   //ends viewWill Appear
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }   //ends didreceiveMemoryWarning
    
    @IBAction func audioRecord(sender: UIButton) {
        recordLabel.hidden = false
        pauseButton.hidden = false
        stopButton.hidden = false
        micDisabe.enabled = false
        tapLabel.hidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let filePath = NSURL.fileURLWithPathComponents([dirPath, recordingName])
        println(filePath)
        
        var sessions = AVAudioSession.sharedInstance()
        sessions.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }   //ends audioRecord
    
    @IBAction func pauseButton(sender: UIButton) {
        count++
        if (count % 2 == 0) {
            audioRecorder.pause()
            recordLabel.hidden = true
            pauseLabel.hidden = false
        } else {
            recordLabel.hidden = false
            pauseLabel.hidden = true
            audioRecorder.record()
        }   //ends if / else
    }   //ends pauseButton
    
    @IBAction func stopButton(sender: AnyObject) {
        recordLabel.hidden = true
        stopButton.hidden = true
        audioRecorder.stop()
        var audioSessions = AVAudioSession.sharedInstance()
        audioSessions.setActive(false, error: nil)
    }   //ends stopButton
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordAudio = RecordAudio(path: recorder.url, title: recorder.url.lastPathComponent)
            //recordAudio.filePathURL = recorder.url
            //recordAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordAudio)
        } else {
            println("Recording was not suscessful")
            micDisabe.enabled = true
            recordLabel.hidden = true
            stopButton.hidden = true
        }   //ends if / else
    }   //ends function audioRecorderDidFinishRecording
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordAudio
            playSoundVC.recievedAudio = data
        }   //ends if
    }   //ends function prepareForSegue
}   //ends class RecordSoundsViewController


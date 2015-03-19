//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by SAMUEL HAVARD on 3/5/15.
//  Copyright (c) 2015 SAMUEL HAVARD. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //declares global variables
    var audioPlayer: AVAudioPlayer!
    var recievedAudio: RecordAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathURL, error: nil)
    }   //ends viewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }   //ends didReceiveMemoryWarning
    
    ///A button on the play sounds view controller that slows the recording
    @IBAction func slowSoundButton(sender: UIButton) {
        playBackSpeed(playSpeed: 0.5)
    }   //ends slowSoundButton
    
    ///A button on the play sounds view controller that speeds up the recording
    @IBAction func fastSoundButton(sender: UIButton) {
        playBackSpeed(playSpeed: 2.0)
    }   //ends fastSoundButton
    
    ///A button on the play sounds view controller that increases the pitch of the recording
    @IBAction func chipmunkSoundButton(sender: UIButton) {
        playBackPitch(playPitch: 1000)
    }   //ends chipmunkSoundButton
    
    ///A button on the play sounds view controller that decreases the pitch of the recording
    @IBAction func darthSoundButton(sender: UIButton) {
            playBackPitch(playPitch: -1000)
    }   //ends darthSoundButton
    
    /**
    @param stopAll stops the audio player and audio engine
    */
    func stopAll(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /**
    playBackSpeed accepts a Float and plays back the recording at that rate
    @param: Float
    0.5 is half speed
    1.0 is full speed
    2 is double speed
    */
    func playBackSpeed(#playSpeed: Float){
        stopAll()
        audioPlayer.rate = playSpeed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }   //ends playBackSpeed
    
    /**
    playBackPitch accepts a Float and plays back the recording at that pitch
    @param Float
    default is 1
    low range is -2400
    high rnage is 2400 
    */
    func playBackPitch(#playPitch: Float){
        stopAll()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = playPitch
        audioEngine.attachNode(changePitchEffect)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }   //ends playBackPitch
    
    /**
    0% dry - 100% wet
    */
    @IBAction func reverbButton(sender: UIButton) {
            playBackReverb(playReverb: 75)
    }
    
    func playBackReverb(#playReverb: Float){
        stopAll()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = playReverb
        audioEngine.attachNode(changeReverbEffect)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }   //ends playBackPitch
    
    /**
    stopPlay is a button on the play sounds view controller that calls stopAll to end playback
    */
    @IBAction func stopPlay(sender: UIButton) {
        stopAll()
    }   //ends stopPlay
    
}   //ends class PlaySoundViewController

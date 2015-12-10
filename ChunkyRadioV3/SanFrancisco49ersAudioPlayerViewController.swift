//
//  ViewController.swift
//  SwiftAudioPlayer
//
//  Created by Prashant on 01/11/15.
//  Copyright © 2015 PrashantKumar Mangukiya. All rights reserved.
//

import UIKit
import AVFoundation



class SanFrancisco49ersAudioPlayerViewController: UIViewController, AVAudioPlayerDelegate {
    
    // audio player object
    var audioPlayer = AVPlayer()
    
    // timer (used to show current track play time)
    var timer:NSTimer!
    
    
    // play list file and title list
    var playListFiles = [String]()
    var playListTitles = [String]()
    
    // total number of track
    var trackCount: Int = 0
    
    // currently playing track
    var currentTrack: Int = 0
    
    // is playing or not
    var isPlaying: Bool = false
    
    
    
    // outlet - track info label (e.g. Track 1/5)
    
    
    @IBOutlet weak var trackInfo: UILabel!
    
    // outlet - play duration label
   
    
    @IBOutlet weak var playDuration: UILabel!
    
    // outlet - track title label
   
    
    @IBOutlet weak var trackTitle: UILabel!
    
    
    
    // outlet & action - prev button
    
    
    
    @IBOutlet weak var prevButton: UIBarButtonItem!
    
    @IBAction func prevButtonAction(sender: UIBarButtonItem) {self.playPrevTrack()
    }
   
    
    
    // outlet & action - play button
    
    
  
    
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    @IBAction func playButtonAction(sender: UIBarButtonItem) {self.playTrack()
    }
  
    
    
    
    // outlet & action - pause button
    
    
    
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    @IBAction func pauseButtonAction(sender: UIBarButtonItem) {self.pauseTrack()
    }
    
  
    
    
    
    
    // outlet & action - forward button
    
    
    
   
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    @IBAction func nextButton(sender: UIBarButtonItem) {self.playNextTrack()
    }
    
  
    
    
    
    
    // MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup play list
        self.setupPlayList()
        
        // setup audio player
        //        self.setupAudioPlayer()
        
        // set button status
        self.setButtonStatus()
        
        // play track
        self.playTrack()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - AVAudio player delegate functions.
    
    // set status false and set button  when audio finished.
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
        
        // if the current track index is the same as the track count
        // end playback
        
        if currentTrack == trackCount {
            
            // set playing off
            self.isPlaying = false
            
            // invalidate scheduled timer.
            self.timer.invalidate()
            
            
            self.setButtonStatus()
            
        }
            
            // else play the next track
            
            
        else {
            playNextTrack()
            
        }
        
    }
    
    // show message if error occured while decoding the audio
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("audioPlayerDecodeErrorDidOccur")
        // print friendly error message
        
        print(error!.localizedDescription)
    }
    
    
    
    // MARK: - Utility functions
    
    // setup playList
    private func setupPlayList() {
        print("setupPlayList")
        
        // audio resource file list
        self.playListFiles = ["http://media.957thegame.com/hosting/media/kgmz/1639665/111605018/roger-craig-111605018.mp3",
            "http://media.957thegame.com/hosting/media/kgmz/1622915/111584735/charles-haley-111584735.mp3",
            "http://media.957thegame.com/hosting/media/kgmz/1622915/111585467/trent-dlifer-111585467.mp3",
            "http://media.957thegame.com/hosting/media/kgmz/1639665/111577154/matt-maiocco-111577154.mp3"]
        
        // track title list
        self.playListTitles = ["1 - Roger Craig",
            "2 - Charles Haley",
            "3 - Trent Dilfer",
            "4 - Matt Maiocco"]
        
        // total number of track
        self.trackCount = self.playListFiles.count
        
        // set current track
        self.currentTrack = 1
        
        // set playing status
        self.isPlaying = false
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.playNextTrack()
    }
    
    // play current track
    private func playTrack() {
        print("playTrack()")
        
        // set play status
        self.isPlaying = true
        
        let currentMp3 = self.playListFiles[self.currentTrack-1]
        let playerItem = AVPlayerItem( URL:NSURL( string:currentMp3)! )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        
        self.audioPlayer = AVPlayer(playerItem:playerItem)
        
        self.audioPlayer.volume = 0.7
        self.audioPlayer.rate = 1.0;
        self.audioPlayer.play()
        
        self.setButtonStatus()
    }
    
    // pause current track
    private func pauseTrack() {
        print("pauseTrack")
        
        // invalidate scheduled timer.
        //self.timer.invalidate()
        
        // set play status
        self.isPlaying = false
        
        // play currently loaded track
        self.audioPlayer.pause()
        
        self.setButtonStatus()
    }
    
    
    // play next track
    private func playNextTrack() {
        print("playNextTrack")
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack < self.trackCount {
            self.currentTrack += 1
        }
        
        // stop player if currently playing
        self.audioPlayer.pause()
        //        if self.audioPlayer.playing {
        //            self.audioPlayer.stop()
        //        }
        
        
        
        // play track
        self.playTrack()
    }
    
    
    // play prev track
    private func playPrevTrack() {
        print("playPrevTrack")
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack > 1 {
            self.currentTrack -= 1
        }
        
        // stop player if currently playing
        self.audioPlayer.pause()
        //        if self.audioPlayer.playing {
        //            self.audioPlayer.stop()
        //        }
        
        
        
        // play track
        self.playTrack()
    }
    
    
    // enable / disable player button based on track
    private func setButtonStatus() {
        print("setButtonStatus")
        
        // set play/pause button based on playing status
        if isPlaying {
            self.playButton.enabled = false
            self.pauseButton.enabled = true
        }else {
            self.playButton.enabled = true
            self.pauseButton.enabled = false
        }
        
        // set prev/next button based on current track
        if self.currentTrack == 1  {
            self.prevButton.enabled = false
            if self.trackCount > 1 {
                self.nextButton.enabled = true
            }else{
                self.nextButton.enabled = false
            }
        }else if self.currentTrack == self.trackCount {
            self.prevButton.enabled = true
            self.nextButton.enabled = false
        }else {
            self.prevButton.enabled = true
            self.nextButton.enabled = true
        }
        
        // set track info
        self.trackInfo.text = "Track \(self.currentTrack) / \(self.trackCount)"
        
        // set track title
        self.trackTitle.text = self.playListTitles[self.currentTrack - 1]
    }
    
    // update currently played time label.
    func updatePlayedTimeLabel(){
        print("updatePlayedTimeLabel")
        
        //        let currentTime = Int(self.audioPlayer.)
        //        let minutes = currentTime/60
        //        let seconds = currentTime - (minutes * 60)
        
        // update time within label
        //        self.playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
}



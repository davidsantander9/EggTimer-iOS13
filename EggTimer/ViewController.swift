//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let eggCookingMinutes: [String: Int] = [
        "Soft": 1,
        "Medium": 7,
        "Hard": 12,
    ]
    
    let seconds: Int = 60
    
    var countdownTimer: Timer?
    var secondsRemaining = 0
    var timePassed = 0
    
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func cookEggAction(_ sender: UIButton) {
            
        let hardness = sender.currentTitle
        secondsRemaining = seconds * eggCookingMinutes[hardness ?? "Soft"]!
        
        timePassed = 0
        countdownTimer?.invalidate()
        startTimer()
    }
    
    func startTimer(){
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in self?.updateTimer()}
    }

    
    @objc func updateTimer() {
           // Increment the time passed
           timePassed += 1
           if timePassed < secondsRemaining {
               timerLabel.text = getFormatTimer(seconds: secondsRemaining - timePassed)
               progressBar.progress = Float(timePassed) / Float(secondsRemaining)
           } else {
               countdownTimer?.invalidate()
               timerLabel.text = "Done"
               playSound(fileName: "alarm_sound")
           }
       }
    
    func getFormatTimer(seconds: Int) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.unitsStyle = .short
        
        let secondsTimeInterval: TimeInterval = TimeInterval(seconds)
        
        return formatter.string(from: secondsTimeInterval) ?? "0"
    }

    
    func playSound(fileName: String){
        guard let sound = Bundle.main.path(forResource: fileName, ofType: "mp3") else {
            print("Error getting the mp3 file from the main bundle.")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default )
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
        } catch {
            print("Audio file error.")
        }
        audioPlayer.play()
    }
    
}

//
//  AlarmViewvViewModel.swift
//  Final
//
//  Created by Luke Briguglio on 4/29/23.
//

import Foundation
import AVFAudio
import UIKit

class AlarmViewViewModel: ObservableObject {
    @Published var alarm: Alarm = Alarm(time: Date())
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?

    func setAlarm() {
        let calendar = Calendar.current
        let now = Date()
        
        // Get the current date components
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: now)
        
        // Combine the selected date and time into one date value
        var components = currentComponents
        let timeComponents = calendar.dateComponents([.hour, .minute], from: alarm.time)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        var alarmDate = calendar.date(from: components)!
        
        // Add 24 hours to the alarm date if it is in the past
        if alarmDate <= now {
            alarmDate = calendar.date(byAdding: .day, value: 1, to: alarmDate)!
        }
        
        // Calculate the time difference
        let diff = calendar.dateComponents([.hour, .minute, .second], from: now, to: alarmDate)
        
        // Update the time difference string
        let diffString = String(format: "%02d:%02d:%02d", diff.hour!, diff.minute!, diff.second!)
        alarm.updateTimeDifference(diffString)
        
        // Start the timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let remainingTime = Int(ceil(alarmDate.timeIntervalSinceNow))
            if remainingTime >= 0 {
                // Update the time difference string
                let hours = remainingTime / 3600
                let minutes = (remainingTime % 3600) / 60
                let seconds = remainingTime % 60
                let diffString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                self.alarm.updateTimeDifference(diffString)
            } else {
                // Stop the timer
                timer.invalidate()
                self.alarm.reached = true
                
                // Play alarm sound
                self.playSound(soundName: "alarm")
            }
        }
    }

    
    func playSound(soundName: String) {
            guard let soundFile = NSDataAsset(name: soundName) else {
                print("error")
                return
            }
            do {
                audioPlayer = try AVAudioPlayer(data: soundFile.data)
                audioPlayer?.numberOfLoops = -1 // loop indefinitely
                audioPlayer?.play()
                print("playing sound")
            } catch {
                print("error")
            }
        }
    
    func turnOffAlarm() {
        alarm.turnedOff = true
        audioPlayer?.stop()
    }
}



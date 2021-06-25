//
//  AudioRecorderController.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import Foundation
import UIKit
import AVFoundation

class AudioRecorderController: UIViewController {
    
    @IBOutlet var recordAudioButton: UIButton!
    @IBOutlet var playAudioButton: UIButton!
    
    @IBOutlet weak var recordedAudioTableView: UITableView!
    
    var savedFiles = [String]()
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var currentFileName = UUID().uuidString
    
    
    override func viewDidLoad() {
        
        
        self.recordedAudioTableView.dataSource = self
        self.recordedAudioTableView.delegate = self
        
        self.recordedAudioTableView.register(UINib.init(nibName: AppConstants.audioFileTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.audioFileTableViewCell)
        
        
        setupView()
        
       
        loadAllFiles()
        
    }
    
    
    func loadAllFiles()  {
        let defaults = UserDefaults.standard
        savedFiles = defaults.stringArray(forKey: "savedFiles") ?? [String]()
        self.recordedAudioTableView.reloadData()
    }
    
    func setupView() {
           recordingSession = AVAudioSession.sharedInstance()
           
           do {
               try recordingSession.setCategory(.playAndRecord, mode: .default)
               try recordingSession.setActive(true)
               recordingSession.requestRecordPermission() { [unowned self] allowed in
                   DispatchQueue.main.async {
                       if allowed {
                           self.loadRecordingUI()
                       } else {
                           // failed to record
                       }
                   }
               }
           } catch {
               // failed to record
           }
       }
       
       func loadRecordingUI() {
         recordAudioButton?.isEnabled = true
         playAudioButton?.isEnabled = false
         recordAudioButton?.setTitle("Tap to Record", for: .normal)
         recordAudioButton.addTarget(self, action: #selector(recordAudioButtonTapped), for: .touchUpInside)
       }
       
       @objc func recordAudioButtonTapped(_ sender: UIButton) {
           if audioRecorder == nil {
               startRecording()
           } else {
               finishRecording(success: true)
           }
       }
       
       func startRecording() {
          
           let settings = [
               AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
               AVSampleRateKey: 12000,
               AVNumberOfChannelsKey: 1,
               AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
           ]
           
           do {
               
               currentFileName = UUID().uuidString
               audioRecorder = try AVAudioRecorder(url: getFileURL(), settings: settings)
               audioRecorder.delegate = self
               audioRecorder.record()
               
               recordAudioButton.setTitle("Tap to Stop", for: .normal)
               playAudioButton.isEnabled = false
           } catch {
               finishRecording(success: false)
           }
       }
       
       func finishRecording(success: Bool) {
           audioRecorder.stop()
           audioRecorder = nil
           
           if success {
             recordAudioButton.setTitle("Start Recorder", for: .normal)
             
             let userDefault = UserDefaults.standard
             var tempFiles = userDefault.stringArray(forKey: "savedFiles") ?? [String]()
              
             tempFiles.append(currentFileName)
             userDefault.set(tempFiles, forKey: "savedFiles")
            
             loadAllFiles()
              
           } else {
             recordAudioButton.setTitle("Tap to Record", for: .normal)
               // recording failed :(
           }
           
           playAudioButton.isEnabled = true
           recordAudioButton.isEnabled = true
       }
       
       @IBAction func playAudioButtonTapped(_ sender: UIButton) {
           if (sender.titleLabel?.text == "Play Recording"){
               recordAudioButton.isEnabled = false
               sender.setTitle("Stop", for: .normal)
               preparePlayer()
               audioPlayer.play()
           } else {
               audioPlayer.stop()
               sender.setTitle("Play", for: .normal)
           }
       }
       
    func preparePlayer() {
           var error: NSError?
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
           } catch let error1 as NSError {
               error = error1
               audioPlayer = nil
           }
           
           if let err = error {
               print("AVAudioPlayer error: \(err.localizedDescription)")
           } else {
               audioPlayer.delegate = self
               audioPlayer.prepareToPlay()
               audioPlayer.volume = 10.0
           }
       }
       
       func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
       }
       
        func getFileURL() -> URL {
               let path = getDocumentsDirectory().appendingPathComponent("\(currentFileName).m4a")
               return path as URL
        }
       
     
}

extension AudioRecorderController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //MARK: Delegates
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
            NotificationUtil().scheduleNotification(title: "Recording Completed", body: "File saved as \(currentFileName).m4a", dataId: currentFileName)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordAudioButton.isEnabled = true
        playAudioButton.setTitle("Play Recording", for: .normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
}

extension AudioRecorderController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = self.savedFiles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.audioFileTableViewCell, for: indexPath) as! AudioFileTableViewCell
        cell.feed = feed
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentFileName = self.savedFiles[indexPath.row]
        self.loadRecordingUI()
        self.preparePlayer()
    }

}



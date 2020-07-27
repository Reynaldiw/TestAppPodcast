//
//  TrimAudioVC.swift
//  TestAppPodcast
//
//  Created by Reynaldi Wijaya on 27/07/20.
//  Copyright © 2020 Reynaldi Wijaya. All rights reserved.
//

import UIKit
import AVFoundation

struct Range {
    var startTime: Int
    var endTime: Int
}

class TrimAudioVC: UIViewController {

    @IBOutlet weak var renderButton: UIButton!
        @IBOutlet weak var durationLabel: UILabel!
        @IBOutlet weak var startTimeTF: UITextField!
        @IBOutlet weak var endTimeTF: UITextField!
        @IBOutlet weak var newDurationLabel: UILabel!

        var audioView: TrimAudioView { self.view as! TrimAudioView }
        
        var urls = [URL]()
        
        let audioURL = URL.init(fileURLWithPath: Bundle.main.path(forResource: "stuck-on-u", ofType: "mp3")!)
        
        var asset: AVAsset!
        
        override func loadView() {
            view = TrimAudioView()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            renderButton = audioView.renderButton
            startTimeTF = audioView.startTimeInputTF
            endTimeTF = audioView.endTimeInputTF
            durationLabel = audioView.labelDuration
            newDurationLabel = audioView.labelNewDuration
            
            asset = AVAsset(url: self.audioURL)
            
            renderButton.addTarget(self, action: #selector(renderButtonTapped(_:)), for: .touchUpInside)
            
            let duration = Int(CMTimeGetSeconds(asset.duration))
            
            durationLabel.text = "\(String(duration)) Seconds"
            
        }
        
        @objc func renderButtonTapped(_ sender: Any) {
            let startTime = Int(startTimeTF.text ?? "0")!
            let endTime = Int(endTimeTF.text ?? "20")!
            
            let range = Range(startTime: startTime, endTime: endTime)
            let range2 = Range(startTime: startTime, endTime: endTime)
            
            trimAudio(asset, fileName: "file1", rangeTime: range) { (url) in
                self.urls.append(url)
                self.trimAudio(self.asset, fileName: "file2", rangeTime: range2) { (url) in
                    self.urls.append(url)
                    self.merge(audioFilesURL: self.urls, fileName: "resultMerge") { (url) in
                        let newAvAsset = AVAsset(url: url)
                        let duration = Int(CMTimeGetSeconds(newAvAsset.duration))
                        
                        DispatchQueue.main.async {
                            self.newDurationLabel.text = "\(String(duration)) Seconds"

                        }
                    }
                }
            }
            
            renderButton.isEnabled = false
        }
        
        func trimAudio(_ asset: AVAsset, fileName: String, rangeTime: Range, successExport: @escaping(_ url: URL) -> Void) {
            
            print("\(#function)")
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let trimmedSoundFileURL = documentsDirectory.appendingPathComponent("\(fileName).m4a")
            print("saving to \(trimmedSoundFileURL.absoluteString)")
            
            if FileManager.default.fileExists(atPath: trimmedSoundFileURL.absoluteString) {
                print("sound exists, removing \(trimmedSoundFileURL.absoluteString)")
                do {
                    if try trimmedSoundFileURL.checkResourceIsReachable() {
                        print("is reachable")
                    }
                    
                    try FileManager.default.removeItem(atPath: trimmedSoundFileURL.absoluteString)
                } catch {
                    print("could not remove \(trimmedSoundFileURL)")
                    print(error.localizedDescription)
                }
                
            }
            
            print("creating export session for \(asset)")
            
            if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
                exporter.outputFileType = AVFileType.m4a
                exporter.outputURL = trimmedSoundFileURL
                
                let duration = CMTimeGetSeconds(asset.duration)
                if duration < 5.0 {
                    print("sound is not long enough")
                    return
                }
                
                // e.g. the first 5 seconds
                let startTime = CMTimeMake(value: Int64(rangeTime.startTime), timescale: 1)
                let stopTime = CMTimeMake(value: Int64(rangeTime.endTime), timescale: 1)
                exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)
                
                // do it
                exporter.exportAsynchronously(completionHandler: {
                    print("export complete \(exporter.status)")
                    
                    switch exporter.status {
                    case  AVAssetExportSessionStatus.failed:
                        
                        if let e = exporter.error {
                            print("export failed \(e)")
                        }
                        
                    case AVAssetExportSessionStatus.cancelled:
                        print("export cancelled \(String(describing: exporter.error))")
                    default:
                        successExport(trimmedSoundFileURL)
                        print("export complete")
                    }
                })
            } else {
                print("cannot create AVAssetExportSession for asset \(asset)")
            }
        }
        
        private func merge(audioFilesURL: [URL], fileName: String, successExport: @escaping(_ url: URL) -> Void) {
            
            let composition = AVMutableComposition()
            
            for i in 0..<audioFilesURL.count {
                
                //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
                let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
                
                let avAsset = AVURLAsset(url: audioFilesURL[i])
                
                let tracks =  avAsset.tracks(withMediaType: AVMediaType.audio)
                
                if tracks.count == 0 {
                    return
                }
                
                let track = tracks[0]
                
                let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 1), duration: track.timeRange.duration)
                
                try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
                
            }
            
            //create new file to receive data
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileDestinationUrl = documentDirectoryURL?.appendingPathComponent("\(fileName).m4a")
            print(fileDestinationUrl?.absoluteString ?? "")
            
            if let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) {
                
                assetExport.outputFileType = AVFileType.m4a
                assetExport.outputURL = fileDestinationUrl
                assetExport.exportAsynchronously(completionHandler: {
                    
                    switch assetExport.status{
                    case  AVAssetExportSessionStatus.failed:
                        
                        if let e = assetExport.error {
                            print("export merge failed \(e)")
                        }
                        
                    case AVAssetExportSessionStatus.cancelled:
                        print("export merge cancelled \(String(describing: assetExport.error))")
                    default:
                        successExport(fileDestinationUrl!)
                        print("export merge complete")
                    }
                })
            }
        }
        
    //    private func addAdditionalAudioInAudio(urlSourceAudio : URL, urlAdditionalAudio: URL, fileName: String, successAddAudio: @escaping(_ url: URL) -> Void) {
    //
    //        let composition = AVMutableComposition()
    //
    //        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
    //        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
    //
    //        let avAssetSourceAudio = AVURLAsset(url: urlSourceAudio)
    //        let avAssetAdditionalAudio = AVURLAsset(url: urlAdditionalAudio)
    //
    //        let tracksSource =  avAssetSourceAudio.tracks(withMediaType: AVMediaType.audio)
    //        let tracksAdditional = avAssetAdditionalAudio.tracks(withMediaType: AVMediaType.audio)
    //
    //        if tracksSource.count == 0 || tracksAdditional.count == 0 {
    //            return
    //        }
    //
    //        let trackSource = tracksSource[0]
    //        let trackAdditional = tracksAdditional[0]
    //
    //        let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 1), duration: track.timeRange.duration)
    //
    //        try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
    //
    //    }

}

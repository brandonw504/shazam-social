//
//  ContentViewModel.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import ShazamKit
import AVKit

struct ShazamMedia: Decodable {
    let title: String?
    let subtitle: String?
    let artist: String?
    let albumArtURL: URL?
    let genres: [String]
}

class ContentViewModel: NSObject, ObservableObject {
    @Published var shazamMedia =  ShazamMedia(title: "Title...",
                                              subtitle: "Subtitle...",
                                              artist: "Artist Name...",
                                              albumArtURL: URL(string: "https://google.com"),
                                              genres: ["Pop"])
    @Published var isRecording = false
    @Published var foundSong = false
    private let audioEngine = AVAudioEngine()
    private let session = SHSession()
    private let signatureGenerator = SHSignatureGenerator()

    override init() {
        super.init()
        session.delegate = self
    }

    public func startOrEndListening() {
        guard !audioEngine.isRunning else {
            let inputNode = self.audioEngine.inputNode
            inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            DispatchQueue.main.async {
                self.isRecording = false
            }
            return
        }
        let audioSession = AVAudioSession.sharedInstance()

        audioSession.requestRecordPermission { granted in
            guard granted else { return }
            try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = self.audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.session.matchStreamingBuffer(buffer, at: nil)
            }

            self.audioEngine.prepare()
            do {
                try self.audioEngine.start()
            } catch (let error) {
                assertionFailure(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isRecording = true
            }
        }
    }
}

extension ContentViewModel: SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {
        let mediaItems = match.mediaItems

        if let firstItem = mediaItems.first {
            let _shazamMedia = ShazamMedia(title: firstItem.title,
                                           subtitle: firstItem.subtitle,
                                           artist: firstItem.artist,
                                           albumArtURL: firstItem.artworkURL,
                                           genres: firstItem.genres)
            DispatchQueue.main.async {
                let inputNode = self.audioEngine.inputNode
                inputNode.removeTap(onBus: 0)
                self.shazamMedia = _shazamMedia
                self.foundSong = true
            }
        }
    }
}

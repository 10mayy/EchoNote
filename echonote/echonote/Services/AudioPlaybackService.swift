import Foundation
import AVFoundation

protocol AudioPlaybackService {
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    func play(url: URL)
    func pause()
    func stop()
}

class AudioPlayer: AudioPlaybackService, ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            isPlaying = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let player = self?.audioPlayer else { return }
                self?.currentTime = player.currentTime
                
                if !player.isPlaying {
                    self?.stop()
                }
            }
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        timer?.invalidate()
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        currentTime = 0
        timer?.invalidate()
    }
}


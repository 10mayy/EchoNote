import Foundation
import Combine

class NoteDetailViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    
    let note: VoiceNote
    private let player: AudioPlayer
    
    init(note: VoiceNote, player: AudioPlayer = AudioPlayer()) {
        self.note = note
        self.player = player
        
        player.$isPlaying.assign(to: &$isPlaying)
        player.$currentTime.assign(to: &$currentTime)
    }
    
    func togglePlayback() {
        if isPlaying {
            player.pause()
        } else {
            player.play(url: note.fileURL)
        }
    }
    
    func stop() {
        player.stop()
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let mins = Int(time) / 60
        let secs = Int(time) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}


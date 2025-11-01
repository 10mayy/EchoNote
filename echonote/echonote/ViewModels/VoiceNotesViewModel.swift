import Foundation
import Combine

class VoiceNotesViewModel: ObservableObject {
    @Published var notes: [VoiceNote] = []
    @Published var isRecording = false
    @Published var recordingTime: TimeInterval = 0
    @Published var expandedNoteId: UUID?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    
    private let recorder: AudioRecorder
    private let locationManager: LocationManager
    private let storage: StorageService
    private let player: AudioPlayer
    
    init(
        recorder: AudioRecorder = AudioRecorder(),
        locationManager: LocationManager = LocationManager(),
        storage: StorageService = VoiceNoteStorage(),
        player: AudioPlayer = AudioPlayer()
    ) {
        self.recorder = recorder
        self.locationManager = locationManager
        self.storage = storage
        self.player = player
        
        // Observe recorder state
        recorder.$isRecording.assign(to: &$isRecording)
        recorder.$recordingTime.assign(to: &$recordingTime)
        
        // Observe player state
        player.$isPlaying.assign(to: &$isPlaying)
        player.$currentTime.assign(to: &$currentTime)
        
        loadNotes()
    }
    
    func startRecording() {
        locationManager.requestLocation()
        recorder.startRecording()
    }
    
    func stopRecording() {
        guard let (url, duration) = recorder.stopRecording() else { return }
        
        do {
            let savedURL = try storage.saveRecording(from: url)
            
            let note = VoiceNote(
                id: UUID(),
                title: "New Recording \(notes.count + 1)",
                date: Date(),
                duration: duration,
                fileURL: savedURL,
                location: locationManager.currentLocation
            )
            
            notes.insert(note, at: 0)
            saveNotes()
        } catch {
            print("Failed to save recording: \(error)")
        }
    }
    
    func deleteNote(_ note: VoiceNote) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        
        // Stop playback if this note is currently expanded and playing
        if expandedNoteId == note.id {
            player.stop()
            expandedNoteId = nil
        }
        
        try? storage.deleteRecording(at: note.fileURL)
        notes.remove(at: index)
        saveNotes()
    }
    
    func deleteNotes(at offsets: IndexSet) {
        // Check if any of the deleted notes are currently expanded
        for index in offsets {
            let note = notes[index]
            if expandedNoteId == note.id {
                player.stop()
                expandedNoteId = nil
            }
            try? storage.deleteRecording(at: note.fileURL)
        }
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func renameNote(_ note: VoiceNote, to newName: String) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index].title = newName
        saveNotes()
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let mins = Int(time) / 60
        let secs = Int(time) % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    func toggleExpansion(for note: VoiceNote) {
        if expandedNoteId == note.id {
            // Collapse if already expanded
            player.stop()
            expandedNoteId = nil
        } else {
            // Stop any currently playing audio
            if let currentExpandedId = expandedNoteId {
                player.stop()
            }
            // Expand new note
            expandedNoteId = note.id
        }
    }
    
    func togglePlayback(for note: VoiceNote) {
        guard expandedNoteId == note.id else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play(url: note.fileURL)
        }
    }
    
    func stopPlayback() {
        player.stop()
    }
    
    private func saveNotes() {
        storage.saveNotes(notes)
    }
    
    private func loadNotes() {
        notes = storage.loadNotes()
    }
}


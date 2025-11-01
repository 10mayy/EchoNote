import Foundation

protocol StorageService {
    func saveNotes(_ notes: [VoiceNote])
    func loadNotes() -> [VoiceNote]
    func saveRecording(from url: URL) throws -> URL
    func deleteRecording(at url: URL) throws
}

class VoiceNoteStorage: StorageService {
    private let notesKey = "voiceNotes"
    
    func saveNotes(_ notes: [VoiceNote]) {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    func loadNotes() -> [VoiceNote] {
        guard let data = UserDefaults.standard.data(forKey: notesKey),
              let decoded = try? JSONDecoder().decode([VoiceNote].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func saveRecording(from url: URL) throws -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = UUID().uuidString + ".m4a"
        let destinationURL = documentsPath.appendingPathComponent(filename)
        try FileManager.default.copyItem(at: url, to: destinationURL)
        return destinationURL
    }
    
    func deleteRecording(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
}


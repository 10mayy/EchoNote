import SwiftUI

struct NotesListView: View {
    let notes: [VoiceNote]
    let expandedNoteId: UUID?
    let isPlaying: Bool
    let currentTime: TimeInterval
    let onNoteTap: (VoiceNote) -> Void
    let onTogglePlayback: (VoiceNote) -> Void
    let formatTime: (TimeInterval) -> String
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NoteRowView(
                    note: note,
                    isExpanded: expandedNoteId == note.id,
                    isPlaying: isPlaying && expandedNoteId == note.id,
                    currentTime: expandedNoteId == note.id ? currentTime : 0,
                    onTap: { onNoteTap(note) },
                    onTogglePlayback: { onTogglePlayback(note) },
                    formatTime: formatTime
                )
            }
            .onDelete(perform: onDelete)
        }
        .listStyle(.plain)
    }
}


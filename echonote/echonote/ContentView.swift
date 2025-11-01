import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VoiceNotesViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.notes.isEmpty && !viewModel.isRecording {
                    EmptyStateView()
                } else {
                    NotesListView(
                        notes: viewModel.notes,
                        expandedNoteId: viewModel.expandedNoteId,
                        isPlaying: viewModel.isPlaying,
                        currentTime: viewModel.currentTime,
                        onNoteTap: { note in
                            viewModel.toggleExpansion(for: note)
                        },
                        onTogglePlayback: { note in
                            viewModel.togglePlayback(for: note)
                        },
                        formatTime: viewModel.formatTime,
                        onDelete: viewModel.deleteNotes
                    )
                }
                
                Spacer()
                
                RecordingControlsView(
                    isRecording: viewModel.isRecording,
                    recordingTime: viewModel.recordingTime,
                    onRecordTap: {
                        if viewModel.isRecording {
                            viewModel.stopRecording()
                        } else {
                            // Stop any playing audio when starting to record
                            viewModel.stopPlayback()
                            viewModel.expandedNoteId = nil
                            viewModel.startRecording()
                        }
                    },
                    formatTime: viewModel.formatTime
                )
            }
            .navigationTitle("Voice Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

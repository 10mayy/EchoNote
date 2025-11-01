import SwiftUI

struct NoteDetailView: View {
    let note: VoiceNote
    let onRename: (String) -> Void
    let onDelete: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: NoteDetailViewModel
    @State private var showingRenameAlert = false
    @State private var newName = ""
    
    init(note: VoiceNote, onRename: @escaping (String) -> Void, onDelete: @escaping () -> Void) {
        self.note = note
        self.onRename = onRename
        self.onDelete = onDelete
        _viewModel = StateObject(wrappedValue: NoteDetailViewModel(note: note))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "waveform")
                    .font(.system(size: 100))
                    .foregroundColor(.blue.opacity(0.3))
                
                Text(note.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 8) {
                    Text(note.formattedDate + " at " + note.formattedTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let location = note.location {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                            Text(location)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                
                VStack(spacing: 20) {
                    Text(viewModel.formatTime(viewModel.isPlaying ? viewModel.currentTime : 0) + " / " + note.formattedDuration)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                    
                    Button(action: viewModel.togglePlayback) {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Voice Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        viewModel.stop()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            newName = note.title
                            showingRenameAlert = true
                        }) {
                            Label("Rename", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            viewModel.stop()
                            onDelete()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Rename Recording", isPresented: $showingRenameAlert) {
                TextField("Name", text: $newName)
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    onRename(newName)
                    dismiss()
                }
            }
        }
    }
}


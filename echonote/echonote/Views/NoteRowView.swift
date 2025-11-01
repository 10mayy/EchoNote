import SwiftUI

struct NoteRowView: View {
    let note: VoiceNote
    let isExpanded: Bool
    let isPlaying: Bool
    let currentTime: TimeInterval
    let onTap: () -> Void
    let onTogglePlayback: () -> Void
    let formatTime: (TimeInterval) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main note row content
            VStack(alignment: .leading, spacing: 6) {
                Text(note.title)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Text(note.formattedTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let location = note.location {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10))
                            Text(location)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                
                Text(note.formattedDuration)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
            
            // Expanded player section
            if isExpanded {
                Divider()
                    .padding(.vertical, 8)
                
                VStack(spacing: 16) {
                    // Time display
                    HStack {
                        Text(formatTime(currentTime))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.secondary)
                        Text("/")
                            .foregroundColor(.secondary)
                        Text(note.formattedDuration)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    
                    // Play/Pause button
                    Button(action: onTogglePlayback) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .center)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}


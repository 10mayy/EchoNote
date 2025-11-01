import SwiftUI

struct RecordingControlsView: View {
    let isRecording: Bool
    let recordingTime: TimeInterval
    let onRecordTap: () -> Void
    let formatTime: (TimeInterval) -> String
    
    var body: some View {
        VStack(spacing: 20) {
            if isRecording {
                VStack(spacing: 8) {
                    Text(formatTime(recordingTime))
                        .font(.system(size: 48, weight: .thin, design: .rounded))
                        .monospacedDigit()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.red)
                        Text("Recording")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 20)
            }
            
            Button(action: onRecordTap) {
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 70, height: 70)
                    
                    if isRecording {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: 28, height: 28)
                    } else {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 64, height: 64)
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}


import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.3))
            
            Text("No Recordings")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the record button to create a voice note")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


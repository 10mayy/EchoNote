# 🎙️ Voice Notes App

A beautiful, native iOS voice recording app built with SwiftUI, inspired by Apple's Voice Memos design. Record voice notes with automatic location tagging and timestamps.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-lightgrey.svg)

## ✨ Features

- 🎙️ **High-Quality Voice Recording** - Record audio in AAC format with 44.1kHz sample rate
- 📍 **Automatic Location Tagging** - Captures city and state when recording starts
- ⏰ **Timestamp & Duration** - Shows exact time, date, and length of each recording
- ▶️ **Built-in Playback** - Play recordings directly in the app
- ✏️ **Rename & Organize** - Edit recording titles and manage your notes
- 💾 **Persistent Storage** - All recordings saved locally on device
- 🎨 **Native iOS Design** - Clean, familiar interface inspired by Voice Memos

## 📱 Screenshots

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  Voice Notes    │  │   Recording...  │  │   Playback      │
│                 │  │                 │  │                 │
│  📝 Note 1      │  │     1:23       │  │   🎵 Waveform   │
│  📝 Note 2      │  │   ⚫ Recording  │  │                 │
│  📝 Note 3      │  │                 │  │   ▶️  Playing    │
│                 │  │                 │  │                 │
│       ⚫        │  │       ⬜        │  │   0:45 / 2:30   │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with protocol-based services for maximum testability and maintainability.

```
VoiceNotesApp/
├── Models/
│   └── VoiceNote.swift              # Data model
├── Services/
│   ├── AudioRecordingService.swift  # Recording protocol & implementation
│   ├── AudioPlaybackService.swift   # Playback protocol & implementation
│   ├── LocationService.swift        # Location protocol & implementation
│   └── StorageService.swift         # Persistence protocol & implementation
├── ViewModels/
│   ├── VoiceNotesViewModel.swift    # Main screen logic
│   └── NoteDetailViewModel.swift    # Detail screen logic
└── Views/
    ├── ContentView.swift            # Main container
    ├── EmptyStateView.swift         # Empty state UI
    ├── NotesListView.swift          # List display
    ├── NoteRowView.swift            # Individual row
    ├── RecordingControlsView.swift  # Recording controls
    └── NoteDetailView.swift         # Detail screen
```

### Key Design Principles

- **Protocol-Oriented**: All services use protocols for easy testing and mocking
- **Single Responsibility**: Each component has one clear purpose
- **Dependency Injection**: ViewModels accept services through initializers
- **Reactive**: Uses Combine framework for state management
- **Separation of Concerns**: Views are dumb, ViewModels contain logic

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/EchoNote.git
cd EchoNote
```

2. Open the project in Xcode
```bash
open VoiceNotesApp.xcodeproj
```

3. Add required permissions to `Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need access to record voice notes</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We'd like to add location to your voice notes</string>
```

4. Build and run the project (`Cmd + R`)

## 📖 Usage

### Recording a Voice Note
1. Tap the red **Record** button
2. Speak into your device
3. Tap the **Stop** button (square icon) when finished
4. Your note is automatically saved with location and timestamp

### Playing a Recording
1. Tap any recording in the list
2. Press the **Play** button in the detail view
3. Use **Pause** to stop playback

### Managing Notes
- **Rename**: Tap the `···` menu and select "Rename"
- **Delete**: Swipe left on a note or use the menu
- **Edit Mode**: Tap "Edit" to batch delete

## 🧪 Testing

The protocol-based architecture makes testing straightforward:

```swift
// Example: Testing VoiceNotesViewModel with mock services
class MockAudioRecorder: AudioRecordingService {
    var isRecording = false
    var recordingTime: TimeInterval = 0
    
    func startRecording() {
        isRecording = true
    }
    
    func stopRecording() -> (URL, TimeInterval)? {
        return (URL(string: "file://test.m4a")!, 10.0)
    }
}

// Use in tests
let mockRecorder = MockAudioRecorder()
let viewModel = VoiceNotesViewModel(recorder: mockRecorder)
```

## 🛠️ Technologies Used

- **SwiftUI** - Modern declarative UI framework
- **AVFoundation** - Audio recording and playback
- **CoreLocation** - Location services
- **Combine** - Reactive programming
- **UserDefaults** - Lightweight persistence

## 📂 File Storage

- Recordings stored in: `Documents/` directory
- Metadata stored in: `UserDefaults`
- Format: `.m4a` (AAC audio)

## 🔐 Privacy & Permissions

The app requests:
- **Microphone Access**: Required for recording
- **Location Access**: Optional for location tagging (app works without it)

All data is stored locally on the device. No data is sent to external servers.

## 🐛 Known Issues

- None currently reported

## 🗺️ Roadmap

- [ ] iCloud sync across devices
- [ ] Folders/categories for organization
- [ ] Audio waveform visualization
- [ ] Share recordings via system share sheet
- [ ] Dark mode optimization
- [ ] iPad support with split view
- [ ] Transcription using Speech framework
- [ ] Export to Files app

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for consistency
- Write unit tests for new features
- Update documentation as needed

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- Inspired by Apple's Voice Memos app
- Icons from SF Symbols

## 📞 Support

If you have any questions or run into issues:
- Email: tanmaymandal112233@email@gmail.com

---

import Foundation
import AVFoundation

protocol AudioRecordingService {
    var isRecording: Bool { get }
    var recordingTime: TimeInterval { get }
    func startRecording()
    func stopRecording() -> (URL, TimeInterval)?
}

class AudioRecorder: NSObject, AudioRecordingService, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    @Published var recordingTime: TimeInterval = 0
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var recordingURL: URL?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func startRecording() {
        let filename = UUID().uuidString + ".m4a"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        recordingURL = url
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            recordingTime = 0
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.recordingTime += 0.1
            }
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    func stopRecording() -> (URL, TimeInterval)? {
        timer?.invalidate()
        timer = nil
        audioRecorder?.stop()
        isRecording = false
        
        guard let url = recordingURL else { return nil }
        let duration = recordingTime
        recordingTime = 0
        
        return (url, duration)
    }
}


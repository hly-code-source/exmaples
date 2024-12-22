import AVFoundation
import ScreenCaptureKit
import CoreMedia
import AudioToolbox

class ScreenRecordingManager: NSObject, SCStreamDelegate {
    
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?
    
    private var outputURL: URL
    
    init(outputURL: URL) {
        self.outputURL = outputURL
        super.init()
        
        setupAssetWriter()
    }
    
    // 设置 AVAssetWriter
    private func setupAssetWriter() {
        do {
            assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mov)
            
            // 设置视频输入
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: 1920,  // 根据实际屏幕分辨率调整
                AVVideoHeightKey: 1080
            ]
            videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            videoInput?.expectsMediaDataInRealTime = true
            
            // 设置音频输入 (如果有音频流)
            let audioSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100,
                AVEncoderBitRateKey: 128000
            ]
            audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
            audioInput?.expectsMediaDataInRealTime = true
            
            // 添加输入
            if assetWriter!.canAdd(videoInput!) {
                assetWriter!.add(videoInput!)
            }
            if assetWriter!.canAdd(audioInput!) {
                assetWriter!.add(audioInput!)
            }
        } catch {
            print("Error setting up asset writer: \(error)")
        }
    }
    
//    // SCStreamDelegate 方法 - 获取视频帧并写入文件
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        if type == .screen {
            // 将视频帧写入文件
            if assetWriter!.status == .unknown {
                assetWriter?.startWriting()
                assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
            }
            
            if assetWriter!.status == .writing && videoInput!.isReadyForMoreMediaData {
                videoInput!.append(sampleBuffer)
            }
        } else if type == .audio {
            // 将音频帧写入文件
            if assetWriter!.status == .writing && audioInput!.isReadyForMoreMediaData {
                audioInput!.append(sampleBuffer)
            }
        }
    }
    
    // 停止录制
    func stopRecording() {
        assetWriter?.finishWriting {
//            if self.assetWriter!.status == .completed {
                print("Recording completed successfully.")
//            } else {
//                print("Recording failed: \(self.assetWriter!.error?.localizedDescription ?? "Unknown error")")
//            }
        }
    }
}

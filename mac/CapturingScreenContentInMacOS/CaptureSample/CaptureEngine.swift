/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 An object that captures a stream of captured sample buffers containing screen and audio content.
 */
import Foundation
import AVFAudio
import ScreenCaptureKit
import OSLog
import Combine
import AVFoundation

/// A structure that contains the video data to render.
struct CapturedFrame: @unchecked Sendable {
    static var invalid: CapturedFrame {
        CapturedFrame(surface: nil, contentRect: .zero, contentScale: 0, scaleFactor: 0)
    }
    
    let surface: IOSurface?
    let contentRect: CGRect
    let contentScale: CGFloat
    let scaleFactor: CGFloat
    var size: CGSize { contentRect.size }
}

/// An object that wraps an instance of `SCStream`, and returns its results as an `AsyncThrowingStream`.
class CaptureEngine: NSObject, @unchecked Sendable {
    
    private let logger = Logger()
    
    private(set) var stream: SCStream?
    private var streamOutput: CaptureEngineStreamOutput?
    private let videoSampleBufferQueue = DispatchQueue(label: "com.example.apple-samplecode.VideoSampleBufferQueue")
    private let audioSampleBufferQueue = DispatchQueue(label: "com.example.apple-samplecode.AudioSampleBufferQueue")
    private let micSampleBufferQueue = DispatchQueue(label: "com.example.apple-samplecode.MicSampleBufferQueue")
    
    
    var display: SCDisplay?
    private var videoWriter: AVAssetWriter?
    private var videoWriterInput: AVAssetWriterInput?
    private var audioWriterInput: AVAssetWriterInput?
    //    private var videoWriterAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    // Performs average and peak power calculations on the audio samples.
    private let powerMeter = PowerMeter()
    var audioLevels: AudioLevels { powerMeter.levels }
    
    // Store the the startCapture continuation, so that you can cancel it when you call stopCapture().
    private var continuation: AsyncThrowingStream<CapturedFrame, Error>.Continuation?
    
    func startCapture(configuration: SCStreamConfiguration, filter: SCContentFilter) -> AsyncThrowingStream<CapturedFrame, Error> {
        AsyncThrowingStream<CapturedFrame, Error> { continuation in
            // The stream output object. Avoid reassigning it to a new object every time startCapture is called.
            let streamOutput = CaptureEngineStreamOutput(continuation: continuation)
            self.streamOutput = streamOutput
            streamOutput.capturedFrameHandler = { continuation.yield($0) }
            streamOutput.pcmBufferHandler = { self.powerMeter.process(buffer: $0) }
            streamOutput.dataSampleHandler = { [self] sampleBuffer, type in
                print("lt -- screen : \(type)")
                if videoWriter!.status == .unknown {
                    videoWriter?.startWriting()
                    videoWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                }
                
                if type == .screen {
                    if videoWriter!.status == .writing && videoWriterInput!.isReadyForMoreMediaData {
                        videoWriterInput!.append(sampleBuffer)
                    }
                }
                
                if type == .audio || type == .microphone {
                    if videoWriter!.status == .writing && audioWriterInput!.isReadyForMoreMediaData {
                        audioWriterInput!.append(sampleBuffer)
                    }
                }
            }
            
            do {
                let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
                let outputURL = desktopURL.appendingPathComponent("ScreenRecording11.mov")
                videoWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mov)
                let videoSettings: [String: Any] = [
                    AVVideoCodecKey: AVVideoCodecType.h264,
                    AVVideoWidthKey: display!.width,
                    AVVideoHeightKey: display!.height
                ]
                videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
                videoWriterInput?.expectsMediaDataInRealTime = true
                
                //                guard let videoWriterInput = videoWriterInput else { return }
                
                //                videoWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                //                    assetWriterInput: videoWriterInput,
                //                    sourcePixelBufferAttributes: [
                //                        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                //                        kCVPixelBufferWidthKey as String: display!.width,
                //                        kCVPixelBufferHeightKey as String: display!.height
                //                    ]
                //                )
                
                // 设置音频输入 (如果有音频流)
                let audioSettings: [String: Any] = [
                    AVFormatIDKey: kAudioFormatMPEG4AAC,
                    AVNumberOfChannelsKey: 2,
                    AVSampleRateKey: 44100,
                    AVEncoderBitRateKey: 128000
                ]
                audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
                audioWriterInput?.expectsMediaDataInRealTime = true
                
                videoWriter!.add(videoWriterInput!)
                videoWriter!.add(audioWriterInput!)
                //                videoWriter!.startWriting()
                //                videoWriter!.startSession(atSourceTime: .zero)
                //
                
                stream = SCStream(filter: filter, configuration: configuration, delegate: streamOutput)
                
                // Add a stream output to capture screen content.
                try stream?.addStreamOutput(streamOutput, type: .screen, sampleHandlerQueue: videoSampleBufferQueue)
                try stream?.addStreamOutput(streamOutput, type: .audio, sampleHandlerQueue: audioSampleBufferQueue)
                try stream?.addStreamOutput(streamOutput, type: .microphone, sampleHandlerQueue: micSampleBufferQueue)
                stream?.startCapture()
            } catch {
                continuation.finish(throwing: error)
            }
        }
    }
    
    func stopCapture() async {
        do {
            try await stream?.stopCapture()
            continuation?.finish()
        } catch {
            continuation?.finish(throwing: error)
        }
        powerMeter.processSilence()
        
        videoWriterInput?.markAsFinished()
        videoWriter?.finishWriting {
            print(
                "Recording finished. File saved at: \(self.videoWriter?.outputURL.path ?? "unknown location")"
            )
        }
    }
    
    func update(configuration: SCStreamConfiguration, filter: SCContentFilter) async {
        do {
            try await stream?.updateConfiguration(configuration)
            try await stream?.updateContentFilter(filter)
        } catch {
            logger.error("Failed to update the stream session: \(String(describing: error))")
        }
    }
    
    func addRecordOutputToStream(_ recordingOutput: SCRecordingOutput) async throws {
        try self.stream?.addRecordingOutput(recordingOutput)
    }
    
    func stopRecordingOutputForStream(_ recordingOutput: SCRecordingOutput) throws {
        try self.stream?.removeRecordingOutput(recordingOutput)
    }
}

/// A class that handles output from an SCStream, and handles stream errors.
private class CaptureEngineStreamOutput: NSObject, SCStreamOutput, SCStreamDelegate {
    
    var pcmBufferHandler: ((AVAudioPCMBuffer) -> Void)?
    var capturedFrameHandler: ((CapturedFrame) -> Void)?
    var dataSampleHandler: ((CMSampleBuffer,SCStreamOutputType) -> Void)?
    
    // Store the  startCapture continuation, so you can cancel it if an error occurs.
    private var continuation: AsyncThrowingStream<CapturedFrame, Error>.Continuation?
    
    init(continuation: AsyncThrowingStream<CapturedFrame, Error>.Continuation?) {
        self.continuation = continuation
    }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of outputType: SCStreamOutputType) {

        // Return early if the sample buffer is invalid.
        guard sampleBuffer.isValid else { return }
        
        // Determine which type of data the sample buffer contains.
        switch outputType {
        case .screen:
            // Create a CapturedFrame structure for a video sample buffer.
            guard let frame = createFrame(for: sampleBuffer) else { return }
            capturedFrameHandler?(frame)
            dataSampleHandler?(sampleBuffer, outputType)

        case .audio:
            // Process audio as an AVAudioPCMBuffer for level calculation.
            handleAudio(for: sampleBuffer)
            dataSampleHandler?(sampleBuffer, outputType)

        case .microphone:
            handleAudio(for: sampleBuffer)
            dataSampleHandler?(sampleBuffer, outputType)

        @unknown default:
            fatalError("Encountered unknown stream output type: \(outputType)")
        }
    }
    
    /// Create a `CapturedFrame` for the video sample buffer.
    private func createFrame(for sampleBuffer: CMSampleBuffer) -> CapturedFrame? {
        
        // Retrieve the array of metadata attachments from the sample buffer.
        guard let attachmentsArray = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer,
                                                                             createIfNecessary: false) as? [[SCStreamFrameInfo: Any]],
              let attachments = attachmentsArray.first else { return nil }
        
        // Validate the status of the frame. If it isn't `.complete`, return nil.
        guard let statusRawValue = attachments[SCStreamFrameInfo.status] as? Int,
              let status = SCFrameStatus(rawValue: statusRawValue),
              status == .complete else { return nil }
        
        // Get the pixel buffer that contains the image data.
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return nil }
        
        // Get the backing IOSurface.
        guard let surfaceRef = CVPixelBufferGetIOSurface(pixelBuffer)?.takeUnretainedValue() else { return nil }
        let surface = unsafeBitCast(surfaceRef, to: IOSurface.self)
        
        // Retrieve the content rectangle, scale, and scale factor.
        guard let contentRectDict = attachments[.contentRect],
              let contentRect = CGRect(dictionaryRepresentation: contentRectDict as! CFDictionary),
              let contentScale = attachments[.contentScale] as? CGFloat,
              let scaleFactor = attachments[.scaleFactor] as? CGFloat else { return nil }
        
        // Create a new frame with the relevant data.
        let frame = CapturedFrame(surface: surface,
                                  contentRect: contentRect,
                                  contentScale: contentScale,
                                  scaleFactor: scaleFactor)
        return frame
    }
    
    private func handleAudio(for buffer: CMSampleBuffer) -> Void? {
        // Create an AVAudioPCMBuffer from an audio sample buffer.
        try? buffer.withAudioBufferList { audioBufferList, blockBuffer in
            guard let description = buffer.formatDescription?.audioStreamBasicDescription,
                  let format = AVAudioFormat(standardFormatWithSampleRate: description.mSampleRate, channels: description.mChannelsPerFrame),
                  let samples = AVAudioPCMBuffer(pcmFormat: format, bufferListNoCopy: audioBufferList.unsafePointer)
            else { return }
            pcmBufferHandler?(samples)
        }
    }
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("lt -- didStopWithError \(stream)")
        continuation?.finish(throwing: error)
    }
    
    func outputVideoEffectDidStart(for stream: SCStream) {
        print("lt -- outputVideoEffectDidStart \(stream)")
    }
    
    func outputVideoEffectDidStop(for stream: SCStream) {
        print("lt -- outputVideoEffectDidStop \(stream)")
    }
}
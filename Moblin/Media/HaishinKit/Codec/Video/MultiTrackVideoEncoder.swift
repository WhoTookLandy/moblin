import VideoToolbox

// periphery:ignore
class MultiTrackVideoEncoder {
    private let encoders: [VideoEncoder]

    init(settings: [VideoEncoderSettings], lockQueue: DispatchQueue) {
        encoders = settings.map { setting in
            let encoder = VideoEncoder(lockQueue: lockQueue)
            encoder.settings.mutate { $0 = setting }
            return encoder
        }
        for encoder in encoders {
            encoder.delegate = self
            encoder.startRunning()
        }
    }

    func encodeImageBuffer(_ imageBuffer: CVImageBuffer, presentationTimeStamp: CMTime, duration: CMTime) {
        for encoder in encoders {
            encoder.encodeImageBuffer(imageBuffer,
                                      presentationTimeStamp: presentationTimeStamp,
                                      duration: duration)
        }
    }
}

// periphery:ignore
extension MultiTrackVideoEncoder: VideoEncoderDelegate {
    func videoEncoderOutputFormat(_ encoder: VideoEncoder, _ formatDescription: CMFormatDescription) {
        logger.info("multi-track-video-encoder: Format for \(encoder) \(formatDescription)")
    }

    func videoEncoderOutputSampleBuffer(_ encoder: VideoEncoder,
                                        _ sampleBuffer: CMSampleBuffer,
                                        _: CMTime)
    {
        logger.info("multi-track-video-encoder: Frame for \(encoder) \(sampleBuffer.presentationTimeStamp)")
    }
}

import Foundation

public class PausableTimer: PausableTimerType {

    public static let sharedInstance: PausableTimer = PausableTimer()

    // MARK: - callback closures

    public var didStart: (() -> Void)?
    public var didPause: (() -> Void)?
    public var didResume: (() -> Void)?
    public var didStop: ((_ isFinished: Bool) -> Void)?

    // MARK: - duration, and related variables

    private var timer: Timer?

    private var startDate: Date?

    private var duration: TimeInterval        = 0
    private var currentDuration: TimeInterval = 0

    // MARK: - setup

    public func set(duration: TimeInterval) {
        self.duration        = duration
        self.currentDuration = duration
    }

    // MARK: - operate

    public func start(at startDate: Date = Date()) {
        registerTimer()

        self.startDate = startDate
        didStart?()
    }

    public func pause(at pauseDate: Date = Date()) {
        if !isRunning(at: pauseDate) {
            return
        }

        self.currentDuration = remainingDuration(at: pauseDate)
        self.startDate       = nil
        self.timer?.invalidate()

        didPause?()
    }

    public func resume(at resumeDate: Date = Date()) {
        if isRunning(at: resumeDate) {
            return
        }
        if remainingDuration(at: resumeDate) == 0 {
            return
        }

        registerTimer()
        self.startDate = resumeDate

        didResume?()
    }

    public func stop() {
        reset()

        didStop?(false)
    }

    // MARK: - Timer

    @objc
    private func didFinishTimerDuration() {
        reset()

        didStop?(true)
    }

    // MARK: -

    public func isRunning(at now: Date = Date()) -> Bool {
        if startDate == nil {
            return false
        }

        return remainingDuration(at: now) > 0
    }

    public func remainingDuration(at now: Date = Date()) -> TimeInterval {
        guard let startDate: Date = startDate else {
            return currentDuration
        }

        let elapsedDuration: TimeInterval   = now.timeIntervalSince(startDate)
        let remainingDuration: TimeInterval = currentDuration - elapsedDuration

        return remainingDuration < 0 ? 0 : remainingDuration
    }

    // MARK: - private

    private func registerTimer() {
        timer = Timer.scheduledTimer(timeInterval: currentDuration,
                                     target: self,
                                     selector: #selector(didFinishTimerDuration),
                                     userInfo: nil,
                                     repeats: false)
    }

    private func reset() {
        self.currentDuration = duration
        self.startDate       = nil
        self.timer?.invalidate()
    }
}

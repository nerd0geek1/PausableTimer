import Foundation

public class PausableTimer: PausableTimerType {

    // MARK: - public properties

    public static let shared: PausableTimer = PausableTimer()

    // MARK: - callback closures

    public var didStart: (() -> Void)?
    public var didPause: (() -> Void)?
    public var didResume: (() -> Void)?
    public var didStop: ((_ isFinished: Bool) -> Void)?

    // MARK: - private properties

    private var timer: Timer?

    private var duration: TimeInterval        = 0
    private var currentDuration: TimeInterval = 0

    // MARK: - public methods
    // MARK: setup

    public func set(duration: TimeInterval) {
        self.duration        = duration
        self.currentDuration = duration
    }

    // MARK: - operate

    public func start(at startDate: Date = Date()) {
        registerTimer(with: startDate)

        didStart?()
    }

    public func pause(at pauseDate: Date = Date()) {
        if !isRunning(at: pauseDate) { return }

        self.currentDuration = remainingDuration(at: pauseDate)
        self.timer?.invalidate()

        didPause?()
    }

    public func resume(at resumeDate: Date = Date()) {
        if isRunning(at: resumeDate) {              return }
        if remainingDuration(at: resumeDate) == 0 { return }

        registerTimer(with: resumeDate)

        didResume?()
    }

    public func stop() {
        reset()

        didStop?(false)
    }

    // MARK: -

    public func isRunning(at now: Date = Date()) -> Bool {
        guard let timer = timer, timer.isValid else { return false }

        return remainingDuration(at: now) > 0
    }

    public func remainingDuration(at now: Date = Date()) -> TimeInterval {
        guard let timer = timer, timer.isValid else {
            return currentDuration
        }

        let elapsedDuration: TimeInterval   = now.timeIntervalSince(timer.fireDate)
        let remainingDuration: TimeInterval = currentDuration - elapsedDuration

        return remainingDuration < 0 ? 0 : remainingDuration
    }

    // MARK: - Timer

    @objc private func didFinishTimerDuration() {
        reset()

        didStop?(true)
    }

    // MARK: - private

    private func registerTimer(with startDate: Date) {
        timer = Timer(fireAt: startDate,
                      interval: currentDuration,
                      target: self,
                      selector: #selector(didFinishTimerDuration),
                      userInfo: nil,
                      repeats: false)
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }

    private func reset() {
        self.currentDuration = duration
        self.timer?.invalidate()
    }
}

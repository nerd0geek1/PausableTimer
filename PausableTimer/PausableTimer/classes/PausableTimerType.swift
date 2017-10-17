import Foundation

public protocol PausableTimerType {
    var didStart: (() -> Void)? { get set }
    var didPause: (() -> Void)? { get set }
    var didResume: (() -> Void)? { get set }
    var didStop: ((_ isFinished: Bool) -> Void)? { get set }

    func set(duration: TimeInterval)

    func start(at startDate: Date)
    func pause(at pauseDate: Date)
    func resume(at resumeDate: Date)
    func stop()

    func isRunning(at now: Date) -> Bool

    func remainingDuration(at now: Date) -> TimeInterval
}

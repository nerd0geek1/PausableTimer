//
//  PausableTimer.swift
//  PausableTimer
//
//  Created by Kohei Tabata on 6/12/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

open class PausableTimer: PausableTimerType {

    open static let sharedInstance: PausableTimer = PausableTimer()

    // MARK: - callback closures

    open var didStart: (() -> Void)?
    open var didPause: (() -> Void)?
    open var didResume: (() -> Void)?
    open var didStop: ((_ isFinished: Bool) -> Void)?

    // MARK: - duration, and related variables

    private var timer: Timer?

    private var startDate: Date?

    private var duration: TimeInterval        = 0
    private var currentDuration: TimeInterval = 0

    // MARK: - setup

    open func set(duration: TimeInterval) {
        self.duration        = duration
        self.currentDuration = duration
    }

    // MARK: - operate

    open func start(at startDate: Date = Date()) {
        registerTimer()

        self.startDate = startDate
        didStart?()
    }

    open func pause(at pauseDate: Date = Date()) {
        if !isRunning(at: pauseDate) {
            return
        }

        self.currentDuration = remainingDuration(at: pauseDate)
        self.startDate       = nil
        self.timer?.invalidate()

        didPause?()
    }

    open func resume(at resumeDate: Date = Date()) {
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

    open func stop() {
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

    open func isRunning(at now: Date = Date()) -> Bool {
        if startDate == nil {
            return false
        }

        return remainingDuration(at: now) > 0
    }

    open func remainingDuration(at now: Date = Date()) -> TimeInterval {
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

//
//  PausableTimer.swift
//  PausableTimer
//
//  Created by Kohei Tabata on 6/12/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

public class PausableTimer: PausableTimerType {

    public static let sharedInstance: PausableTimer = PausableTimer()

    //MARK: - callback closures

    public var didStart: (() -> Void)?
    public var didPause: (() -> Void)?
    public var didResume: (() -> Void)?
    public var didStop: ((isFinished: Bool) -> Void)?

    //MARK: - duration, and related variables

    private var timer: NSTimer?

    private var startDate: NSDate?

    private var duration: NSTimeInterval        = 0
    private var currentDuration: NSTimeInterval = 0

    //MARK: - setup

    public func setDuration(duration: NSTimeInterval) {
        self.duration        = duration
        self.currentDuration = duration
    }

    //MARK: - operate

    public func start(startDate: NSDate = NSDate()) {
        registerTimer()

        self.startDate = startDate
        didStart?()
    }

    public func pause(pauseDate: NSDate = NSDate()) {
        if !isRunning(pauseDate) {
            return
        }

        self.currentDuration = remainingDuration(pauseDate)
        self.startDate       = nil
        self.timer?.invalidate()

        didPause?()
    }

    public func resume(resumeDate: NSDate = NSDate()) {
        if isRunning(resumeDate) {
            return
        }
        if remainingDuration(resumeDate) == 0 {
            return
        }

        registerTimer()
        self.startDate = resumeDate

        didResume?()
    }

    public func stop() {
        reset()

        didStop?(isFinished: false)
    }

    //MARK: - NSTimer

    @objc
    private func didFinishTimerDuration() {
        reset()

        didStop?(isFinished: true)
    }

    //MARK: -

    public func isRunning(now: NSDate = NSDate()) -> Bool {
        if startDate == nil {
            return false
        }

        return remainingDuration(now) > 0
    }

    public func remainingDuration(now: NSDate = NSDate()) -> NSTimeInterval {
        guard let startDate: NSDate = startDate else {
            return currentDuration
        }

        let elapsedDuration: NSTimeInterval   = now.timeIntervalSinceDate(startDate)
        let remainingDuration: NSTimeInterval = currentDuration - elapsedDuration

        return remainingDuration < 0 ? 0 : remainingDuration
    }

    //MARK: - private

    private func registerTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(currentDuration,
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

//
//  PausableTimerType.swift
//  PausableTimer
//
//  Created by Kohei Tabata on 6/11/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation

public protocol PausableTimerType {
    var didStart: (() -> Void)? { get set }
    var didPause: (() -> Void)? { get set }
    var didResume: (() -> Void)? { get set }
    var didStop: ((isFinished: Bool) -> Void)? { get set }

    func setDuration(duration: NSTimeInterval)

    func start(startDate: NSDate)
    func pause(pauseDate: NSDate)
    func resume(resumeDate: NSDate)
    func stop()

    func isRunning(now: NSDate) -> Bool

    func remainingDuration(now: NSDate) -> NSTimeInterval
}

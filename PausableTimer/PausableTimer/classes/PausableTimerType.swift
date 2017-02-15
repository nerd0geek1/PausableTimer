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
    var didStop: ((_ isFinished: Bool) -> Void)? { get set }

    func set(duration: TimeInterval)

    func start(at startDate: Date)
    func pause(at pauseDate: Date)
    func resume(at resumeDate: Date)
    func stop()

    func isRunning(at now: Date) -> Bool

    func remainingDuration(at now: Date) -> TimeInterval
}

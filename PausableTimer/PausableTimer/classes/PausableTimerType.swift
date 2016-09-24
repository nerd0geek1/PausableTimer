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

    func setDuration(_ duration: TimeInterval)

    func start(_ startDate: Date)
    func pause(_ pauseDate: Date)
    func resume(_ resumeDate: Date)
    func stop()

    func isRunning(_ now: Date) -> Bool

    func remainingDuration(_ now: Date) -> TimeInterval
}

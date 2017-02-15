//
//  TimerDurationConverterSpec.swift
//  PausableTimer
//
//  Created by Kohei Tabata on 6/25/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble

@testable import PausableTimer

class TimerDurationConverterSpec: QuickSpec {
    override func spec() {
        describe("durationString(from duration: TimeInterval)", {
            context("with duration which exceeds one hour", {
                it("will return string like format 00:00:00", closure: {
                    let duration: TimeInterval = 3820

                    expect(TimerDurationConverter.durationString(from: duration)).to(equal("01:03:40"))
                })
            })
            context("with duration which does not exceeds one hour", {
                it("will return string like format 00:00", closure: {
                    let duration: TimeInterval = 1815
                    
                    expect(TimerDurationConverter.durationString(from: duration)).to(equal("30:15"))
                })
            })
        })
    }
}

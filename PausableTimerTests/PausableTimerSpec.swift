//
//  PausableTimerSpec.swift
//  PausableTimer
//
//  Created by Kohei Tabata on 6/12/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Quick
import Nimble

@testable import PausableTimer

class PausableTimerSpec: QuickSpec {
    override func spec() {
        describe("PausableTimer") {
            describe("setDuration(duration: NSTimeInterval)", {
                it("will update duration with passed value", closure: {
                    let timer: PausableTimer = PausableTimer()

                    expect(timer.remainingDuration()).to(equal(0))

                    let duration: NSTimeInterval = 300
                    timer.setDuration(duration)

                    expect(timer.remainingDuration()).to(equal(duration))
                })
            })


            describe("isRunning()", {
                context("with start action", {
                    context("and called within duration", {
                        it("will return true", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval = 10
                            let diff: NSTimeInterval     = 5
                            let startDate: NSDate        = NSDate()
                            let now: NSDate              = startDate.dateByAddingTimeInterval(diff)

                            timer.setDuration(duration)
                            timer.start(startDate)

                            expect(timer.isRunning(now)).to(beTrue())
                        })
                    })
                    context("and called after duration", {
                        it("will return false", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval = 5
                            let diff: NSTimeInterval     = 6
                            let startDate: NSDate        = NSDate()
                            let now: NSDate              = startDate.dateByAddingTimeInterval(diff)

                            timer.setDuration(duration)
                            timer.start(startDate)

                            expect(timer.isRunning(now)).to(beFalse())
                        })
                    })
                    context("and pause action", {
                        it("will return false", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval = 10

                            let startDate: NSDate = NSDate()
                            let pauseDate: NSDate = startDate.dateByAddingTimeInterval(5)
                            let now: NSDate       = startDate.dateByAddingTimeInterval(6)

                            timer.setDuration(duration)
                            timer.start(startDate)

                            timer.pause(pauseDate)

                            expect(timer.isRunning(now)).to(beFalse())
                        })
                    })
                    context(", pause action and resume action", {
                        it("will return true", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval = 10

                            let startDate: NSDate  = NSDate()
                            let pauseDate: NSDate  = startDate.dateByAddingTimeInterval(5)

                            let resumeDate: NSDate = startDate.dateByAddingTimeInterval(6)
                            let now: NSDate        = resumeDate.dateByAddingTimeInterval(2)


                            timer.setDuration(duration)
                            timer.start(startDate)

                            timer.pause(pauseDate)

                            timer.resume(resumeDate)
                            
                            expect(timer.isRunning(now)).to(beTrue())
                        })
                    })
                })
                context("without start action", {
                    it("will return false", closure: {
                        let timer: PausableTimer = PausableTimer()

                        timer.setDuration(200)

                        expect(timer.isRunning()).to(beFalse())
                    })
                })
            })


            describe("remainingDuration(now: NSDate)", {
                context("with startDate", {
                    context("and now argument which diff between startDate exceeds duration", {
                        it("will return 0", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval = 10
                            let startDate: NSDate        = NSDate()
                            let now: NSDate              = startDate.dateByAddingTimeInterval(15)

                            timer.setDuration(duration)

                            timer.start(startDate)

                            expect(timer.remainingDuration(now)).to(equal(0))
                        })
                    })
                    context("and now argument which diff between startDate does not exceeds duration", {
                        it("will return (duration - (diff between startDate and now argument))", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval = 10
                            let diff: NSTimeInterval     = 4
                            let startDate: NSDate        = NSDate()
                            let now: NSDate              = startDate.dateByAddingTimeInterval(diff)

                            timer.setDuration(duration)

                            timer.start(startDate)
                            
                            expect(timer.remainingDuration(now)).to(equal(duration - diff))
                        })
                    })
                    context("and pauseDate", {
                        it("will return (duration - (diff between startDate and pauseDate argument))", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval = 10
                            let diff: NSTimeInterval     = 4
                            let startDate: NSDate = NSDate()
                            let pauseDate: NSDate = startDate.dateByAddingTimeInterval(diff)
                            let now: NSDate       = startDate.dateByAddingTimeInterval(9)

                            timer.setDuration(duration)

                            timer.start(startDate)
                            timer.pause(pauseDate)

                            expect(timer.remainingDuration(now)).to(equal(duration - diff))
                        })
                    })
                    context(", pauseDate and resumeDate", {
                        it("will return (duration - (diff between startDate and pauseDate) - (diff between resumeDate and now argument))", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: NSTimeInterval          = 10
                            let diffForPauseDate: NSTimeInterval  = 4
                            let diffForResumeDate: NSTimeInterval = 6
                            let diffForNow: NSTimeInterval        = 2
                            let startDate: NSDate  = NSDate()
                            let pauseDate: NSDate  = startDate.dateByAddingTimeInterval(diffForPauseDate)
                            let resumeDate: NSDate = startDate.dateByAddingTimeInterval(diffForResumeDate)
                            let now: NSDate        = resumeDate.dateByAddingTimeInterval(diffForNow)

                            timer.setDuration(duration)

                            timer.start(startDate)
                            timer.pause(pauseDate)
                            timer.resume(resumeDate)

                            expect(timer.remainingDuration(now)).to(equal(duration - diffForPauseDate - diffForNow))
                        })
                    })
                })
                context("without startDate", {
                    it("will return set duration value", closure: {
                        let timer: PausableTimer = PausableTimer()

                        let duration: NSTimeInterval = 900

                        timer.setDuration(duration)

                        expect(duration).to(equal(duration))
                    })
                })
            })


            describe("formattedRemainingDuration(now: NSDate)", {
                context("with duration which exceeds one hour", {
                    it("will return string like format 00:00:00", closure: {
                        let timer: PausableTimer = PausableTimer()

                        let duration: NSTimeInterval = 3820

                        timer.setDuration(duration)

                        expect(timer.formattedRemainingDuration()).to(equal("01:03:40"))
                    })
                })
                context("with duration which does not exceeds one hour", {
                    it("will return string like format 00:00", closure: {
                        let timer: PausableTimer = PausableTimer()

                        let duration: NSTimeInterval = 1815

                        timer.setDuration(duration)

                        expect(timer.formattedRemainingDuration()).to(equal("30:15"))
                    })
                })
            })


            describe("didStart", {
                it("will be invoked when start() is called", closure: {
                    let timer: PausableTimer = PausableTimer()
                    var didInvoked: Bool = false

                    timer.didStart = {
                        didInvoked = true
                    }

                    timer.start()

                    expect(didInvoked).toEventually(beTrue())
                })
            })
            describe("didPause", {
                context("after start action calling", {
                    it("will be invoked when pause() is called", closure: {
                        let timer: PausableTimer = PausableTimer()
                        let duration: NSTimeInterval = 20
                        let startDate: NSDate        = NSDate()
                        let pauseDate: NSDate        = startDate.dateByAddingTimeInterval(10)
                        var didInvoked: Bool = false

                        timer.setDuration(duration)

                        timer.didPause = {
                            didInvoked = true
                        }

                        timer.start(startDate)
                        timer.pause(pauseDate)

                        expect(didInvoked).toEventually(beTrue())
                    })
                })
                context("under status not calling start action ", {
                    it("will not be invoked when pause() is called", closure: {
                        let timer: PausableTimer = PausableTimer()
                        let duration: NSTimeInterval = 20
                        let pauseDate: NSDate        = NSDate()
                        var didInvoked: Bool = false

                        timer.setDuration(duration)

                        timer.didPause = {
                            didInvoked = true
                        }

                        timer.pause(pauseDate)
                        
                        expect(didInvoked).toEventually(beFalse())
                    })
                })
            })
            describe("didResume", {
                it("will be invoked when resume() is called", closure: {
                    let timer: PausableTimer = PausableTimer()


                    let duration: NSTimeInterval = 20
                    let startDate: NSDate  = NSDate()
                    let pauseDate: NSDate  = startDate.dateByAddingTimeInterval(5)
                    let resumeDate: NSDate = startDate.dateByAddingTimeInterval(10)
                    var didInvoked: Bool = false

                    timer.setDuration(duration)

                    timer.didResume = {
                        didInvoked = true
                    }

                    timer.start(startDate)
                    timer.pause(pauseDate)
                    timer.resume(resumeDate)

                    expect(didInvoked).toEventually(beTrue())
                })
            })
            describe("didStop", {
                context("with stop action", {
                    it("will be invoked with false argument", closure: {
                        let timer: PausableTimer = PausableTimer()
                        let duration: NSTimeInterval = 20
                        let startDate: NSDate = NSDate()
                        var didInvoked: Bool = false
                        var isFinished: Bool = false

                        timer.setDuration(duration)

                        timer.didStop = { finished in
                            didInvoked = true
                            isFinished = finished
                        }

                        timer.start(startDate)
                        timer.stop()

                        expect(didInvoked).toEventually(beTrue())
                        expect(isFinished).toEventually(beFalse())
                    })
                })
                context("with the passage of duration", {
                    it("will be invoked with true argument", closure: {
                        let timer: PausableTimer = PausableTimer()
                        let duration: NSTimeInterval = 1
                        let startDate: NSDate = NSDate()
                        let stopDate: NSDate  = startDate.dateByAddingTimeInterval(1.5)
                        var didInvoked: Bool = false
                        var isFinished: Bool = false

                        timer.setDuration(duration)

                        timer.didStop = { finished in
                            didInvoked = true
                            isFinished = finished
                        }

                        timer.start(startDate)

                        NSRunLoop.currentRunLoop().runUntilDate(stopDate)

                        expect(didInvoked).toEventually(beTrue())
                        expect(isFinished).toEventually(beTrue())
                    })
                })
            })
        }
    }
}

import Quick
import Nimble

@testable import PausableTimer

class PausableTimerSpec: QuickSpec {
    override func spec() {
        describe("PausableTimer") {
            describe("set(duration: TimeInterval)", {
                it("will update remaining duration with passed value", closure: {
                    let timer: PausableTimer = PausableTimer()

                    expect(timer.remainingDuration()).to(equal(0))

                    let duration: TimeInterval = 300
                    timer.set(duration: duration)

                    expect(timer.remainingDuration()).to(equal(duration))
                })
            })


            describe("isRunning(at now: Date)", {
                context("called after start()", {
                    context("and within set duration", {
                        it("will return true", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval = 10
                            let diff: TimeInterval     = 5
                            let startDate: Date        = Date()
                            let now: Date              = startDate.addingTimeInterval(diff)

                            timer.set(duration: duration)
                            timer.start(at: startDate)

                            expect(timer.isRunning(at: now)).to(beTrue())
                        })
                    })
                    context("and beyond set duration", {
                        it("will return false", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval = 5
                            let diff: TimeInterval     = 6
                            let startDate: Date        = Date()
                            let now: Date              = startDate.addingTimeInterval(diff)

                            timer.set(duration: duration)
                            timer.start(at: startDate)

                            expect(timer.isRunning(at: now)).to(beFalse())
                        })
                    })
                    context("and pause()", {
                        it("will return false", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval = 10
                            let startDate: Date        = Date()
                            let pauseDate: Date        = startDate.addingTimeInterval(5)
                            let now: Date              = startDate.addingTimeInterval(6)

                            timer.set(duration: duration)
                            timer.start(at: startDate)

                            timer.pause(at: pauseDate)

                            expect(timer.isRunning(at: now)).to(beFalse())
                        })
                    })
                    context(", pause() and resume()", {
                        it("will return true", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval = 10

                            let startDate: Date  = Date()
                            let pauseDate: Date  = startDate.addingTimeInterval(5)

                            let resumeDate: Date = startDate.addingTimeInterval(6)
                            let now: Date        = resumeDate.addingTimeInterval(2)


                            timer.set(duration: duration)
                            timer.start(at: startDate)

                            timer.pause(at: pauseDate)

                            timer.resume(at: resumeDate)
                            
                            expect(timer.isRunning(at: now)).to(beTrue())
                        })
                    })
                })
                context("called without start()", {
                    it("will return false", closure: {
                        let timer: PausableTimer = PausableTimer()

                        timer.set(duration: 200)

                        expect(timer.isRunning()).to(beFalse())
                    })
                })
            })


            describe("remainingDuration(at now: Date)", {
                context("with startDate", {
                    context("and now argument which diff between startDate exceeds duration", {
                        it("will return 0", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval = 10
                            let startDate: Date        = Date()
                            let now: Date              = startDate.addingTimeInterval(15)

                            timer.set(duration: duration)

                            timer.start(at: startDate)

                            expect(timer.remainingDuration(at: now)).to(equal(0))
                        })
                    })
                    context("and now argument which diff between startDate does not exceeds duration", {
                        it("will return (duration - (diff between startDate and now argument))", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval = 10
                            let diff: TimeInterval     = 4
                            let startDate: Date        = Date()
                            let now: Date              = startDate.addingTimeInterval(diff)

                            timer.set(duration: duration)

                            timer.start(at: startDate)
                            
                            expect(timer.remainingDuration(at: now)).to(equal(duration - diff))
                        })
                    })
                    context("and pauseDate", {
                        it("will return (duration - (diff between startDate and pauseDate argument))", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval = 10
                            let diff: TimeInterval     = 4
                            let startDate: Date = Date()
                            let pauseDate: Date = startDate.addingTimeInterval(diff)
                            let now: Date       = startDate.addingTimeInterval(9)

                            timer.set(duration: duration)

                            timer.start(at: startDate)
                            timer.pause(at: pauseDate)

                            expect(timer.remainingDuration(at: now)).to(equal(duration - diff))
                        })
                    })
                    context(", pauseDate and resumeDate", {
                        it("will return (duration - (diff between startDate and pauseDate) - (diff between resumeDate and now argument))", closure: {
                            let timer: PausableTimer = PausableTimer()

                            let duration: TimeInterval          = 10
                            let diffForPauseDate: TimeInterval  = 4
                            let diffForResumeDate: TimeInterval = 6
                            let diffForNow: TimeInterval        = 2
                            let startDate: Date  = Date()
                            let pauseDate: Date  = startDate.addingTimeInterval(diffForPauseDate)
                            let resumeDate: Date = startDate.addingTimeInterval(diffForResumeDate)
                            let now: Date        = resumeDate.addingTimeInterval(diffForNow)

                            timer.set(duration: duration)

                            print("1-1:\(timer.remainingDuration())")
                            timer.start(at: startDate)
                            print("2-1:\(timer.remainingDuration(at: startDate))")
                            timer.pause(at: pauseDate)
                            print("3-1:\(timer.remainingDuration(at: pauseDate))")
                            timer.resume(at: resumeDate)
                            print("4-1:\(timer.remainingDuration(at: resumeDate))")

                            expect(timer.remainingDuration(at: now)).to(equal(duration - diffForPauseDate - diffForNow))
                        })
                    })
                })
                context("without startDate", {
                    it("will return set duration value", closure: {
                        let timer: PausableTimer = PausableTimer()

                        let duration: TimeInterval = 900

                        timer.set(duration: duration)

                        expect(duration).to(equal(duration))
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
                context("after calling start()", {
                    it("will be invoked when pause() is called", closure: {
                        let timer: PausableTimer = PausableTimer()
                        let duration: TimeInterval = 20
                        let startDate: Date        = Date()
                        let pauseDate: Date        = startDate.addingTimeInterval(10)
                        var didInvoked: Bool = false

                        timer.set(duration: duration)
                        timer.start(at: startDate)

                        timer.didPause = {
                            didInvoked = true
                        }

                        timer.pause(at: pauseDate)

                        expect(didInvoked).toEventually(beTrue())
                    })
                })
                context("in not calling start()", {
                    it("will not be invoked when pause() is called", closure: {
                        let timer: PausableTimer = PausableTimer()
                        let duration: TimeInterval = 20
                        let pauseDate: Date        = Date()
                        var didInvoked: Bool = false

                        timer.set(duration: duration)

                        timer.didPause = {
                            didInvoked = true
                        }

                        timer.pause(at: pauseDate)
                        
                        expect(didInvoked).toEventually(beFalse())
                    })
                })
            })
            describe("didResume", {
                it("will be invoked when resume() is called", closure: {
                    let timer: PausableTimer = PausableTimer()

                    let duration: TimeInterval = 20
                    let startDate: Date  = Date()
                    let pauseDate: Date  = startDate.addingTimeInterval(5)
                    let resumeDate: Date = startDate.addingTimeInterval(10)
                    var didInvoked: Bool = false

                    timer.set(duration: duration)
                    timer.start(at: startDate)
                    timer.pause(at: pauseDate)

                    timer.didResume = {
                        didInvoked = true
                    }

                    timer.resume(at: resumeDate)

                    expect(didInvoked).toEventually(beTrue())
                })
            })
            describe("didStop", {
                context("with stop()", {
                    it("will be invoked with false argument", closure: {
                        let timer: PausableTimer = PausableTimer()

                        let duration: TimeInterval = 20
                        let startDate: Date        = Date()
                        var didInvoked: Bool = false
                        var isFinished: Bool = false

                        timer.set(duration: duration)
                        timer.start(at: startDate)

                        timer.didStop = { finished in
                            didInvoked = true
                            isFinished = finished
                        }

                        timer.stop()

                        expect(didInvoked).toEventually(beTrue())
                        expect(isFinished).toEventually(beFalse())
                    })
                })
                context("with the passage of duration", {
                    it("will be invoked with true argument", closure: {
                        let timer: PausableTimer = PausableTimer()

                        let duration: TimeInterval = 1
                        let startDate: Date        = Date()
                        let stopDate: Date         = startDate.addingTimeInterval(1.5)
                        var didInvoked: Bool = false
                        var isFinished: Bool = false

                        timer.set(duration: duration)

                        timer.didStop = { finished in
                            didInvoked = true
                            isFinished = finished
                        }

                        timer.start(at: startDate)

                        RunLoop.current.run(until: stopDate as Date)

                        expect(didInvoked).toEventually(beTrue())
                        expect(isFinished).toEventually(beTrue())
                    })
                })
            })
        }
    }
}

import Foundation

final public class TimerDurationConverter {
    public class func durationString(from duration: TimeInterval) -> String {
        let durationInt: Int      = Int(duration)
        let secondsPerHour: Int   = 3600
        let secondsPerMinute: Int = 60

        let hours: Int   = durationInt / secondsPerHour
        let minutes: Int = (durationInt % secondsPerHour) / secondsPerMinute
        let seconds: Int = durationInt % secondsPerMinute

        let hoursString: String   = hours == 0 ? "" : String(format: "%02d:", hours)
        let defaultString: String = String(format: "%02d:%02d", minutes, seconds)

        return hoursString + defaultString
    }
}

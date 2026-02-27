import Foundation

extension Double {
    /// Clamps the value to the given closed range.
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

import SwiftUI

extension Color {
    // MARK: - Stat Bar Tints

    /// Warm coral-red for hunger
    static let hungerTint = Color(red: 0.95, green: 0.35, blue: 0.35)
    /// Warm amber-gold for happiness
    static let happinessTint = Color(red: 1.0, green: 0.75, blue: 0.20)
    /// Vivid sky-blue for energy
    static let energyTint = Color(red: 0.30, green: 0.65, blue: 1.0)

    // MARK: - Mood Tints (used for glass tinting and accents)

    /// Vibrant spring green
    static let moodHappy = Color(red: 0.30, green: 0.85, blue: 0.45)
    /// Warm tangerine
    static let moodSad = Color(red: 1.0, green: 0.60, blue: 0.25)
    /// Soft lavender
    static let moodTired = Color(red: 0.65, green: 0.50, blue: 0.95)
    /// Deep periwinkle
    static let moodSleeping = Color(red: 0.45, green: 0.45, blue: 0.90)
    /// Rose red
    static let moodGameOver = Color(red: 0.95, green: 0.25, blue: 0.35)

    // MARK: - Action Button Tints

    /// Coral for feed
    static let actionFeed = Color(red: 0.95, green: 0.40, blue: 0.40)
    /// Vivid violet for play
    static let actionPlay = Color(red: 0.60, green: 0.35, blue: 0.95)
    /// Deep indigo for sleep
    static let actionSleep = Color(red: 0.35, green: 0.35, blue: 0.85)
    /// Warm sunrise orange for wake
    static let actionWake = Color(red: 1.0, green: 0.65, blue: 0.20)

    // MARK: - Stat Bar Gradient Endpoints

    /// Healthy green for good stat values
    static let statGood = Color(red: 0.25, green: 0.85, blue: 0.55)
    /// Warning amber for medium stat values
    static let statWarning = Color(red: 1.0, green: 0.80, blue: 0.25)
    /// Critical rose for low stat values
    static let statCritical = Color(red: 0.95, green: 0.30, blue: 0.35)

    // MARK: - Background Gradients

    /// Soft warm top gradient stop (light)
    static let bgGradientTopLight = Color(red: 0.97, green: 0.95, blue: 1.0)
    /// Soft cool bottom gradient stop (light)
    static let bgGradientBottomLight = Color(red: 0.92, green: 0.96, blue: 1.0)
    /// Deep navy top (dark)
    static let bgGradientTopDark = Color(red: 0.08, green: 0.06, blue: 0.14)
    /// Deep charcoal bottom (dark)
    static let bgGradientBottomDark = Color(red: 0.05, green: 0.08, blue: 0.12)
}

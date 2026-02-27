import Foundation

// MARK: - Mood

/// The pet's emotional/lifecycle state derived from its stats.
enum Mood: String, Codable, Sendable, CaseIterable {
    case happy
    case sad
    case tired
    case sleeping
    case gameOver

    /// Localized display name.
    var label: String {
        String(localized: String.LocalizationValue(localizationKey))
    }

    /// The emoji representing this mood.
    var emoji: String {
        switch self {
        case .happy:    return "🐥"
        case .sad:      return "🐣"
        case .tired:    return "🥚"
        case .sleeping: return "😴"
        case .gameOver: return "💀"
        }
    }

    /// SF Symbol name for the mood.
    var sfSymbol: String {
        switch self {
        case .happy:    return "sun.max.fill"
        case .sad:      return "cloud.rain.fill"
        case .tired:    return "moon.zzz.fill"
        case .sleeping: return "bed.double.fill"
        case .gameOver: return "xmark.circle.fill"
        }
    }

    /// Localization key for this mood.
    private var localizationKey: String {
        switch self {
        case .happy:    return "mood.happy"
        case .sad:      return "mood.sad"
        case .tired:    return "mood.tired"
        case .sleeping: return "mood.sleeping"
        case .gameOver: return "mood.gameOver"
        }
    }
}

// MARK: - Pet

/// The core data model for the virtual pet.
struct Pet: Codable, Sendable {
    /// Hunger level (0 = full, 100 = starving).
    var hunger: Double = 0

    /// Happiness level (0 = miserable, 100 = ecstatic).
    var happiness: Double = 100

    /// Energy level (0 = exhausted, 100 = fully rested).
    var energy: Double = 100

    /// Whether the pet is currently sleeping.
    var isSleeping: Bool = false

    // MARK: - Computed

    var mood: Mood {
        if isSleeping { return .sleeping }
        if hunger >= 100 && happiness <= 0 && energy <= 0 { return .gameOver }
        if energy < 20 { return .tired }
        if happiness < 30 || hunger > 80 { return .sad }
        return .happy
    }

    var isGameOver: Bool { mood == .gameOver }

    // MARK: - Stat Decay

    mutating func applyDecay() {
        guard !isSleeping && !isGameOver else { return }
        hunger = (hunger + 2).clamped(to: 0...100)
        happiness = (happiness - 1.5).clamped(to: 0...100)
        energy = (energy - 1).clamped(to: 0...100)
    }

    mutating func applyDecay(ticks: Int) {
        for _ in 0..<ticks { applyDecay() }
    }

    // MARK: - Actions

    mutating func feed() {
        guard !isSleeping && !isGameOver else { return }
        hunger = (hunger - 20).clamped(to: 0...100)
    }

    mutating func play() {
        guard !isSleeping && !isGameOver else { return }
        happiness = (happiness + 15).clamped(to: 0...100)
        energy = (energy - 10).clamped(to: 0...100)
    }

    mutating func sleepTick() {
        guard isSleeping else { return }
        energy = (energy + 5).clamped(to: 0...100)
    }
}

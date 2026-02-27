import Foundation
import SwiftUI

/// The main ViewModel managing the pet's state, game loop timer, and background persistence.
@Observable
@MainActor
final class PetViewModel {

    // MARK: - Properties

    /// The pet instance.
    var pet = Pet()

    /// Timer for the game loop.
    private var gameTimer: Timer?

    /// Timer for sleep restoration.
    private var sleepTimer: Timer?

    /// The interval (in seconds) between each decay tick.
    let tickInterval: TimeInterval = 3.0

    // MARK: - UserDefaults Keys

    private enum StorageKey {
        static let petData = "com.nativeTamo.petData"
        static let lastActiveTimestamp = "com.nativeTamo.lastActiveTimestamp"
    }

    // MARK: - Initialization

    init() {
        loadState()
        startGameLoop()
    }

    // MARK: - Game Loop

    /// Starts the repeating game loop timer that applies stat decay.
    func startGameLoop() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    /// Stops the game loop.
    func stopGameLoop() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    /// One tick of the game loop.
    private func tick() {
        guard !pet.isGameOver else {
            stopGameLoop()
            return
        }
        pet.applyDecay()
    }

    // MARK: - User Actions

    /// Feed the pet.
    func feed() {
        guard !pet.isSleeping && !pet.isGameOver else { return }
        pet.feed()
    }

    /// Play with the pet.
    func play() {
        guard !pet.isSleeping && !pet.isGameOver else { return }
        pet.play()
    }

    /// Put the pet to sleep.
    func sleep() {
        guard !pet.isSleeping && !pet.isGameOver else { return }
        pet.isSleeping = true
        stopGameLoop()
        startSleepTimer()
    }

    /// Wake the pet up.
    func wake() {
        guard pet.isSleeping else { return }
        pet.isSleeping = false
        stopSleepTimer()
        startGameLoop()
    }

    // MARK: - Sleep Timer

    private func startSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.pet.sleepTick()
                // Auto-wake when fully rested
                if self.pet.energy >= 100 {
                    self.wake()
                }
            }
        }
    }

    private func stopSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = nil
    }

    // MARK: - Reset

    /// Resets the pet to a fresh state.
    func resetPet() {
        stopGameLoop()
        stopSleepTimer()
        pet = Pet()
        startGameLoop()
    }

    // MARK: - Background Persistence

    /// Saves the current pet state and timestamp to UserDefaults.
    func saveState() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(pet) {
            UserDefaults.standard.set(data, forKey: StorageKey.petData)
        }
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: StorageKey.lastActiveTimestamp)
    }

    /// Loads pet state from UserDefaults and applies retroactive decay.
    func loadState() {
        let decoder = JSONDecoder()

        // Load saved pet
        if let data = UserDefaults.standard.data(forKey: StorageKey.petData),
           let savedPet = try? decoder.decode(Pet.self, from: data) {
            pet = savedPet
        }

        // Calculate elapsed time and apply retroactive decay
        let lastTimestamp = UserDefaults.standard.double(forKey: StorageKey.lastActiveTimestamp)
        guard lastTimestamp > 0 else { return }

        let elapsed = Date().timeIntervalSince1970 - lastTimestamp
        let missedTicks = Int(elapsed / tickInterval)

        if missedTicks > 0 {
            if pet.isSleeping {
                // Apply sleep restoration ticks
                for _ in 0..<missedTicks {
                    pet.sleepTick()
                }
                // Auto-wake if fully rested
                if pet.energy >= 100 {
                    pet.isSleeping = false
                }
            } else {
                pet.applyDecay(ticks: missedTicks)
            }
        }

        // Re-establish sleep timer if still sleeping
        if pet.isSleeping {
            stopGameLoop()
            startSleepTimer()
        }
    }

    /// Called when the app enters the foreground.
    func onBecomeActive() {
        loadState()
        if !pet.isSleeping && !pet.isGameOver {
            startGameLoop()
        }
    }

    /// Called when the app enters the background.
    func onResignActive() {
        saveState()
        stopGameLoop()
        stopSleepTimer()
    }
}

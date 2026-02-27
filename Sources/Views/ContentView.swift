import SwiftUI

/// The main view — fully redesigned for iOS 26 Liquid Glass.
struct ContentView: View {
    @State private var viewModel = PetViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Pet Display
                        petSection
                            .padding(.top, 8)

                        // Stats
                        statsSection

                        // Action Buttons
                        actionSection

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle(String(localized: "app.title"))
            .toolbar {
                if viewModel.pet.isGameOver {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            viewModel.resetPet()
                        } label: {
                            Label(
                                String(localized: "action.restart"),
                                systemImage: "arrow.counterclockwise"
                            )
                        }
                        .tint(.statCritical)
                    }
                }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                viewModel.onBecomeActive()
            case .background, .inactive:
                viewModel.onResignActive()
            @unknown default:
                break
            }
        }
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [.bgGradientTopDark, .bgGradientBottomDark]
                : [.bgGradientTopLight, .bgGradientBottomLight],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Pet Section

    private var petSection: some View {
        VStack(spacing: 20) {
            ZStack {
                // Ambient mood glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [moodColor.opacity(0.18), moodColor.opacity(0.0)],
                            center: .center,
                            startRadius: 40,
                            endRadius: 140
                        )
                    )
                    .frame(width: 260, height: 260)

                // Pet in a glass circle
                PixelPetView(mood: viewModel.pet.mood, pixelSize: 8)
                    .padding(36)
                    .glassEffect(.regular.interactive().tint(moodColor.opacity(0.08)), in: .circle)
                    .shadow(color: moodColor.opacity(0.15), radius: 20, y: 8)
            }
            .animation(.spring(duration: 0.6, bounce: 0.25), value: viewModel.pet.mood)

            // Mood status pill
            HStack(spacing: 8) {
                Image(systemName: viewModel.pet.mood.sfSymbol)
                    .foregroundStyle(moodColor)
                    .imageScale(.small)
                    .symbolEffect(.pulse, options: .repeating, value: viewModel.pet.mood == .sleeping)

                Text(statusMessage)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .glassEffect(.regular.tint(moodColor.opacity(0.05)), in: .capsule)
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        VStack(spacing: 10) {
            StatBarView(
                label: String(localized: "stat.hunger"),
                icon: "fork.knife",
                value: viewModel.pet.hunger,
                tintColor: .hungerTint,
                invertedColor: true
            )

            StatBarView(
                label: String(localized: "stat.happiness"),
                icon: "heart.fill",
                value: viewModel.pet.happiness,
                tintColor: .happinessTint,
                invertedColor: false
            )

            StatBarView(
                label: String(localized: "stat.energy"),
                icon: "bolt.fill",
                value: viewModel.pet.energy,
                tintColor: .energyTint,
                invertedColor: false
            )
        }
        .padding(14)
        .glassEffect(.regular.tint(Color.primary.opacity(0.02)), in: .rect(cornerRadius: 20))
    }

    // MARK: - Action Section

    private var actionSection: some View {
        HStack(spacing: 0) {
            if viewModel.pet.isSleeping {
                actionButton(
                    title: String(localized: "action.wake"),
                    icon: "sunrise.fill",
                    color: .actionWake
                ) {
                    viewModel.wake()
                }
            } else {
                actionButton(
                    title: String(localized: "action.feed"),
                    icon: "fork.knife",
                    color: .actionFeed
                ) {
                    viewModel.feed()
                }
                .disabled(viewModel.pet.isGameOver)

                actionButton(
                    title: String(localized: "action.play"),
                    icon: "gamecontroller.fill",
                    color: .actionPlay
                ) {
                    viewModel.play()
                }
                .disabled(viewModel.pet.isGameOver)

                actionButton(
                    title: String(localized: "action.sleep"),
                    icon: "bed.double.fill",
                    color: .actionSleep
                ) {
                    viewModel.sleep()
                }
                .disabled(viewModel.pet.isGameOver)
            }
        }
        .padding(8)
        .glassEffect(.regular.tint(Color.primary.opacity(0.02)), in: .capsule)
        .animation(.spring(duration: 0.5, bounce: 0.3), value: viewModel.pet.isSleeping)
    }

    private func actionButton(
        title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(color)

                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .glassEffect(.regular.interactive().tint(color.opacity(0.08)), in: .rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private var moodColor: Color {
        switch viewModel.pet.mood {
        case .happy:    return .moodHappy
        case .sad:      return .moodSad
        case .tired:    return .moodTired
        case .sleeping: return .moodSleeping
        case .gameOver: return .moodGameOver
        }
    }

    private var statusMessage: String {
        switch viewModel.pet.mood {
        case .happy:    return String(localized: "status.happy")
        case .sad:      return String(localized: "status.sad")
        case .tired:    return String(localized: "status.tired")
        case .sleeping:
            let pct = Int(viewModel.pet.energy)
            return String(localized: "status.sleeping\(pct)")
        case .gameOver: return String(localized: "status.gameOver")
        }
    }
}

#Preview {
    GlassEffectContainer {
        ContentView()
    }
}

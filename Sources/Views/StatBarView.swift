import SwiftUI

/// A stat bar with glass-tinted background and concentric corner radii — iOS 26 Liquid Glass style.
struct StatBarView: View {
    let label: String
    let icon: String
    let value: Double
    let tintColor: Color
    var invertedColor: Bool = false

    private var normalizedValue: Double {
        (value / 100.0).clamped(to: 0...1)
    }

    /// Color shifts from green (good) → amber (warning) → rose (critical).
    private var barColor: Color {
        let effective = invertedColor ? (100.0 - value) : value
        if effective > 60 { return .statGood }
        if effective > 30 { return .statWarning }
        return .statCritical
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(label, systemImage: icon)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(tintColor)

                Spacer()

                Text("\(Int(value))")
                    .font(.subheadline.weight(.bold).monospacedDigit())
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.quaternary)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [barColor, barColor.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(4, geo.size.width * normalizedValue))
                        .shadow(color: barColor.opacity(0.3), radius: 4, y: 1)
                }
            }
            .frame(height: 10)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .glassEffect(.regular.tint(tintColor.opacity(0.06)), in: .rect(cornerRadius: 14))
        .animation(.spring(duration: 0.5, bounce: 0.2), value: value)
    }
}

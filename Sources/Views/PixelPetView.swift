import SwiftUI

/// A code-drawn pixel art Tamagotchi pet — vibrant palette that adapts to light/dark mode.
struct PixelPetView: View {
    let mood: Mood
    let pixelSize: CGFloat

    @Environment(\.colorScheme) private var colorScheme

    init(mood: Mood, pixelSize: CGFloat = 6) {
        self.mood = mood
        self.pixelSize = pixelSize
    }

    var body: some View {
        Canvas { context, size in
            let grid = pixelGrid(for: mood)
            let gridWidth = grid[0].count
            let gridHeight = grid.count
            let totalWidth = CGFloat(gridWidth) * pixelSize
            let totalHeight = CGFloat(gridHeight) * pixelSize
            let offsetX = (size.width - totalWidth) / 2
            let offsetY = (size.height - totalHeight) / 2

            for (row, rowData) in grid.enumerated() {
                for (col, colorKey) in rowData.enumerated() {
                    guard let color = pixelColor(for: colorKey) else { continue }
                    let rect = CGRect(
                        x: offsetX + CGFloat(col) * pixelSize,
                        y: offsetY + CGFloat(row) * pixelSize,
                        width: pixelSize,
                        height: pixelSize
                    )
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
        .frame(width: 16 * pixelSize, height: 16 * pixelSize)
        .contentTransition(.opacity)
        .animation(.spring(duration: 0.5, bounce: 0.2), value: mood)
    }

    // MARK: - Pixel Palette (richer, more saturated)

    private func pixelColor(for key: Character) -> Color? {
        let isDark = colorScheme == .dark
        switch key {
        case "O": return isDark ? Color(white: 0.18) : Color(white: 0.18)  // Outline
        case "W": return .white
        case "E": return isDark ? Color(white: 0.08) : Color(white: 0.10)  // Eye

        // Happy — warm golden-yellow
        case "Y": return Color(red: 1.0, green: 0.82, blue: 0.20)
        case "D": return Color(red: 0.92, green: 0.68, blue: 0.12)
        case "B": return Color(red: 1.0, green: 0.50, blue: 0.12)
        case "P": return Color(red: 1.0, green: 0.40, blue: 0.50)

        // Sad — cool slate-blue
        case "S": return Color(red: 0.65, green: 0.72, blue: 0.88)
        case "T": return Color(red: 0.45, green: 0.55, blue: 0.78)
        case "L": return Color(red: 0.35, green: 0.65, blue: 1.0)

        // Tired — warm khaki
        case "G": return Color(red: 0.88, green: 0.82, blue: 0.55)
        case "H": return Color(red: 0.72, green: 0.65, blue: 0.40)

        // Sleeping — soft periwinkle
        case "V": return Color(red: 0.60, green: 0.65, blue: 0.88)
        case "U": return Color(red: 0.45, green: 0.50, blue: 0.72)
        case "Z": return Color(red: 0.55, green: 0.75, blue: 1.0)

        // Game Over — muted gray
        case "X": return Color(white: isDark ? 0.50 : 0.45)
        case "Q": return Color(white: isDark ? 0.35 : 0.30)
        case "A": return Color(red: 0.78, green: 0.78, blue: 0.92)

        case ".": return nil
        default:  return nil
        }
    }

    // MARK: - Pixel Grids (16x16)

    private func pixelGrid(for mood: Mood) -> [[Character]] {
        switch mood {
        case .happy:    return happyGrid
        case .sad:      return sadGrid
        case .tired:    return tiredGrid
        case .sleeping: return sleepingGrid
        case .gameOver: return gameOverGrid
        }
    }

    private var happyGrid: [[Character]] {
        [
            Array("......OOOO......"),
            Array("....OOYYYOOO...."),
            Array("...OYYYYYYYYO..."),
            Array("..OYYYYYYYYYYO.."),
            Array("..OYYYEYYYEYYO.."),
            Array(".OYYYYEYYYEYYYY."),
            Array("OYYYYYYYYYYYYYY."),
            Array("OYYYPYYYYYYPYYO."),
            Array("OYYYYYYYYYYYYYO."),
            Array(".OYYYYYYYYYYYO.."),
            Array(".OYYYYBBBYYYOO.."),
            Array("..OYYYBBBYYYO..."),
            Array("..OOYYYYYYOO...."),
            Array("...OOODDOOO....."),
            Array("....ODDDDO......"),
            Array("....OOOOOO......"),
        ]
    }

    private var sadGrid: [[Character]] {
        [
            Array("......OOOO......"),
            Array("....OOSSSOOO...."),
            Array("...OSSSSSSSSO..."),
            Array("..OSSSSSSSSSSOL."),
            Array("..OSSSESSSESSON"),
            Array("..OSSSEOSSEOSOL."),
            Array("..OSSSSSSSSSSO.."),
            Array("...OSSSSSSSSSO.."),
            Array("...OSSSSSSSSO..."),
            Array("...OSSSOOOSSO..."),
            Array("...OSSSBBSSSO..."),
            Array("....OSSBBSSO...."),
            Array("....OOSSSOO....."),
            Array(".....OOTTOO....."),
            Array(".....OTTTTO....."),
            Array(".....OOOOOO....."),
        ]
    }

    private var tiredGrid: [[Character]] {
        [
            Array("......OOOO......"),
            Array("....OOGGGOOO...."),
            Array("...OGGGGGGGGO..."),
            Array("..OGGGGGGGGGGO.."),
            Array("..OGOOEOOOEOGO.."),
            Array("..OGGOEOOGEOGG.."),
            Array("..OGGGGGGGGGGOO."),
            Array("..OGGGGGGGGGGO.."),
            Array("...OGGGGGGGGGO.."),
            Array("...OGGGGGGGGO..."),
            Array("...OGGGBOGGGO..."),
            Array("....OGGBBGGO...."),
            Array("....OOGGGGOO...."),
            Array(".....OOHHOO....."),
            Array(".....OHHHHO....."),
            Array(".....OOOOOO....."),
        ]
    }

    private var sleepingGrid: [[Character]] {
        [
            Array("..........ZZ.Z.."),
            Array("......OOOOZZ...."),
            Array("....OOVVVOOO...."),
            Array("...OVVVVVVVVO..."),
            Array("..OVVVVVVVVVVO.."),
            Array("..OVEEOOVEEVVO.."),
            Array("..OVVVVVVVVVVO.."),
            Array("..OVVVVVVVVVVO.."),
            Array("...OVVVVVVVVO..."),
            Array("...OVVVVVVVVO..."),
            Array("...OVVVVVVVVO..."),
            Array("....OVVVVVVO...."),
            Array("....OOVVVVOO...."),
            Array(".....OOUUOO....."),
            Array(".....OUUUUO....."),
            Array(".....OOOOOO....."),
        ]
    }

    private var gameOverGrid: [[Character]] {
        [
            Array("......AAAA......"),
            Array("....AAAAAAAA...."),
            Array("....AAAAAAAA...."),
            Array("......AAAA......"),
            Array("......OOOO......"),
            Array("....OOXXXOOO...."),
            Array("...OXXXXXXXXO..."),
            Array("..OXXXEOXEOXXO.."),
            Array("..OXEXEOXEXOXO.."),
            Array("..OXXXEOXEOXXO.."),
            Array("..OXXXXOOXXXXO.."),
            Array("...OXXOXXOXXO..."),
            Array("...OXXXXXXXXO..."),
            Array("....OOQQQQOO...."),
            Array(".....OQQQHO....."),
            Array(".....OOOOOO....."),
        ]
    }
}

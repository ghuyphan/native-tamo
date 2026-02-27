import SwiftUI

/// The app entry point — wraps content in a GlassEffectContainer for coordinated glass morphing.
@main
struct NativeTamoApp: App {
    var body: some Scene {
        WindowGroup {
            GlassEffectContainer {
                ContentView()
            }
        }
    }
}

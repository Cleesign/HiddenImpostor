import SwiftUI

@main
struct HiddenImpostorApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
                .ignoresSafeArea()
                .background(Color("LaunchBackground").ignoresSafeArea())
                .preferredColorScheme(.dark)
        }
    }
}

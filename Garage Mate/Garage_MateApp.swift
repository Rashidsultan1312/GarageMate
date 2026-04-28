
import SwiftUI
import UIKit

@main
struct Garage_MateApp: App {
    init() {
        configureTabBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.06, green: 0.07, blue: 0.12, alpha: 0.95)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.35)

        let normal = appearance.stackedLayoutAppearance.normal
        normal.iconColor = UIColor.white.withAlphaComponent(0.75)
        normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.75)]

        let selected = appearance.stackedLayoutAppearance.selected
        selected.iconColor = UIColor(red: 0.96, green: 0.43, blue: 0.16, alpha: 1.0)
        selected.titleTextAttributes = [.foregroundColor: UIColor(red: 0.96, green: 0.43, blue: 0.16, alpha: 1.0)]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.75)

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

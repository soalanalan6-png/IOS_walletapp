import SwiftUI

struct ContentView: View {
    @StateObject private var accountVM = AccountViewModel()
    @StateObject private var liabilityVM = LiabilityViewModel()
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 8/255, green: 10/255, blue: 20/255, alpha: 1)
        appearance.shadowColor = .clear
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("总览", systemImage: "house.fill")
                }
                .tag(0)
            
            AccountListView()
                .tabItem {
                    Label("账户", systemImage: "creditcard.fill")
                }
                .tag(1)
            
            LiabilityListView()
                .tabItem {
                    Label("负债", systemImage: "arrow.down.forward")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(Color(red: 0.3, green: 0.6, blue: 1.0))
        .environmentObject(accountVM)
        .environmentObject(liabilityVM)
    }
}

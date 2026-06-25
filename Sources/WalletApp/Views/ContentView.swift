import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var accountVM: AccountViewModel
    @EnvironmentObject private var liabilityVM: LiabilityViewModel
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("总览", systemImage: "house.fill")
                }
            
            AccountListView()
                .tabItem {
                    Label("账户", systemImage: "creditcard.fill")
                }
            
            LiabilityListView()
                .tabItem {
                    Label("负债", systemImage: "arrow.down.forward")
                }
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
        }
        .tint(.blue)
    }
}

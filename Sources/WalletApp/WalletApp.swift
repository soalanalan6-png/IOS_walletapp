import SwiftUI

@main
struct WalletApp: App {
    @StateObject private var accountVM = AccountViewModel()
    @StateObject private var liabilityVM = LiabilityViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(accountVM)
                .environmentObject(liabilityVM)
        }
    }
}

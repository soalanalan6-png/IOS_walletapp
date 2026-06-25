import Foundation
import SwiftUI

class AccountViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    private let saveKey = "saved_accounts"
    
    var totalBalance: Double {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    init() { load() }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        save()
    }
    
    func updateAccount(_ account: Account) {
        if let idx = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[idx] = account
            save()
        }
    }
    
    func deleteAccount(_ account: Account) {
        accounts.removeAll { $0.id == account.id }
        save()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Account].self, from: data) {
            accounts = decoded
        }
    }
}

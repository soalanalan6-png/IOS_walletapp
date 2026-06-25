import Foundation
import SwiftUI

class LiabilityViewModel: ObservableObject {
    @Published var liabilities: [Liability] = []
    private let saveKey = "saved_liabilities"
    
    var totalLiability: Double {
        liabilities.filter { !$0.isPaid }.reduce(0) { $0 + $1.amount }
    }
    
    init() { load() }
    
    func addLiability(_ liability: Liability) {
        liabilities.append(liability)
        save()
    }
    
    func togglePaid(_ liability: Liability) {
        if let idx = liabilities.firstIndex(where: { $0.id == liability.id }) {
            liabilities[idx].isPaid.toggle()
            save()
        }
    }
    
    func deleteLiability(_ liability: Liability) {
        liabilities.removeAll { $0.id == liability.id }
        save()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(liabilities) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Liability].self, from: data) {
            liabilities = decoded
        }
    }
}

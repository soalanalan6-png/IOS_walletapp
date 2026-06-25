import Foundation

struct Liability: Identifiable, Codable {
    var id = UUID()
    var name: String
    var amount: Double
    var currency: Currency
    var dueDate: Date?
    var creditor: String = ""
    var notes: String = ""
    var isPaid: Bool = false
    var createdAt = Date()
    
    var formattedAmount: String {
        String(format: "\(currency.symbol)%.2f", amount)
    }
}

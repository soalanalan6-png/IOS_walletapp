import Foundation

enum AccountType: String, Codable, CaseIterable, Identifiable {
    case bankCard = "银行卡"
    case creditCard = "信用卡"
    case cryptoWallet = "加密钱包"
    case cash = "现金"
    case other = "其他"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .bankCard: return "creditcard.fill"
        case .creditCard: return "creditcard"
        case .cryptoWallet: return "bitcoinsign.circle.fill"
        case .cash: return "dollarsign.circle.fill"
        case .other: return "wallet.pass.fill"
        }
    }
}

struct Account: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: AccountType
    var balance: Double
    var currency: Currency
    var cardNumber: String = ""
    var cardholderName: String = ""
    var bankName: String = ""
    var mnemonic: String = ""
    var walletAddress: String = ""
    var notes: String = ""
    var createdAt = Date()
    
    var formattedBalance: String {
        String(format: "\(currency.symbol)%.2f", balance)
    }
}

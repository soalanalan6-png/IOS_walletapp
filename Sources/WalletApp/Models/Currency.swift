import Foundation

enum Currency: String, Codable, CaseIterable, Identifiable {
    case usd = "USD"
    case cny = "CNY"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case hkd = "HKD"
    case krw = "KRW"
    case sgd = "SGD"
    case aud = "AUD"
    case cad = "CAD"
    case btc = "BTC"
    case eth = "ETH"
    case usdt = "USDT"
    case sol = "SOL"
    
    var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .cny: return "¥"
        case .eur: return "€"
        case .gbp: return "£"
        case .jpy: return "¥"
        case .hkd: return "HK$"
        case .krw: return "₩"
        case .sgd: return "S$"
        case .aud: return "A$"
        case .cad: return "C$"
        case .btc: return "₿"
        case .eth: return "♦"
        case .usdt: return "₮"
        case .sol: return "◎"
        }
    }
    
    var flag: String {
        switch self {
        case .usd: return "🇺🇸"
        case .cny: return "🇨🇳"
        case .eur: return "🇪🇺"
        case .gbp: return "🇬🇧"
        case .jpy: return "🇯🇵"
        case .hkd: return "🇭🇰"
        case .krw: return "🇰🇷"
        case .sgd: return "🇸🇬"
        case .aud: return "🇦🇺"
        case .cad: return "🇨🇦"
        default: return "🏦"
        }
    }
    
    var isCrypto: Bool {
        [.btc, .eth, .usdt, .sol].contains(self)
    }
}

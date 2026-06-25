import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject private var vm: AccountViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var type: AccountType = .bankCard
    @State private var balance: Double = 0
    @State private var currency: Currency = .usd
    @State private var cardNumber = ""
    @State private var cardholderName = ""
    @State private var bankName = ""
    @State private var mnemonic = ""
    @State private var walletAddress = ""
    @State private var notes = ""
    @State private var animateCard = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 实时卡片预览
                        LiveCardPreview(
                            name: name.isEmpty ? "新账户" : name,
                            type: type,
                            balance: balance,
                            currency: currency,
                            cardNumber: cardNumber,
                            cardholderName: cardholderName
                        )
                        .padding(.horizontal)
                        .offset(y: animateCard ? 0 : -40).opacity(animateCard ? 1 : 0)
                        .onAppear { withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { animateCard = true } }
                        
                        VStack(spacing: 0) {
                            FormSection(title: "基本信息") {
                                FormRow(label: "名称") {
                                    TextField("账户名称", text: $name)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                }
                                
                                HStack {
                                    Text("类型")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.subheadline)
                                    Spacer()
                                    Picker("", selection: $type) {
                                        ForEach(AccountType.allCases) { type in
                                            Label(type.rawValue, systemImage: type.icon).tag(type)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
                                }
                                .padding(.vertical, 4)
                                
                                FormRow(label: "余额") {
                                    TextField("0.00", value: $balance, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(balance >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                                }
                                
                                HStack {
                                    Text("货币")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.subheadline)
                                    Spacer()
                                    Picker("", selection: $currency) {
                                        ForEach(Currency.allCases) { c in
                                            Text("\(c.flag) \(c.rawValue)").tag(c)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
                                }
                                .padding(.vertical, 4)
                            }
                            
                            if type == .bankCard || type == .creditCard {
                                FormSection(title: "卡片信息") {
                                    FormRow(label: "卡号") {
                                        TextField("卡号", text: $cardNumber)
                                            .multilineTextAlignment(.trailing)
                                            .foregroundColor(.white)
                                            .font(.system(.body, design: .monospaced))
                                    }
                                    FormRow(label: "持卡人") {
                                        TextField("姓名", text: $cardholderName)
                                            .multilineTextAlignment(.trailing)
                                            .foregroundColor(.white)
                                    }
                                    FormRow(label: "银行") {
                                        TextField("银行名称", text: $bankName)
                                            .multilineTextAlignment(.trailing)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            
                            if type == .cryptoWallet {
                                FormSection(title: "钱包信息") {
                                    VStack(alignment: .leading) {
                                        Text("助记词")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                        TextEditor(text: $mnemonic)
                                            .frame(minHeight: 80)
                                            .font(.system(.body, design: .monospaced))
                                            .colorScheme(.dark)
                                    }
                                    FormRow(label: "地址") {
                                        TextField("钱包地址", text: $walletAddress)
                                            .multilineTextAlignment(.trailing)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                            }
                            
                            FormSection(title: "备注") {
                                TextEditor(text: $notes)
                                    .frame(minHeight: 60)
                                    .colorScheme(.dark)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("添加账户")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .foregroundColor(.white.opacity(0.6))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") { addAccount() }
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func addAccount() {
        let account = Account(
            name: name.isEmpty ? "新账户" : name,
            type: type,
            balance: balance,
            currency: currency,
            cardNumber: cardNumber,
            cardholderName: cardholderName,
            bankName: bankName,
            mnemonic: mnemonic,
            walletAddress: walletAddress,
            notes: notes
        )
        vm.addAccount(account)
        dismiss()
    }
}

// MARK: - 实时卡片预览
struct LiveCardPreview: View {
    let name: String
    let type: AccountType
    let balance: Double
    let currency: Currency
    let cardNumber: String
    let cardholderName: String
    
    var gradientColors: [Color] {
        switch type {
        case .bankCard: return [
            Color(red: 0.18, green: 0.28, blue: 0.58),
            Color(red: 0.08, green: 0.12, blue: 0.35)
        ]
        case .creditCard: return [
            Color(red: 0.48, green: 0.18, blue: 0.28),
            Color(red: 0.3, green: 0.08, blue: 0.15)
        ]
        case .cryptoWallet: return [
            Color(red: 0.18, green: 0.42, blue: 0.38),
            Color(red: 0.08, green: 0.25, blue: 0.2)
        ]
        case .cash: return [
            Color(red: 0.22, green: 0.48, blue: 0.22),
            Color(red: 0.1, green: 0.3, blue: 0.1)
        ]
        case .other: return [
            Color(red: 0.32, green: 0.18, blue: 0.48),
            Color(red: 0.2, green: 0.08, blue: 0.3)
        ]
        }
    }
    
    var body: some View {
        ZStack {
            // 背景渐变
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
            
            // 玻璃覆盖层
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.1), .white.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    ZStack {
                        Circle().fill(.white.opacity(0.08)).frame(width: 200, height: 200).offset(x: 80, y: -60)
                        Circle().fill(.white.opacity(0.04)).frame(width: 150, height: 150).offset(x: -60, y: 80)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: gradientColors[0].opacity(0.5), radius: 40, x: 0, y: 15)
            
            // 内容
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: type.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    Text(obfuscatedCard)
                            .font(.system(.title3, design: .monospaced))
                            .foregroundColor(.white)
                            .opacity(cardNumber.isEmpty ? 0 : 1)
                        Text(type.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .foregroundColor(.white.opacity(0.8))
                            .opacity(cardNumber.isEmpty ? 1 : 0)
                }
                
                Spacer()
                
                Text(cardholderName.isEmpty ? "持卡人" : cardholderName.uppercased())
                    .font(.system(.headline, design: .rounded, weight: .medium))
                    .foregroundColor(cardholderName.isEmpty ? .white.opacity(0.4) : .white)
                
                Text(currency.symbol + String(format: "%.2f", balance))
                        .font(.system(size: 28, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                    HStack {
                        Text(name).font(.caption2).foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text(currency.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .foregroundColor(.white.opacity(0.8))
                    }
            }
            .padding(20)
        }
        .aspectRatio(1.56, contentMode: .fit)
    }
    
    var obfuscatedCard: String {
        let clean = cardNumber.filter { $0.isNumber }
        if clean.count >= 4 {
            return "\u{2022}\u{2022}\u{2022}\u{2022}  " + String(clean.suffix(4))
        }
        return cardNumber
    }
}


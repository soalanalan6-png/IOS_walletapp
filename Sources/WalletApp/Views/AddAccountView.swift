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
                    VStack(spacing: 24) {
                        // 卡片预览
                        AddCardPreview(
                            name: name.isEmpty ? "新账户" : name,
                            type: type,
                            balance: balance,
                            currency: currency,
                            cardNumber: cardNumber,
                            cardholderName: cardholderName
                        )
                        .padding(.horizontal, 20)
                        .offset(y: animateCard ? 0 : -40)
                        .opacity(animateCard ? 1 : 0)
                        
                        // 基本信息
                        AddFormSection(title: "基本信息", icon: "info.circle.fill") {
                            AddFormField(label: "名称", icon: "square.and.pencil") {
                                TextField("输入账户名称", text: $name)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            
                            AddFormPicker(label: "类型", icon: "creditcard.fill", selection: $type) {
                                ForEach(AccountType.allCases) { t in
                                    Label(t.rawValue, systemImage: t.icon).tag(t)
                                }
                            }
                            
                            AddFormField(label: "余额", icon: "dollarsign.circle.fill") {
                                TextField("0.00", value: $balance, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(balance >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                                    .font(.subheadline)
                            }
                            
                            AddFormPicker(label: "货币", icon: "globe", selection: $currency) {
                                ForEach(Currency.allCases) { c in
                                    Text("\(c.flag) \(c.rawValue) (\(c.symbol))").tag(c)
                                }
                            }
                        }
                        
                        // 卡片信息
                        if type == .bankCard || type == .creditCard {
                            AddFormSection(title: "卡片信息", icon: "creditcard.and.123") {
                                AddFormField(label: "卡号", icon: "number") {
                                    TextField("输入卡号", text: $cardNumber)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .font(.system(.subheadline, design: .monospaced))
                                }
                                AddFormField(label: "持卡人", icon: "person.fill") {
                                    TextField("持卡人姓名", text: $cardholderName)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                                AddFormField(label: "银行", icon: "building.columns.fill") {
                                    TextField("银行名称", text: $bankName)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                            }
                        }
                        
                        // 钱包信息
                        if type == .cryptoWallet {
                            AddFormSection(title: "钱包信息", icon: "bitcoinsign.circle.fill") {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("助记词")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.4))
                                    TextEditor(text: $mnemonic)
                                        .frame(minHeight: 80)
                                        .font(.system(.subheadline, design: .monospaced))
                                        .colorScheme(.dark)
                                        .scrollContentBackground(.hidden)
                                        .background(Color(red: 0.06, green: 0.07, blue: 0.14))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                AddFormField(label: "地址", icon: "link") {
                                    TextField("钱包地址", text: $walletAddress)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        // 备注
                        AddFormSection(title: "备注", icon: "note.text") {
                            TextEditor(text: $notes)
                                .frame(minHeight: 70)
                                .colorScheme(.dark)
                                .scrollContentBackground(.hidden)
                                .background(Color(red: 0.06, green: 0.07, blue: 0.14))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("添加账户")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .foregroundColor(.white.opacity(0.5))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") { addAccount() }
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animateCard = true
                }
            }
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

// MARK: - 添加卡片预览
struct AddCardPreview: View {
    let name: String
    let type: AccountType
    let balance: Double
    let currency: Currency
    let cardNumber: String
    let cardholderName: String
    
    var gradientColors: [Color] {
        switch type {
        case .bankCard: return [Color(red: 0.18, green: 0.28, blue: 0.58), Color(red: 0.08, green: 0.12, blue: 0.35)]
        case .creditCard: return [Color(red: 0.48, green: 0.18, blue: 0.28), Color(red: 0.3, green: 0.08, blue: 0.15)]
        case .cryptoWallet: return [Color(red: 0.18, green: 0.42, blue: 0.38), Color(red: 0.08, green: 0.25, blue: 0.2)]
        case .cash: return [Color(red: 0.22, green: 0.48, blue: 0.22), Color(red: 0.1, green: 0.3, blue: 0.1)]
        case .other: return [Color(red: 0.32, green: 0.18, blue: 0.48), Color(red: 0.2, green: 0.08, blue: 0.3)]
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
            
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: [.white.opacity(0.1), .white.opacity(0.02)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    ZStack {
                        Circle().fill(.white.opacity(0.08)).frame(width: 200, height: 200).offset(x: 80, y: -60)
                        Circle().fill(.white.opacity(0.04)).frame(width: 150, height: 150).offset(x: -60, y: 80)
                    }
                )
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.18), lineWidth: 1))
                .shadow(color: gradientColors[0].opacity(0.5), radius: 40, x: 0, y: 15)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: type.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    if !cardNumber.isEmpty {
                        Text("\u{2022}\u{2022}\u{2022}\u{2022} \(cardNumber.suffix(4))")
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.white)
                    } else {
                        Text(type.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(cardholderName.isEmpty ? "持卡人" : cardholderName.uppercased())
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(currency.symbol + String(format: "%.2f", balance))
                        .font(.system(size: 28, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack {
                        Text(name)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
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
            }
            .padding(18)
        }
        .aspectRatio(1.56, contentMode: .fit)
    }
}

// MARK: - 表单分区
struct AddFormSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(red: 0.1, green: 0.11, blue: 0.18))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.white.opacity(0.05), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 表单输入行
struct AddFormField<Content: View>: View {
    let label: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.15))
                    .frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
            }
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            content
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        
        Divider()
            .background(.white.opacity(0.05))
            .padding(.leading, 52)
    }
}

// MARK: - 表单选择器行
struct AddFormPicker<SelectionValue: Hashable, Content: View>: View {
    let label: String
    let icon: String
    @Binding var selection: SelectionValue
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.15))
                    .frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
            }
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Picker("", selection: $selection) {
                content
            }
            .pickerStyle(.menu)
            .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        
        if label != "货币" && label != "类型" {
            Divider()
                .background(.white.opacity(0.05))
                .padding(.leading, 52)
        }
    }
}


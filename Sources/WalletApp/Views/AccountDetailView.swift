import SwiftUI

struct AccountDetailView: View {
    @EnvironmentObject private var vm: AccountViewModel
    @State var account: Account
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var cardOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.07, blue: 0.13)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // 卡片预览
                    CardPreview(account: account)
                        .padding(.horizontal)
                        .offset(y: cardOffset)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                cardOffset = 0
                            }
                        }
                    
                    // 编辑表单
                    VStack(spacing: 0) {
                        FormSection(title: "基本信息") {
                            FormRow(label: "名称") {
                                TextField("账户名称", text: $account.name)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.white)
                            }
                            
                            FormPickerRow(label: "类型", selection: $account.type) {
                                ForEach(AccountType.allCases) { type in
                                    Label(type.rawValue, systemImage: type.icon).tag(type)
                                }
                            }
                            
                            FormRow(label: "余额") {
                                TextField("0.00", value: $account.balance, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(account.balance >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                            }
                            
                            FormPickerRow(label: "货币", selection: $account.currency) {
                                ForEach(Currency.allCases) { c in
                                    Text("\(c.flag) \(c.rawValue)").tag(c)
                                }
                            }
                        }
                        
                        if account.type == .bankCard || account.type == .creditCard {
                            FormSection(title: "卡片信息") {
                                FormRow(label: "卡号") {
                                    TextField("卡号", text: $account.cardNumber)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .font(.system(.body, design: .monospaced))
                                }
                                FormRow(label: "持卡人") {
                                    TextField("姓名", text: $account.cardholderName)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                }
                                FormRow(label: "银行") {
                                    TextField("银行名称", text: $account.bankName)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        if account.type == .cryptoWallet {
                            FormSection(title: "钱包信息") {
                                VStack(alignment: .leading) {
                                    Text("助记词")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                    TextEditor(text: $account.mnemonic)
                                        .frame(minHeight: 80)
                                        .font(.system(.body, design: .monospaced))
                                        .colorScheme(.dark)
                                }
                                FormRow(label: "地址") {
                                    TextField("钱包地址", text: $account.walletAddress)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        FormSection(title: "备注") {
                            TextEditor(text: $account.notes)
                                .frame(minHeight: 60)
                                .colorScheme(.dark)
                        }
                    }
                    
                    // 操作按钮
                    VStack(spacing: 12) {
                        Button(action: save) {
                            Text("保存")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(colors: [Color(red: 0.3, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.3, blue: 0.9)], startPoint: .leading, endPoint: .trailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .foregroundColor(.white)
                        }
                        
                        Button(role: .destructive) {
                            showDeleteAlert = true
                        } label: {
                            Text("删除账户")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("编辑账户")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                vm.deleteAccount(account)
                dismiss()
            }
        }
    }
    
    private func save() {
        vm.updateAccount(account)
        dismiss()
    }
}

// 卡片预览组件
struct CardPreview: View {
    let account: Account
    
    var gradientColors: [Color] {
        switch account.type {
        case .bankCard: return [Color(red: 0.15, green: 0.25, blue: 0.55), Color(red: 0.08, green: 0.12, blue: 0.35)]
        case .creditCard: return [Color(red: 0.45, green: 0.15, blue: 0.25), Color(red: 0.3, green: 0.08, blue: 0.15)]
        case .cryptoWallet: return [Color(red: 0.15, green: 0.4, blue: 0.35), Color(red: 0.08, green: 0.25, blue: 0.2)]
        case .cash: return [Color(red: 0.2, green: 0.45, blue: 0.2), Color(red: 0.1, green: 0.3, blue: 0.1)]
        case .other: return [Color(red: 0.3, green: 0.15, blue: 0.45), Color(red: 0.2, green: 0.08, blue: 0.3)]
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.08))
                            .frame(width: 200, height: 200)
                            .offset(x: 80, y: -60)
                        Circle()
                            .fill(.white.opacity(0.05))
                            .frame(width: 150, height: 150)
                            .offset(x: -60, y: 80)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: gradientColors[0].opacity(0.5), radius: 40, x: 0, y: 15)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: account.type.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    if !account.cardNumber.isEmpty {
                        Text(String(repeating: "●", count: 4))
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.6))
                        + Text(account.cardNumber.suffix(4))
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                if !account.cardholderName.isEmpty {
                    Text(account.cardholderName.uppercased())
                        .font(.system(.headline, design: .rounded, weight: .medium))
                        .foregroundColor(.white)
                } else {
                    Text("持卡人姓名")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                }
                
                HStack {
                    Text(account.formattedBalance)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(account.currency.rawValue)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
            .padding(20)
        }
        .frame(height: 200)
    }
}

// 表单组件
struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.footnote)
                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            content
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(red: 0.12, green: 0.13, blue: 0.2))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
        }
    }
}

struct FormRow<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
            Spacer()
            content
        }
        .padding(.vertical, 4)
    }
}

struct FormPickerRow<SelectionValue: Hashable, Content: View>: View {
    let label: String
    @Binding var selection: SelectionValue
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
            Spacer()
            Picker("", selection: $selection) {
                content
            }
            .pickerStyle(.menu)
            .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
        }
        .padding(.vertical, 4)
    }
}

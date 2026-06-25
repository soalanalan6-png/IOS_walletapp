import SwiftUI

struct AccountDetailView: View {
    @EnvironmentObject private var vm: AccountViewModel
    @State var account: Account
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    
    var body: some View {
        Form {
            Section("基本信息") {
                HStack {
                    Text("名称")
                    Spacer()
                    TextField("账户名称", text: $account.name)
                        .multilineTextAlignment(.trailing)
                }
                Picker("类型", selection: $account.type) {
                    ForEach(AccountType.allCases) { type in
                        Label(type.rawValue, systemImage: type.icon).tag(type)
                    }
                }
                HStack {
                    Text("余额")
                    Spacer()
                    TextField("0.00", value: $account.balance, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                Picker("货币", selection: $account.currency) {
                    ForEach(Currency.allCases) { c in
                        Text("\(c.flag) \(c.rawValue)").tag(c)
                    }
                }
            }
            
            if account.type == .bankCard || account.type == .creditCard {
                Section("卡片信息") {
                    HStack {
                        Text("卡号")
                        Spacer()
                        TextField("卡号", text: $account.cardNumber)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("持卡人")
                        Spacer()
                        TextField("持卡人姓名", text: $account.cardholderName)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("银行")
                        Spacer()
                        TextField("银行名称", text: $account.bankName)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            
            if account.type == .cryptoWallet {
                Section("钱包信息") {
                    VStack(alignment: .leading) {
                        Text("助记词")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextEditor(text: $account.mnemonic)
                            .frame(minHeight: 80)
                            .font(.system(.body, design: .monospaced))
                    }
                    HStack {
                        Text("钱包地址")
                        Spacer()
                        TextField("地址", text: $account.walletAddress)
                            .multilineTextAlignment(.trailing)
                            .font(.caption)
                    }
                }
            }
            
            Section("备注") {
                TextEditor(text: $account.notes)
                    .frame(minHeight: 60)
            }
            
            Section {
                Button("保存", action: save)
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                
                Button("删除账户", role: .destructive) {
                    showDeleteAlert = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("编辑账户")
        .navigationBarTitleDisplayMode(.inline)
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                vm.deleteAccount(account)
                dismiss()
            }
        } message: {
            Text("删除后无法恢复")
        }
    }
    
    private func save() {
        vm.updateAccount(account)
        dismiss()
    }
}

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
    
    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    HStack {
                        Text("名称")
                        Spacer()
                        TextField("账户名称", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("类型", selection: $type) {
                        ForEach(AccountType.allCases) { type in
                            Label(type.rawValue, systemImage: type.icon).tag(type)
                        }
                    }
                    HStack {
                        Text("余额")
                        Spacer()
                        TextField("0.00", value: $balance, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("货币", selection: $currency) {
                        ForEach(Currency.allCases) { c in
                            Text("\(c.flag) \(c.rawValue)").tag(c)
                        }
                    }
                }
                
                if type == .bankCard || type == .creditCard {
                    Section("卡片信息") {
                        HStack {
                            Text("卡号")
                            Spacer()
                            TextField("卡号", text: $cardNumber)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("持卡人")
                            Spacer()
                            TextField("持卡人姓名", text: $cardholderName)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("银行")
                            Spacer()
                            TextField("银行名称", text: $bankName)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                
                if type == .cryptoWallet {
                    Section("钱包信息") {
                        VStack(alignment: .leading) {
                            Text("助记词")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextEditor(text: $mnemonic)
                                .frame(minHeight: 80)
                                .font(.system(.body, design: .monospaced))
                        }
                        HStack {
                            Text("钱包地址")
                            Spacer()
                            TextField("地址", text: $walletAddress)
                                .multilineTextAlignment(.trailing)
                                .font(.caption)
                        }
                    }
                }
                
                Section("备注") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                }
            }
            .navigationTitle("添加账户")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
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
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

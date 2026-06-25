import SwiftUI

struct SettingsView: View {
    @AppStorage("default_currency") private var defaultCurrency = Currency.usd.rawValue
    @AppStorage("app_theme") private var appTheme = "system"
    @AppStorage("show_crypto") private var showCrypto = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("默认设置") {
                    Picker("默认货币", selection: $defaultCurrency) {
                        ForEach(Currency.allCases.filter { !$0.isCrypto }) { c in
                            Text("\(c.flag) \(c.rawValue) (\(c.symbol))").tag(c.rawValue)
                        }
                    }
                }
                
                Section("显示选项") {
                    Toggle("显示加密货币", isOn: $showCrypto)
                }
                
                Section("关于") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("数据存储")
                        Spacer()
                        Text("本地")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("数据管理") {
                    Button("导出数据", role: .none) {
                        // TODO: export
                    }
                    Button("清除所有数据", role: .destructive) {
                        UserDefaults.standard.removeObject(forKey: "saved_accounts")
                        UserDefaults.standard.removeObject(forKey: "saved_liabilities")
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

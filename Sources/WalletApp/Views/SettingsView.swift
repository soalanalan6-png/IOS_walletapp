import SwiftUI

struct SettingsView: View {
    @AppStorage("default_currency") private var defaultCurrency = Currency.usd.rawValue
    @AppStorage("app_theme") private var appTheme = "system"
    @AppStorage("show_crypto") private var showCrypto = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("默认设置")
                                .font(.footnote)
                                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Text("默认货币")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.subheadline)
                                    Spacer()
                                    Picker("默认货币", selection: $defaultCurrency) {
                                        ForEach(Currency.allCases.filter { !$0.isCrypto }) { c in
                                            Text("\(c.flag) \(c.rawValue) (\(c.symbol))").tag(c.rawValue)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                            .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("显示选项")
                                .font(.footnote)
                                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 0) {
                                Toggle("显示加密货币", isOn: $showCrypto)
                                    .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                            }
                            .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("关于")
                                .font(.footnote)
                                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Text("版本")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.subheadline)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                
                                Divider().background(.white.opacity(0.06)).padding(.leading, 16)
                                
                                HStack {
                                    Text("数据存储")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.subheadline)
                                    Spacer()
                                    Text("本地")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                            .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("数据管理")
                                .font(.footnote)
                                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 0) {
                                Button(action: {}) {
                                    HStack {
                                        Text("导出数据")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                        Spacer()
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                }
                                
                                Divider().background(.white.opacity(0.06)).padding(.leading, 16)
                                
                                Button(role: .destructive) {
                                    UserDefaults.standard.removeObject(forKey: "saved_accounts")
                                    UserDefaults.standard.removeObject(forKey: "saved_liabilities")
                                } label: {
                                    HStack {
                                        Text("清除所有数据")
                                            .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                                            .font(.subheadline)
                                        Spacer()
                                        Image(systemName: "trash")
                                            .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                }
                            }
                            .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("设置")
            .preferredColorScheme(.dark)
        }
    }
}

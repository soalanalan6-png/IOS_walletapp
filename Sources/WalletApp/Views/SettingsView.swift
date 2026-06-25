import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject private var accountVM: AccountViewModel
    @EnvironmentObject private var liabilityVM: LiabilityViewModel
    
    @AppStorage("biometric_enabled") private var biometricEnabled = false
    @AppStorage("default_currency") private var defaultCurrencyRaw = Currency.usd.rawValue
    @State private var showClearAlert = false
    @State private var showCurrencyPicker = false
    @State private var showNotificationSettings = false
    
    var defaultCurrency: Currency {
        get { Currency.allCases.first(where: { $0.rawValue == defaultCurrencyRaw }) ?? .usd }
        set { defaultCurrencyRaw = newValue.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileCard
                        
                        // 通用设置
                        SettingsSection(title: "通用") {
                            Button { showNotificationSettings = true } label: {
                                SettingsRowContent(icon: "bell.badge.fill", iconColor: Color(red: 1.0, green: 0.6, blue: 0.2), label: "通知", showChevron: true)
                            }
                            .buttonStyle(.plain)
                            
                            Button { showCurrencyPicker = true } label: {
                                SettingsRowContent(icon: "globe.asia.australia.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "默认货币", value: defaultCurrencyRaw)
                            }
                            .buttonStyle(.plain)
                            
                            SettingsRowContent(icon: "paintpalette.fill", iconColor: Color(red: 1.0, green: 0.35, blue: 0.35), label: "主题", value: "深色")
                                .opacity(0.6)
                            
                            ToggleRow(icon: "faceid", iconColor: Color(red: 0.3, green: 0.85, blue: 0.6), label: "生物识别", isOn: $biometricEnabled)
                        }
                        
                        // 数据设置
                        SettingsSection(title: "数据") {
                            Button(action: exportData) {
                                SettingsRowContent(icon: "square.and.arrow.up.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "导出数据", showChevron: true)
                            }
                            .buttonStyle(.plain)
                            
                            Button(role: .destructive) { showClearAlert = true } label: {
                                SettingsRowContent(icon: "trash.fill", iconColor: Color(red: 1.0, green: 0.35, blue: 0.35), label: "清除所有数据", isDestructive: true)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // 其他
                        SettingsSection(title: "其他") {
                            Button(action: rateApp) {
                                SettingsRowContent(icon: "star.fill", iconColor: Color(red: 1.0, green: 0.8, blue: 0.2), label: "评分", showChevron: true)
                            }
                            .buttonStyle(.plain)
                            
                            SettingsRowContent(icon: "info.circle.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "版本", value: "1.0.0")
                        }
                        
                        Text("Wallet App 1.0.0")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.2))
                            .padding(.bottom, 20)
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
            }
            .navigationTitle("设置")
            .preferredColorScheme(.dark)
            .alert("清除所有数据", isPresented: $showClearAlert) {
                Button("取消", role: .cancel) {}
                Button("确认清除", role: .destructive) {
                    UserDefaults.standard.removeObject(forKey: "saved_accounts")
                    UserDefaults.standard.removeObject(forKey: "saved_liabilities")
                }
            } message: {
                Text("此操作将删除所有账户和负债数据，且不可恢复。")
            }
            .sheet(isPresented: $showCurrencyPicker) {
                currencyPickerSheet
            }
            .sheet(isPresented: $showNotificationSettings) {
                notificationSheet
            }
        }
    }
    
    // MARK: - 用户卡片
    private var profileCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(red: 0.3, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.3, blue: 0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 72, height: 72)
                    .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 2))
                Image(systemName: "person.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
            VStack(spacing: 4) {
                Text("我的账户")
                    .font(.title3).fontWeight(.semibold).foregroundColor(.white)
                Text("本地数据存储 · \(accountVM.accounts.count) 个账户")
                    .font(.caption).foregroundColor(.white.opacity(0.4))
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - 货币选择器
    private var currencyPickerSheet: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(Currency.allCases.filter { !$0.isCrypto }) { c in
                            Button {
                                defaultCurrencyRaw = c.rawValue
                                showCurrencyPicker = false
                            } label: {
                                HStack {
                                    Text("\(c.flag) \(c.rawValue) (\(c.symbol))")
                                        .foregroundColor(.white)
                                    Spacer()
                                    if defaultCurrencyRaw == c.rawValue {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                    }
                                }
                                .padding()
                                .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("选择默认货币")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { showCurrencyPicker = false }
                        .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    // MARK: - 通知设置
    private var notificationSheet: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1).ignoresSafeArea()
                VStack(spacing: 24) {
                    Image(systemName: "bell.badge")
                        .font(.system(size: 48))
                        .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.2).opacity(0.5))
                        .padding(.top, 40)
                    
                    Text("通知功能即将上线")
                        .font(.title3).fontWeight(.semibold).foregroundColor(.white)
                    
                    Text("余额变动提醒、账单到期通知等功能正在开发中。")
                        .font(.subheadline).foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("通知")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { showNotificationSettings = false }
                        .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    // MARK: - 导出数据
    private func exportData() {
        let data: [String: Any] = [
            "accounts": accountVM.accounts.map { ["name": $0.name, "type": $0.type.rawValue, "balance": $0.balance] },
            "liabilities": liabilityVM.liabilities.map { ["name": $0.name, "amount": $0.amount] }
        ]
        if let json = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("wallet_export.json")
            try? json.write(to: url)
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = scene.windows.first?.rootViewController {
                root.present(activityVC, animated: true)
            }
        }
    }
    
    // MARK: - 评分
    private func rateApp() {
        if let url = URL(string: "https://apps.apple.com/app/id123456789") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - 设置行内容（无动作）
struct SettingsRowContent: View {
    let icon: String
    let iconColor: Color
    let label: String
    var value: String? = nil
    var showChevron: Bool = false
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            Text(label)
                .font(.subheadline)
                .foregroundColor(isDestructive ? Color(red: 1.0, green: 0.35, blue: 0.35) : .white)
            Spacer()
            if let value = value {
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.4))
            }
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .if(label != "版本" && !isDestructive) { view in
            VStack(spacing: 0) {
                view
                Divider().background(.white.opacity(0.05)).padding(.leading, 56)
            }
        }
    }
}

// MARK: - 开关行
struct ToggleRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
                .labelsHidden()
                .scaleEffect(0.85)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

// MARK: - 设置分区
struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.footnote)
                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.8))
                .padding(.horizontal, 4)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) { content }
                .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.05), lineWidth: 1))
        }
    }
}

// MARK: - 条件修改器
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}

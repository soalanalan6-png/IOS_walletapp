import UIKit
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var accountVM: AccountViewModel
    @EnvironmentObject private var liabilityVM: LiabilityViewModel
    
    @AppStorage("biometric_enabled") private var biometricEnabled = false
    @AppStorage("default_currency") private var defaultCurrencyRaw = Currency.usd.rawValue
    
    @State private var showClearAlert = false
    @State private var showCurrencyPicker = false
    @State private var exportFile: ExportFile?
    @State private var toastMessage = ""
    @State private var showToast = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        profileCard
                        
                        SettingsSection(title: "通用") {
                            Button { showToastMsg("通知功能即将上线") } label: {
                                SettingsRow(icon: "bell.badge.fill", iconColor: .orange, label: "通知", showChevron: true)
                            }.buttonStyle(.plain)
                            
                            Button { showCurrencyPicker = true } label: {
                                SettingsRow(icon: "globe.asia.australia.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "默认货币", value: defaultCurrencyRaw)
                            }.buttonStyle(.plain)
                            
                            SettingsRow(icon: "paintpalette.fill", iconColor: .red, label: "主题", value: "深色").opacity(0.6)
                            
                            ToggleRow(icon: "faceid", iconColor: .green, label: "生物识别", isOn: $biometricEnabled)
                        }
                        
                        SettingsSection(title: "数据") {
                            Button { exportData() } label: {
                                SettingsRow(icon: "square.and.arrow.up.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "导出数据", showChevron: true)
                            }.buttonStyle(.plain)
                            
                            Button(role: .destructive) { showClearAlert = true } label: {
                                SettingsRow(icon: "trash.fill", iconColor: .red, label: "清除所有数据", isDestructive: true)
                            }.buttonStyle(.plain)
                        }
                        
                        SettingsSection(title: "其他") {
                            Button { if let url = URL(string: "https://apps.apple.com/app/id123456789") { UIApplication.shared.open(url) } } label: {
                                SettingsRow(icon: "star.fill", iconColor: .yellow, label: "评分", showChevron: true)
                            }.buttonStyle(.plain)
                            
                            SettingsRow(icon: "info.circle.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "版本", value: "1.0.0")
                        }
                        
                        Text("Wallet App 1.0.0").font(.caption2).foregroundColor(.white.opacity(0.2))
                    }
                    .padding(.horizontal).padding(.vertical)
                }
            }
            .navigationTitle("设置")
            .preferredColorScheme(.dark)
            .alert("清除所有数据", isPresented: $showClearAlert) {
                Button("取消", role: .cancel) {}
                Button("确认清除", role: .destructive) {
                    UserDefaults.standard.removeObject(forKey: "saved_accounts")
                    UserDefaults.standard.removeObject(forKey: "saved_liabilities")
                    showToastMsg("已清除所有数据")
                }
            } message: { Text("此操作不可恢复。") }
            .sheet(isPresented: $showCurrencyPicker) { CurrencyPickerSheet(defaultRaw: $defaultCurrencyRaw, dismiss: { showCurrencyPicker = false }) }
            .sheet(item: $exportFile) { file in
                ShareSheet(items: [file.url])
            }
            .overlay(alignment: .bottom) {
                if showToast {
                    Text(toastMessage).font(.subheadline).foregroundColor(.white)
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(.ultraThinMaterial).clipShape(Capsule())
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
    
    private var profileCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle().fill(LinearGradient(colors: [Color(red: 0.3, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.3, blue: 0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 72, height: 72)
                    .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 2))
                Image(systemName: "person.fill").font(.system(size: 32)).foregroundColor(.white)
            }
            VStack(spacing: 4) {
                Text("我的账户").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                Text("本地数据存储 · \(accountVM.accounts.count) 个账户").font(.caption).foregroundColor(.white.opacity(0.4))
            }
        }
        .padding(.top, 8)
    }
    
    private func exportData() {
        let data: [String: Any] = [
            "accounts": accountVM.accounts.map { ["name": $0.name, "type": $0.type.rawValue, "balance": $0.balance] },
            "liabilities": liabilityVM.liabilities.map { ["name": $0.name, "amount": $0.amount] }
        ]
        if let json = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("wallet_export.json")
            try? json.write(to: url)
            exportFile = ExportFile(url: url)
        }
    }
    
    private func showToastMsg(_ msg: String) {
        toastMessage = msg
        withAnimation(.easeInOut(duration: 0.3)) { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) { showToast = false }
        }
    }
}

// MARK: - 货币选择器
struct CurrencyPickerSheet: View {
    @Binding var defaultRaw: String
    let dismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(Currency.allCases.filter { !$0.isCrypto }) { c in
                            Button {
                                defaultRaw = c.rawValue
                                dismiss()
                            } label: {
                                HStack {
                                    Text("\(c.flag) \(c.rawValue) (\(c.symbol))").foregroundColor(.white)
                                    Spacer()
                                    if defaultRaw == c.rawValue {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                    }
                                }
                                .padding().background(Color(red: 0.1, green: 0.11, blue: 0.18)).clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("选择默认货币").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }.foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ExportFile: Identifiable {
    let id = UUID()
    let url: URL
}

// MARK: - 分享Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController { UIActivityViewController(activityItems: items, applicationActivities: nil) }
    func updateUIViewController(_ ui: UIActivityViewController, context: Context) {}
}

// MARK: - 设置行（含分隔线）
struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    var value: String? = nil
    var showChevron: Bool = false
    var isDestructive: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(iconColor.opacity(0.2)).frame(width: 30, height: 30)
                    Image(systemName: icon).font(.system(size: 14)).foregroundColor(iconColor)
                }
                Text(label).font(.subheadline).foregroundColor(isDestructive ? .red : .white)
                Spacer()
                if let v = value {
                    Text(v).font(.subheadline).foregroundColor(.white.opacity(0.4))
                }
                if showChevron {
                    Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.25))
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            
            if label != "版本" && !isDestructive {
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
                RoundedRectangle(cornerRadius: 8).fill(iconColor.opacity(0.2)).frame(width: 30, height: 30)
                Image(systemName: icon).font(.system(size: 14)).foregroundColor(iconColor)
            }
            Text(label).font(.subheadline).foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn).tint(Color(red: 0.3, green: 0.6, blue: 1.0)).labelsHidden().scaleEffect(0.85)
        }
        .padding(.horizontal, 14).padding(.vertical, 12)
    }
}

// MARK: - 设置分区
struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(.footnote).foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.8)).padding(.horizontal, 4).padding(.bottom, 8)
            VStack(spacing: 0) { content }
                .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.05), lineWidth: 1))
        }
    }
}








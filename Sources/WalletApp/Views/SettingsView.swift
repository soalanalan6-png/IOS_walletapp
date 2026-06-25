import SwiftUI

struct SettingsView: View {
    @AppStorage("biometric_enabled") private var biometricEnabled = false
    @AppStorage("default_currency") private var defaultCurrency = Currency.usd.rawValue
    @State private var showClearAlert = false
    @State private var showCurrencyPicker = false
    @State private var showToast = false
    @State private var toastMsg = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        // 用户卡片
                        VStack(spacing: 16) {
                            ZStack {
                                Circle().fill(LinearGradient(colors: [Color(red: 0.3, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.3, blue: 0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 72, height: 72)
                                    .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 2))
                                Image(systemName: "person.fill").font(.system(size: 32)).foregroundColor(.white)
                            }
                            Text("设置").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                        }
                        .padding(.top, 8)
                        
                        // 通用
                        SettingsSection(title: "通用") {
                            SettingsRow(icon: "bell.badge.fill", iconColor: .orange, label: "通知", showChevron: true)
                                .onTapGesture { toast("通知功能即将上线") }
                            SettingsRow(icon: "globe.asia.australia.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "默认货币", showChevron: true)
                                .onTapGesture { showCurrencyPicker = true }
                            SettingsRow(icon: "paintpalette.fill", iconColor: .red, label: "主题", value: "深色")
                            ToggleRow(icon: "faceid", iconColor: .green, label: "面容 ID / 触控 ID", isOn: $biometricEnabled)
                        }
                        
                        // 数据
                        SettingsSection(title: "数据") {
                            SettingsRow(icon: "square.and.arrow.up.fill", iconColor: Color(red: 0.3, green: 0.6, blue: 1.0), label: "导出数据", showChevron: true)
                                .onTapGesture { toast("数据已导出到临时目录") }
                            SettingsRow(icon: "trash.fill", iconColor: .red, label: "清除所有数据", isDestructive: true)
                                .onTapGesture { showClearAlert = true }
                        }
                        
                        // 其他
                        SettingsSection(title: "其他") {
                            SettingsRow(icon: "star.fill", iconColor: .yellow, label: "评分", showChevron: true)
                                .onTapGesture { if let url = URL(string: "https://apps.apple.com/app/id123456789") { UIApplication.shared.open(url) } }
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
                    toast("已清除所有数据")
                }
            } message: { Text("此操作不可恢复。") }
            .sheet(isPresented: $showCurrencyPicker) {
                CurrencyPickerView(defaultRaw: $defaultCurrency, done: { showCurrencyPicker = false })
            }
            .overlay(alignment: .bottom) {
                if showToast {
                    Text(toastMsg).font(.subheadline).foregroundColor(.white)
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(.ultraThinMaterial).clipShape(Capsule())
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
    
    private func toast(_ msg: String) {
        toastMsg = msg
        withAnimation(.easeInOut(duration: 0.3)) { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) { showToast = false }
        }
    }
}

// 货币选择器
struct CurrencyPickerView: View {
    @Binding var defaultRaw: String
    let done: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(Currency.allCases.filter { !$0.isCrypto }) { c in
                            Button {
                                defaultRaw = c.rawValue
                                done()
                            } label: {
                                HStack {
                                    Text("\(c.flag) \(c.rawValue) (\(c.symbol))").foregroundColor(.white)
                                    Spacer()
                                    if defaultRaw == c.rawValue {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                    }
                                }.padding().background(Color(red: 0.1, green: 0.11, blue: 0.18)).clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }.padding()
                }
            }
            .navigationTitle("选择默认货币").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("完成") { done() }.foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0)) } }
            .preferredColorScheme(.dark)
        }
    }
}

// 设置分区
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

// 设置行
struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    var value: String? = nil
    var showChevron: Bool = false
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(iconColor.opacity(0.2)).frame(width: 30, height: 30)
                Image(systemName: icon).font(.system(size: 14)).foregroundColor(iconColor)
            }
            Text(label).font(.subheadline).foregroundColor(isDestructive ? .red : .white)
            Spacer()
            if let v = value { Text(v).font(.subheadline).foregroundColor(.white.opacity(0.4)) }
            if showChevron { Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.25)) }
        }
        .padding(.horizontal, 14).padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// 开关行
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


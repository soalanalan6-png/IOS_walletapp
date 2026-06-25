import SwiftUI

struct SettingsView: View {
    @State private var showingExport = false
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 顶部用户卡片
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.3, green: 0.6, blue: 1.0),
                                                Color(red: 0.4, green: 0.3, blue: 0.9)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 72, height: 72)
                                    .overlay(
                                        Circle()
                                            .stroke(.white.opacity(0.15), lineWidth: 2)
                                    )
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 4) {
                                Text("我的账户")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Text("本地数据存储 · 加密安全")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        .padding(.top, 8)
                        
                        // 通用设置
                        SettingsSection(title: "通用") {
                            SettingsRow(
                                icon: "bell.badge.fill",
                                iconColor: Color(red: 1.0, green: 0.6, blue: 0.2),
                                label: "通知"
                            )
                            SettingsRow(
                                icon: "globe.asia.australia.fill",
                                iconColor: Color(red: 0.3, green: 0.6, blue: 1.0),
                                label: "默认货币",
                                value: Currency.usd.rawValue
                            )
                            SettingsRow(
                                icon: "paintpalette.fill",
                                iconColor: Color(red: 1.0, green: 0.35, blue: 0.35),
                                label: "主题",
                                value: "深色"
                            )
                            SettingsRow(
                                icon: "faceid",
                                iconColor: Color(red: 0.3, green: 0.85, blue: 0.6),
                                label: "生物识别",
                                hasToggle: true
                            )
                        }
                        
                        // 数据设置
                        SettingsSection(title: "数据") {
                            SettingsRow(
                                icon: "square.and.arrow.up.fill",
                                iconColor: Color(red: 0.3, green: 0.6, blue: 1.0),
                                label: "导出数据"
                            )
                            SettingsRow(
                                icon: "trash.fill",
                                iconColor: Color(red: 1.0, green: 0.35, blue: 0.35),
                                label: "清除所有数据",
                                isDestructive: true
                            )
                        }
                        
                        // 其他
                        SettingsSection(title: "其他") {
                            SettingsRow(
                                icon: "star.fill",
                                iconColor: Color(red: 1.0, green: 0.8, blue: 0.2),
                                label: "评分"
                            )
                            SettingsRow(
                                icon: "info.circle.fill",
                                iconColor: Color(red: 0.3, green: 0.6, blue: 1.0),
                                label: "版本",
                                value: "1.0.0"
                            )
                        }
                        
                        // 底部
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
            .alert("确认清除", isPresented: $showingClearAlert) {
                Button("取消", role: .cancel) {}
                Button("清除", role: .destructive) {
                    UserDefaults.standard.removeObject(forKey: "saved_accounts")
                    UserDefaults.standard.removeObject(forKey: "saved_liabilities")
                }
            }
        }
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
    }
}

// MARK: - 设置行
struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    var value: String? = nil
    var hasToggle: Bool = false
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
            
            if hasToggle {
                Toggle("", isOn: .constant(true))
                    .tint(Color(red: 0.3, green: 0.6, blue: 1.0))
                    .labelsHidden()
                    .scaleEffect(0.85)
            } else if let value = value {
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.4))
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.25))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        
        if label != "版本" && label != "清除所有数据" {
            Divider()
                .background(.white.opacity(0.05))
                .padding(.leading, 56)
        }
    }
}

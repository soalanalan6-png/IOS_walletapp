import SwiftUI

struct AccountListView: View {
    @EnvironmentObject private var vm: AccountViewModel
    @State private var showAdd = false
    @State private var selectedCard: Account?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 标题区域
                        HStack {
                            Text("全部资产")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Text(vm.accounts.isEmpty ? "$0.00" : String(format: "$%.2f", vm.totalBalance))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.3, green: 0.85, blue: 0.6))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        if vm.accounts.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "creditcard")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.15))
                                Text("暂无账户")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.5))
                                Text("点击右上角 + 添加你的第一个账户")
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                        } else {
                            // 横滑卡片区域
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: -20) {
                                    ForEach(vm.accounts) { account in
                                        NavigationLink(destination: AccountDetailView(account: account)) {
                                            AssetsBankCard(account: account)
                                                .frame(width: 290, height: 186)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            }
                            
                            // 账户列表
                            Text("账户明细")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(vm.accounts) { account in
                                    NavigationLink(destination: AccountDetailView(account: account)) {
                                        AccountMiniCard(account: account)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .onDelete { indexSet in
                                    for i in indexSet {
                                        vm.deleteAccount(vm.accounts[i])
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddAccountView()
            }
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - 横滑大卡片
struct AssetsBankCard: View {
    let account: Account
    @State private var isPressed = false
    
    var gradientColors: [Color] {
        switch account.type {
        case .bankCard: return [
            Color(red: 0.18, green: 0.28, blue: 0.58),
            Color(red: 0.08, green: 0.12, blue: 0.35)
        ]
        case .creditCard: return [
            Color(red: 0.48, green: 0.18, blue: 0.28),
            Color(red: 0.3, green: 0.08, blue: 0.15)
        ]
        case .cryptoWallet: return [
            Color(red: 0.18, green: 0.42, blue: 0.38),
            Color(red: 0.08, green: 0.25, blue: 0.2)
        ]
        case .cash: return [
            Color(red: 0.22, green: 0.48, blue: 0.22),
            Color(red: 0.1, green: 0.3, blue: 0.1)
        ]
        case .other: return [
            Color(red: 0.32, green: 0.18, blue: 0.48),
            Color(red: 0.2, green: 0.08, blue: 0.3)
        ]
        }
    }
    
    var body: some View {
        ZStack {
            // 基础渐变
            RoundedRectangle(cornerRadius: 22)
                .fill(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
            
            // 玻璃覆盖层
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.1), .white.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    ZStack {
                        Circle().fill(.white.opacity(0.08)).frame(width: 160, height: 160).offset(x: 60, y: -50)
                        Circle().fill(.white.opacity(0.04)).frame(width: 120, height: 120).offset(x: -40, y: 70)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: gradientColors[0].opacity(0.4), radius: 25, x: 0, y: 10)
            
            // 内容
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: account.type.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                    Spacer()
                    if !account.cardNumber.isEmpty {
                        HStack(spacing: 2) {
                            Text("\u{2022}\u{2022}\u{2022}\u{2022}")
                                .font(.system(.callout, design: .monospaced))
                            Text(account.cardNumber.suffix(4))
                                .font(.system(.callout, design: .monospaced))
                        }
                        .foregroundColor(.white.opacity(0.75))
                    } else {
                        Text(account.type.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                Text(account.cardholderName.isEmpty ? "持卡人" : account.cardholderName.uppercased())
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(account.formattedBalance)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Text(account.name)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                    Spacer()
                    Text(account.currency.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .foregroundColor(.white.opacity(0.75))
                }
            }
            .padding(16)
        }
        .scaleEffect(isPressed ? 0.95 : 1)
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}

// MARK: - 小卡片
struct AccountMiniCard: View {
    let account: Account
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.22, blue: 0.35),
                                Color(red: 0.16, green: 0.18, blue: 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                Image(systemName: account.type.icon)
                    .font(.title3)
                    .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(account.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(account.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Spacer()
            
            Text(account.formattedBalance)
                .fontWeight(.bold)
                .foregroundColor(account.balance >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                .font(.system(.body, design: .rounded))
        }
        .padding(14)
        .background(Color(red: 0.1, green: 0.11, blue: 0.18))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        )
    }
}

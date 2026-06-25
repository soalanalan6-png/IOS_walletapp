import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var accountVM: AccountViewModel
    @EnvironmentObject private var liabilityVM: LiabilityViewModel
    
    var netWorth: Double { accountVM.totalBalance - liabilityVM.totalLiability }
    private let cardHeight: CGFloat = 190
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text("总资产")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(String(format: "$%.2f", accountVM.totalBalance))
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 2)
                        
                        HStack(spacing: 20) {
                            Label(
                                String(format: "负债 $%.2f", liabilityVM.totalLiability),
                                systemImage: "arrow.down.forward"
                            )
                            .font(.caption)
                            .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                            
                            Label(
                                "净资产 " + (netWorth >= 0 ? String(format: "$%.2f", netWorth) : String(format: "-$%.2f", abs(netWorth))),
                                systemImage: netWorth >= 0 ? "arrow.up.forward" : "exclamationmark.triangle"
                            )
                            .font(.caption)
                            .foregroundColor(netWorth >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : .orange)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    if !accountVM.accounts.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -24) {
                                ForEach(accountVM.accounts) { account in
                                    NavigationLink(destination: AccountDetailView(account: account)) {
                                        DashboardBankCard(account: account)
                                            .frame(width: 300, height: cardHeight)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                        }
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.15, green: 0.2, blue: 0.45).opacity(0.5),
                                            Color(red: 0.08, green: 0.1, blue: 0.25).opacity(0.5)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(.white.opacity(0.08), lineWidth: 1)
                                )
                            
                            VStack(spacing: 10) {
                                Image(systemName: "creditcard")
                                    .font(.system(size: 32))
                                    .foregroundColor(.white.opacity(0.3))
                                Text("添加你的第一个账户")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        .frame(height: cardHeight)
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("最近账户")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        
                        if accountVM.accounts.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "creditcard")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.2))
                                Text("暂无账户")
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ForEach(accountVM.accounts.prefix(5)) { account in
                                NavigationLink(destination: AccountDetailView(account: account)) {
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(red: 0.2, green: 0.22, blue: 0.35))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: account.type.icon)
                                                .font(.title3)
                                                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(account.name)
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                            Text(account.type.rawValue)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.4))
                                        }
                                        Spacer()
                                        Text(account.formattedBalance)
                                            .fontWeight(.semibold)
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(account.balance >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                }
                                .buttonStyle(.plain)
                                
                                if account.id != accountVM.accounts.prefix(5).last?.id {
                                    Divider()
                                        .background(.white.opacity(0.06))
                                        .padding(.leading, 72)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .background(Color(red: 0.1, green: 0.11, blue: 0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.05), lineWidth: 1)
                            .padding(.horizontal)
                    )
                }
                .padding(.vertical)
            }
            .background(Color(red: 0.04, green: 0.05, blue: 0.1))
            .navigationTitle("总览")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

struct DashboardBankCard: View {
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
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
            
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    ZStack {
                        Circle().fill(.white.opacity(0.08)).frame(width: 180, height: 180).offset(x: 70, y: -60)
                        Circle().fill(.white.opacity(0.04)).frame(width: 130, height: 130).offset(x: -50, y: 80)
                        Circle().fill(.white.opacity(0.03)).frame(width: 80, height: 80).offset(x: 40, y: 60)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.18), lineWidth: 1)
                )
            
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
                    .foregroundColor(.white.opacity(0.65))
                
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
            .padding(18)
        }
        .scaleEffect(isPressed ? 0.96 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}

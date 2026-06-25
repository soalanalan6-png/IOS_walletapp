import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var accountVM: AccountViewModel
    @EnvironmentObject private var liabilityVM: LiabilityViewModel
    
    var netWorth: Double { accountVM.totalBalance - liabilityVM.totalLiability }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // 净值卡片
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.15, green: 0.2, blue: 0.45),
                                        Color(red: 0.08, green: 0.1, blue: 0.25)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.3), radius: 30, x: 0, y: 10)
                        
                        VStack(spacing: 4) {
                            Text("净资产")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(netWorth >= 0 ?
                                 String(format: "$%.2f", netWorth) :
                                 String(format: "-$%.2f", abs(netWorth)))
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(netWorth >= 0 ? "📈 健康" : "⚠️ 需注意")
                                .font(.caption)
                                .foregroundColor(netWorth >= 0 ? .green : .orange)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .padding(.top, 4)
                        }
                        .padding(24)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // 资产/负债 卡片
                    HStack(spacing: 16) {
                        GlassCard(
                            title: "总资产",
                            amount: accountVM.totalBalance,
                            icon: "arrow.up.forward",
                            color: Color(red: 0.3, green: 0.85, blue: 0.6),
                            accentColor: Color(red: 0.3, green: 0.85, blue: 0.6).opacity(0.2)
                        )
                        GlassCard(
                            title: "总负债",
                            amount: liabilityVM.totalLiability,
                            icon: "arrow.down.forward",
                            color: Color(red: 1.0, green: 0.35, blue: 0.35),
                            accentColor: Color(red: 1.0, green: 0.35, blue: 0.35).opacity(0.2)
                        )
                    }
                    .padding(.horizontal)
                    
                    // 最近账户
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Image(systemName: "rectangle.stack.fill")
                                .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                            Text("最近账户")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        
                        if accountVM.accounts.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "creditcard")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.3))
                                Text("暂无账户")
                                    .foregroundColor(.white.opacity(0.5))
                                Text("点击右上角 + 添加")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ForEach(accountVM.accounts.prefix(5)) { account in
                                HStack {
                                    Image(systemName: account.type.icon)
                                        .font(.title2)
                                        .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1.0))
                                        .frame(width: 44, height: 44)
                                        .background(Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(account.name)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                        Text(account.type.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    Spacer()
                                    Text(account.formattedBalance)
                                        .fontWeight(.semibold)
                                        .foregroundColor(account.balance >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                
                                if account.id != accountVM.accounts.prefix(5).last?.id {
                                    Divider()
                                        .background(.white.opacity(0.08))
                                        .padding(.leading, 72)
                                }
                            }
                        }
                    }
                    .background(Color(red: 0.12, green: 0.13, blue: 0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(red: 0.06, green: 0.07, blue: 0.13))
            .navigationTitle("总览")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

struct GlassCard: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    let accentColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.13, blue: 0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(accentColor)
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                
                Text(String(format: "$%.2f", amount))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(20)
        }
    }
}

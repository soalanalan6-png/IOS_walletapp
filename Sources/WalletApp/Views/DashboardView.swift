import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var accountVM: AccountViewModel
    @EnvironmentObject private var liabilityVM: LiabilityViewModel
    
    var netWorth: Double {
        accountVM.totalBalance - liabilityVM.totalLiability
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 净值卡片
                    VStack(spacing: 8) {
                        Text("净资产")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(netWorth >= 0 ? 
                             String(format: "$%.2f", netWorth) :
                             String(format: "-$%.2f", abs(netWorth)))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(netWorth >= 0 ? .green : .red)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // 资产/负债概况
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "总资产",
                            amount: accountVM.totalBalance,
                            color: .green,
                            icon: "arrow.up.forward"
                        )
                        SummaryCard(
                            title: "总负债",
                            amount: liabilityVM.totalLiability,
                            color: .red,
                            icon: "arrow.down.forward"
                        )
                    }
                    .padding(.horizontal)
                    
                    // 最近账户
                    VStack(alignment: .leading, spacing: 12) {
                        Text("账户")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if accountVM.accounts.isEmpty {
                            Text("暂无账户，点击下方添加")
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(accountVM.accounts.prefix(5)) { account in
                                HStack {
                                    Image(systemName: account.type.icon)
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                        .frame(width: 40)
                                    VStack(alignment: .leading) {
                                        Text(account.name)
                                            .fontWeight(.medium)
                                        Text(account.type.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(account.formattedBalance)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("总览")
        }
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "$%.2f", amount))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

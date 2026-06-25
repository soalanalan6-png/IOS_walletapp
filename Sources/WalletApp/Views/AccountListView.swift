import SwiftUI

struct AccountListView: View {
    @EnvironmentObject private var vm: AccountViewModel
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.06, green: 0.07, blue: 0.13)
                    .ignoresSafeArea()
                
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
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.accounts) { account in
                                NavigationLink(destination: AccountDetailView(account: account)) {
                                    AccountCard(account: account)
                                }
                                .buttonStyle(.plain)
                            }
                            .onDelete { indexSet in
                                for i in indexSet {
                                    vm.deleteAccount(vm.accounts[i])
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("账户")
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

struct AccountCard: View {
    let account: Account
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.25, blue: 0.55),
                                Color(red: 0.15, green: 0.18, blue: 0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: account.type.icon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(account.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                if !account.cardNumber.isEmpty {
                    Text("**** \(account.cardNumber.suffix(4))")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            
            Spacer()
            
            Text(account.formattedBalance)
                .fontWeight(.bold)
                .foregroundColor(account.balance >= 0 ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                .font(.system(.body, design: .rounded))
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.13, blue: 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

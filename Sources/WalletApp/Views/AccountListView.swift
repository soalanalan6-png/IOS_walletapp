import SwiftUI

struct AccountListView: View {
    @EnvironmentObject private var vm: AccountViewModel
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                if vm.accounts.isEmpty {
                    ContentUnavailableView(
                        "暂无账户",
                        systemImage: "creditcard",
                        description: Text("点击右上角 + 添加账户")
                    )
                }
                ForEach(vm.accounts) { account in
                    NavigationLink(destination: AccountDetailView(account: account)) {
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
                                if !account.cardNumber.isEmpty {
                                    Text("**** \(account.cardNumber.suffix(4))")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Text(account.formattedBalance)
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        vm.deleteAccount(vm.accounts[i])
                    }
                }
            }
            .navigationTitle("账户")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddAccountView()
            }
        }
    }
}

import SwiftUI

struct LiabilityListView: View {
    @EnvironmentObject private var vm: LiabilityViewModel
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                if vm.liabilities.isEmpty {
                    ContentUnavailableView(
                        "暂无负债",
                        systemImage: "arrow.down.forward",
                        description: Text("点击右上角 + 添加负债记录")
                    )
                }
                ForEach(vm.liabilities) { liability in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(liability.name)
                                .fontWeight(.medium)
                                .strikethrough(liability.isPaid)
                            if !liability.creditor.isEmpty {
                                Text(liability.creditor)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            if let due = liability.dueDate {
                                Text("到期: \(due.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(liability.formattedAmount)
                                .fontWeight(.semibold)
                                .foregroundColor(liability.isPaid ? .green : .red)
                            if liability.isPaid {
                                Text("已还清")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .opacity(liability.isPaid ? 0.6 : 1)
                    .swipeActions(edge: .leading) {
                        Button(liability.isPaid ? "未还" : "还清") {
                            vm.togglePaid(liability)
                        }
                        .tint(liability.isPaid ? .orange : .green)
                    }
                }
                .onDelete { indexSet in
                    for i in indexSet {
                        vm.deleteLiability(vm.liabilities[i])
                    }
                }
            }
            .navigationTitle("负债")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddLiabilityView()
            }
        }
    }
}

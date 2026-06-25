import SwiftUI

struct LiabilityListView: View {
    @EnvironmentObject private var vm: LiabilityViewModel
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.05, blue: 0.1)
                    .ignoresSafeArea()
                
                if vm.liabilities.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "arrow.down.forward")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.15))
                        Text("暂无负债")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                        Text("点击右上角 + 添加负债记录")
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.liabilities) { liability in
                                LiabilityCard(liability: liability, onToggle: { vm.togglePaid(liability) })
                            }
                            .onDelete { indexSet in
                                for i in indexSet { vm.deleteLiability(vm.liabilities[i]) }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("负债")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 1.0, green: 0.35, blue: 0.35))
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddLiabilityView()
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct LiabilityCard: View {
    let liability: Liability
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: liability.isPaid ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(liability.isPaid ? Color(red: 0.3, green: 0.85, blue: 0.6) : .white.opacity(0.3))
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(liability.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .strikethrough(liability.isPaid)
                
                if !liability.creditor.isEmpty {
                    Text(liability.creditor)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
                
                if let due = liability.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(due.formatted(date: .abbreviated, time: .omitted))
                    }
                    .font(.caption2)
                    .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(liability.formattedAmount)
                    .fontWeight(.bold)
                    .foregroundColor(liability.isPaid ? Color(red: 0.3, green: 0.85, blue: 0.6) : Color(red: 1.0, green: 0.35, blue: 0.35))
                    .font(.system(.body, design: .rounded))
                
                if liability.isPaid {
                    Text("已还清")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.3, green: 0.85, blue: 0.6))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(red: 0.3, green: 0.85, blue: 0.6).opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(14)
        .background(Color(red: 0.1, green: 0.11, blue: 0.18))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        )
        .opacity(liability.isPaid ? 0.6 : 1)
    }
}

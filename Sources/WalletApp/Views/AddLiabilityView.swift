import SwiftUI

struct AddLiabilityView: View {
    @EnvironmentObject private var vm: LiabilityViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var amount: Double = 0
    @State private var currency: Currency = .usd
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var creditor = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    HStack {
                        Text("名称")
                        Spacer()
                        TextField("负债名称", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("金额")
                        Spacer()
                        TextField("0.00", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("货币", selection: $currency) {
                        ForEach(Currency.allCases) { c in
                            Text("\(c.flag) \(c.rawValue)").tag(c)
                        }
                    }
                }
                
                Section("详细信息") {
                    HStack {
                        Text("债权人")
                        Spacer()
                        TextField("债权人/机构", text: $creditor)
                            .multilineTextAlignment(.trailing)
                    }
                    Toggle("设置到期日", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("到期日", selection: $dueDate, displayedComponents: .date)
                    }
                }
                
                Section("备注") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                }
            }
            .navigationTitle("添加负债")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        let liability = Liability(
                            name: name.isEmpty ? "新负债" : name,
                            amount: amount,
                            currency: currency,
                            dueDate: hasDueDate ? dueDate : nil,
                            creditor: creditor,
                            notes: notes
                        )
                        vm.addLiability(liability)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

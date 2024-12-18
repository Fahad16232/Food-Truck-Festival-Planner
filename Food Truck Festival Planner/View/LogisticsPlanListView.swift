import SwiftUI

// MARK: - LogisticsPlanListView
struct LogisticsPlanListView: View {
    @EnvironmentObject var logisticsPlanManager: LogisticsPlanManager
    @State private var selectedPlan: LogisticsPlan? = nil
    @State private var showAddEditView = false

    var body: some View {
        NavigationView {
            VStack {
                if logisticsPlanManager.logisticsPlans.isEmpty {
                    Text("No Logistics Plans Available")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(logisticsPlanManager.logisticsPlans) { plan in
                            Button(action: {
                                selectedPlan = plan
                                showAddEditView = true
                            }) {
                                LogisticsPlanCardView(plan: plan)
                            }
                        }
                        .onDelete(perform: deletePlan)
                    }
                }
            }
            .navigationTitle("Logistics Management")
            .navigationBarItems(
                trailing: Button(action: {
                    selectedPlan = nil
                    showAddEditView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            )
            .sheet(isPresented: $showAddEditView) {
                AddEditLogisticsPlanView(
                    logisticsPlanManager: logisticsPlanManager,
                    logisticsPlan: $selectedPlan
                )
            }
        }
    }

    private func deletePlan(at offsets: IndexSet) {
        for index in offsets {
            let plan = logisticsPlanManager.logisticsPlans[index]
            logisticsPlanManager.deleteLogisticsPlan(by: plan.id)
        }
    }
}


import SwiftUI

// MARK: - LogisticsPlanCardView
struct LogisticsPlanCardView: View {
    let plan: LogisticsPlan

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(plan.truckName)
                .font(.headline)
                .foregroundColor(.white)

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.white)
                Text("Delivery Date: \(formattedDate(plan.deliveryDate))")
                    .foregroundColor(.white.opacity(0.9))
            }

            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.white)
                Text("Arrival Time: \(plan.arrivalTime)")
                    .foregroundColor(.white.opacity(0.9))
            }

            HStack {
                Image(systemName: "map")
                    .foregroundColor(.white)
                Text("Booth: \(plan.boothAssignment) | Zone: \(plan.parkingZone)")
                    .foregroundColor(.white.opacity(0.9))
            }

            if plan.securityClearance {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(.green)
                    Text("Security Clearance: Approved")
                        .foregroundColor(.white)
                }
            } else {
                HStack {
                    Image(systemName: "xmark.shield.fill")
                        .foregroundColor(.red)
                    Text("Security Clearance: Pending")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#6A5ACD"), Color(hex: "#836FFF")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

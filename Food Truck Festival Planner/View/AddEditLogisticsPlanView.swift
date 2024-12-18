import SwiftUI

// MARK: - AddEditLogisticsPlanView
struct AddEditLogisticsPlanView: View {
    @ObservedObject var logisticsPlanManager: LogisticsPlanManager
    @Binding var logisticsPlan: LogisticsPlan?

    // State variables for form fields
    @State private var truckName = ""
    @State private var deliveryDate = Date()
    @State private var arrivalTime = ""
    @State private var boothAssignment = ""
    @State private var parkingZone = ""
    @State private var setupRequirements = [String]()
    @State private var securityClearance = false
    @State private var logisticsContact = ""
    @State private var logisticsNotes = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode

    let parkingZones = ["Zone A", "Zone B", "Zone C", "Zone D"]
    let setupOptions = [
        "Electricity",
        "Water Supply",
        "Waste Disposal",
        "Security Personnel",
        "Signage",
        "Wi-Fi Access",
        "Parking Passes",
        "Lighting",
        "Sound System",
        "Stage Setup",
        "Refrigeration",
        "Tent or Canopy",
        "Seating Arrangement",
        "Fire Extinguisher",
        "First Aid Kit",
        "Power Backup",
        "Cleaning Services",
        "On-Site Technician",
        "Handwashing Stations",
        "Portable Toilets"
    ]

    var body: some View {
        NavigationView {
            Form {
                // Truck Details Section
                Section(header: Text("Truck Details")) {
                    TextField("Truck Name", text: $truckName)
                    TextField("Arrival Time (e.g., 9:00 AM)", text: $arrivalTime)
                        .keyboardType(.default)
                }

                // Location & Schedule Section
                Section(header: Text("Location & Schedule")) {
                    DatePicker("Delivery Date", selection: $deliveryDate, displayedComponents: .date)
                    TextField("Booth Assignment", text: $boothAssignment)
                    Picker("Parking Zone", selection: $parkingZone) {
                        ForEach(parkingZones, id: \.self) { zone in
                            Text(zone)
                        }
                    }
                }

                // Setup Requirements Section
                Section(header: Text("Setup Requirements")) {
                    MultiSelectView(options: setupOptions, selectedItems: $setupRequirements)
                }

                // Security & Contact Section
                Section(header: Text("Security & Contact")) {
                    Toggle("Security Clearance", isOn: $securityClearance)
                    TextField("Logistics Contact", text: $logisticsContact)
                        .keyboardType(.phonePad)
                }

                // Notes Section
                Section(header: Text("Additional Notes")) {
                    TextField("Logistics Notes", text: $logisticsNotes)
                }
            }
            .navigationBarTitle(logisticsPlan == nil ? "Add Logistics Plan" : "Edit Logistics Plan", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveLogisticsPlan()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Fields"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: loadLogisticsPlanData)
        }
    }

    // MARK: - Load Existing Data
    private func loadLogisticsPlanData() {
        if let existingPlan = logisticsPlan {
            truckName = existingPlan.truckName
            deliveryDate = existingPlan.deliveryDate
            arrivalTime = existingPlan.arrivalTime
            boothAssignment = existingPlan.boothAssignment
            parkingZone = existingPlan.parkingZone
            setupRequirements = existingPlan.setupRequirements
            securityClearance = existingPlan.securityClearance
            logisticsContact = existingPlan.logisticsContact
            logisticsNotes = existingPlan.logisticsNotes ?? ""
        } else {
            parkingZone = parkingZones.first ?? ""
        }
    }

    // MARK: - Save Logistics Plan
    private func saveLogisticsPlan() {
        guard !truckName.isEmpty, !arrivalTime.isEmpty, !boothAssignment.isEmpty, !logisticsContact.isEmpty else {
            alertMessage = "Please fill in all required fields."
            showAlert = true
            return
        }

        let newPlan = LogisticsPlan(
            id: logisticsPlan?.id ?? UUID(),
            truckName: truckName,
            deliveryDate: deliveryDate,
            arrivalTime: arrivalTime,
            boothAssignment: boothAssignment,
            parkingZone: parkingZone,
            setupRequirements: setupRequirements,
            securityClearance: securityClearance,
            logisticsContact: logisticsContact,
            logisticsNotes: logisticsNotes.isEmpty ? nil : logisticsNotes
        )

        if logisticsPlan != nil {
            logisticsPlanManager.updateLogisticsPlan(newPlan)
        } else {
            logisticsPlanManager.addLogisticsPlan(newPlan)
        }

        presentationMode.wrappedValue.dismiss()
    }
}



import SwiftUI

struct MultiSelectView: View {
    let options: [String]
    @Binding var selectedItems: [String]

    var body: some View {
        NavigationLink(destination: MultiSelectListView(options: options, selectedItems: $selectedItems)) {
            HStack {
                Text("Setup Requirements")
                Spacer()
                Text(selectedItems.isEmpty ? "Select" : selectedItems.joined(separator: ", "))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
    }
}

struct MultiSelectListView: View {
    let options: [String]
    @Binding var selectedItems: [String]
    @State private var tempSelection: Set<String> = []

    var body: some View {
        List {
            ForEach(options, id: \.self) { option in
                MultipleSelectionRow(title: option, isSelected: tempSelection.contains(option)) {
                    if tempSelection.contains(option) {
                        tempSelection.remove(option)
                    } else {
                        tempSelection.insert(option)
                    }
                }
            }
        }
        .onAppear {
            tempSelection = Set(selectedItems)
        }
        .onDisappear {
            selectedItems = Array(tempSelection)
        }
        .navigationTitle("Select Requirements")
    }
}

struct MultipleSelectionRow: View {
    let title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

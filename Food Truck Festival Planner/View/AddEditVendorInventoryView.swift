import SwiftUI

// MARK: - AddEditVendorInventoryView
struct AddEditVendorInventoryView: View {
    @ObservedObject var vendorInventoryManager: VendorInventoryManager
    @Binding var inventory: VendorInventory?

    // State variables for form fields
    @State private var truckName = ""
    @State private var supplierName = ""
    @State private var supplierContact = ""
    @State private var lastRestockedDate = Date()
    @State private var nextRestockDate = Date()
    @State private var inventoryNotes = ""

    @State private var inventoryItems: [InventoryItem] = []
    @State private var showAddItemView = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Truck & Supplier Details")) {
                    TextField("Truck Name", text: $truckName)
                    TextField("Supplier Name", text: $supplierName)
                    TextField("Supplier Contact", text: $supplierContact)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Restock Information")) {
                    DatePicker("Last Restocked Date", selection: $lastRestockedDate, displayedComponents: .date)
                    DatePicker("Next Restock Date", selection: $nextRestockDate, displayedComponents: .date)
                }

                Section(header: Text("Inventory Items")) {
                    if inventoryItems.isEmpty {
                        Text("No items added yet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(inventoryItems) { item in
                            VStack(alignment: .leading) {
                                Text(item.itemName)
                                    .font(.headline)
                                HStack {
                                    Text("Quantity: \(item.quantity)")
                                    Spacer()
                                    Text("Unit: \(item.unit)")
                                }
                                if let expirationDate = item.expirationDate {
                                    Text("Expires on: \(formattedDate(expirationDate))")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: deleteItem)
                    }
                    Button(action: { showAddItemView = true }) {
                        Label("Add Item", systemImage: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }

                Section(header: Text("Notes")) {
                    TextField("Additional Notes", text: $inventoryNotes)
                }
            }
            .navigationBarTitle(inventory == nil ? "Add Inventory" : "Edit Inventory", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveInventory()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Fields"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showAddItemView) {
                AddInventoryItemView { newItem in
                    inventoryItems.append(newItem)
                }
            }
            .onAppear(perform: loadInventoryData)
        }
    }

    private func loadInventoryData() {
        if let existingInventory = inventory {
            truckName = existingInventory.truckName
            supplierName = existingInventory.supplierName
            supplierContact = existingInventory.supplierContact
            lastRestockedDate = existingInventory.lastRestockedDate
            nextRestockDate = existingInventory.nextRestockDate ?? Date()
            inventoryNotes = existingInventory.inventoryNotes ?? ""
            inventoryItems = existingInventory.inventoryItems
        }
    }

    private func saveInventory() {
        guard !truckName.isEmpty, !supplierName.isEmpty, !supplierContact.isEmpty else {
            alertMessage = "Please fill in all required fields."
            showAlert = true
            return
        }

        let newInventory = VendorInventory(
            id: inventory?.id ?? UUID(),
            truckName: truckName,
            inventoryItems: inventoryItems,
            lastRestockedDate: lastRestockedDate,
            nextRestockDate: nextRestockDate,
            supplierName: supplierName,
            supplierContact: supplierContact,
            inventoryNotes: inventoryNotes.isEmpty ? nil : inventoryNotes
        )

        if inventory != nil {
            vendorInventoryManager.updateVendorInventory(newInventory)
        } else {
            vendorInventoryManager.addVendorInventory(newInventory)
        }

        presentationMode.wrappedValue.dismiss()
    }

    private func deleteItem(at offsets: IndexSet) {
        inventoryItems.remove(atOffsets: offsets)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}



import SwiftUI

// MARK: - AddInventoryItemView
struct AddInventoryItemView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var itemName = ""
    @State private var quantity = ""
    @State private var unit = "Packets"
    @State private var isPerishable = false
    @State private var expirationDate = Date()

    let units = ["Packets", "Liters", "Boxes", "Kilograms", "Units"]

    var onSave: (InventoryItem) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $itemName)
                    TextField("Quantity", text: $quantity)
                        .keyboardType(.numberPad)
                    Picker("Unit", selection: $unit) {
                        ForEach(units, id: \.self) { Text($0) }
                    }
                }

                Section(header: Text("Additional Info")) {
                    Toggle("Is Perishable?", isOn: $isPerishable)
                    if isPerishable {
                        DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                    }
                }
            }
            .navigationBarTitle("Add Inventory Item", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveItem()
                }
            )
        }
    }

    private func saveItem() {
        guard let qty = Int(quantity), !itemName.isEmpty else {
            return
        }

        let newItem = InventoryItem(
            itemName: itemName,
            quantity: qty,
            unit: unit,
            isPerishable: isPerishable,
            expirationDate: isPerishable ? expirationDate : nil
        )

        onSave(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}

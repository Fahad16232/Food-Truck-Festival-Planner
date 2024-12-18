import SwiftUI

// MARK: - VendorInventoryListView
struct VendorInventoryListView: View {
    @EnvironmentObject var vendorInventoryManager: VendorInventoryManager
    @State private var selectedInventory: VendorInventory?
    @State private var showAddEditView = false

    var body: some View {
        NavigationView {
            VStack {
                if vendorInventoryManager.vendorInventories.isEmpty {
                    Text("No Vendor Inventories Available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(vendorInventoryManager.vendorInventories) { inventory in
                            Button(action: {
                                selectedInventory = inventory
                                showAddEditView = true
                            }) {
                                VendorInventoryCardView(inventory: inventory)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: deleteInventory)
                    }
                }
            }
            .navigationBarTitle("Vendor Inventories")
            .navigationBarItems(
                trailing: Button(action: {
                    selectedInventory = nil
                    showAddEditView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            )
            .sheet(isPresented: $showAddEditView) {
                AddEditVendorInventoryView(vendorInventoryManager: vendorInventoryManager, inventory: $selectedInventory)
            }
        }
    }

    private func deleteInventory(at offsets: IndexSet) {
        offsets.forEach { index in
            let inventory = vendorInventoryManager.vendorInventories[index]
            vendorInventoryManager.deleteVendorInventory(by: inventory.id)
        }
    }
}



import SwiftUI

// MARK: - VendorInventoryCardView
struct VendorInventoryCardView: View {
    let inventory: VendorInventory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Truck and Supplier Information
            HStack {
                Image(systemName: "truck.box.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                Text(inventory.truckName)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white.opacity(0.9))
                Text("Supplier: \(inventory.supplierName)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }

            // Last Restocked Date
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.white.opacity(0.9))
                Text("Last Restocked: \(formattedDate(inventory.lastRestockedDate))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }

            // Next Restock Date (if available)
            if let nextRestockDate = inventory.nextRestockDate {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.white.opacity(0.9))
                    Text("Next Restock: \(formattedDate(nextRestockDate))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }

            // Inventory Items Count
            HStack {
                Image(systemName: "list.bullet")
                    .foregroundColor(.white.opacity(0.9))
                Text("Items in Inventory: \(inventory.inventoryItems.count)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }

            // Notes (if available)
            if let notes = inventory.inventoryNotes, !notes.isEmpty {
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(.white.opacity(0.9))
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
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
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
        .padding(.vertical, 8)
    }

    // Helper function to format dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


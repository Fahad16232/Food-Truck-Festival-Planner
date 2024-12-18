import Foundation
import SwiftUI

// MARK: - VendorInventoryManager Class
class VendorInventoryManager: ObservableObject {
    @Published private(set) var vendorInventories: [VendorInventory] = [] {
        didSet {
            saveToUserDefaults()
        }
    }

    private let userDefaultsKey = "VendorInventoriesData"

    // MARK: - Initializer
    init() {
        loadFromUserDefaults()
    }

    // MARK: - CRUD Operations

    /// Add a new vendor inventory
    func addVendorInventory(_ inventory: VendorInventory) {
        vendorInventories.append(inventory)
    }

    /// Update an existing vendor inventory
    func updateVendorInventory(_ updatedInventory: VendorInventory) {
        if let index = vendorInventories.firstIndex(where: { $0.id == updatedInventory.id }) {
            vendorInventories[index] = updatedInventory
        }
    }

    /// Delete a vendor inventory by ID
    func deleteVendorInventory(by id: UUID) {
        vendorInventories.removeAll { $0.id == id }
    }

    /// Retrieve a vendor inventory by ID
    func getVendorInventory(by id: UUID) -> VendorInventory? {
        return vendorInventories.first { $0.id == id }
    }

    /// Clear all vendor inventories
    func clearAllVendorInventories() {
        vendorInventories.removeAll()
    }

    // MARK: - Persistence with UserDefaults

    /// Save vendor inventories to UserDefaults
    private func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(vendorInventories) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    /// Load vendor inventories from UserDefaults
    private func loadFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedInventories = try? JSONDecoder().decode([VendorInventory].self, from: savedData) {
            vendorInventories = decodedInventories
        }
    }

    // MARK: - Utility Functions

    /// Filter inventories by truck name
    func filterInventoriesByTruckName(_ truckName: String) -> [VendorInventory] {
        return vendorInventories.filter { $0.truckName.lowercased().contains(truckName.lowercased()) }
    }

    /// Search inventories by supplier name or contact
    func searchInventories(byQuery query: String) -> [VendorInventory] {
        return vendorInventories.filter {
            $0.supplierName.lowercased().contains(query.lowercased()) ||
            $0.supplierContact.lowercased().contains(query.lowercased())
        }
    }

    /// Get inventories that have perishable items
    func inventoriesWithPerishableItems() -> [VendorInventory] {
        return vendorInventories.filter { inventory in
            inventory.inventoryItems.contains { $0.isPerishable }
        }
    }

    /// Get items that need restocking based on quantity threshold
    func itemsNeedingRestock(threshold: Int) -> [InventoryItem] {
        return vendorInventories.flatMap { $0.inventoryItems }.filter { $0.quantity <= threshold }
    }
}

import Foundation
import SwiftUI

// MARK: - FoodTruckManager Class
class FoodTruckManager: ObservableObject {
    @Published private(set) var foodTrucks: [FoodTruck] = [] {
        didSet {
            saveToUserDefaults()
        }
    }

    private let userDefaultsKey = "FoodTrucksData"

    // MARK: - Initializer
    init() {
        loadFromUserDefaults()
    }

    // MARK: - CRUD Operations

    /// Add a new food truck
    func addFoodTruck(_ foodTruck: FoodTruck) {
        foodTrucks.append(foodTruck)
    }

    /// Update an existing food truck
    func updateFoodTruck(_ updatedFoodTruck: FoodTruck) {
        if let index = foodTrucks.firstIndex(where: { $0.id == updatedFoodTruck.id }) {
            foodTrucks[index] = updatedFoodTruck
        }
    }

    /// Delete a food truck by ID
    func deleteFoodTruck(by id: UUID) {
        foodTrucks.removeAll { $0.id == id }
    }

    /// Retrieve a food truck by ID
    func getFoodTruck(by id: UUID) -> FoodTruck? {
        return foodTrucks.first { $0.id == id }
    }

    /// Clear all food trucks
    func clearAllFoodTrucks() {
        foodTrucks.removeAll()
    }

    // MARK: - Persistence with UserDefaults

    /// Save food trucks to UserDefaults
    private func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(foodTrucks) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    /// Load food trucks from UserDefaults
    private func loadFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedFoodTrucks = try? JSONDecoder().decode([FoodTruck].self, from: savedData) {
            foodTrucks = decodedFoodTrucks
        }
    }

    // MARK: - Utility Functions

    /// Filter food trucks by cuisine type
    func filterByCuisineType(_ cuisineType: String) -> [FoodTruck] {
        return foodTrucks.filter { $0.cuisineType.lowercased() == cuisineType.lowercased() }
    }

    /// Search food trucks by name, owner, or specialty dish
    func searchFoodTrucks(byQuery query: String) -> [FoodTruck] {
        return foodTrucks.filter {
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.ownerName.lowercased().contains(query.lowercased()) ||
            $0.specialtyDish.lowercased().contains(query.lowercased())
        }
    }

    /// Get food trucks that use eco-friendly packaging
    func ecoFriendlyTrucks() -> [FoodTruck] {
        return foodTrucks.filter { $0.isEcoFriendly }
    }
}

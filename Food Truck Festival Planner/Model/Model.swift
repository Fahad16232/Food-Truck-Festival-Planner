import Foundation

// MARK: - Food Truck Model (First Tab: Food Trucks)
struct FoodTruck: Identifiable, Codable {
    var id = UUID()
    var name: String
    var cuisineType: String // e.g., "Mexican", "Italian", "BBQ"
    var specialtyDish: String // Highlighted specialty dish, e.g., "BBQ Ribs"
    var menuItems: [String] // e.g., ["Tacos", "Burritos", "Nachos"]
    var ownerName: String
    var contactEmail: String
    var contactNumber: String
    var socialMediaLinks: [String: String] // e.g., ["Instagram": "@foodtruck"]
    var operatingHours: String // e.g., "10:00 AM - 8:00 PM"
    var truckImageData: Data? // Photo of the food truck
    var foodAllergenInfo: String? // e.g., "Contains nuts, dairy"
    var isEcoFriendly: Bool // Indicates use of sustainable packaging
    var notes: String?
}

// MARK: - Festival Schedule Model (Second Tab: Festival Schedule)
struct FestivalEvent: Identifiable, Codable {
    var id = UUID()
    var eventName: String // e.g., "Live Music", "Opening Ceremony"
    var date: Date
    var startTime: String // e.g., "2:00 PM"
    var endTime: String // e.g., "4:00 PM"
    var location: String // e.g., "Main Stage", "Booth Area 5"
    var featuredTrucks: [String] // e.g., ["Tasty Tacos", "BBQ Heaven"]
    var entertainmentType: String // e.g., "Live Band", "DJ Set", "Kids Play Area"
    var hostName: String? // Name of the event host or MC
    var isTicketRequired: Bool
    var eventPosterImageData: Data? // Image for event poster
    var notes: String?
}

// MARK: - Vendor Inventory Model (Third Tab: Vendor Inventory)
struct VendorInventory: Identifiable, Codable {
    var id = UUID()
    var truckName: String
    var inventoryItems: [InventoryItem] // List of items with quantities
    var lastRestockedDate: Date
    var nextRestockDate: Date?
    var supplierName: String
    var supplierContact: String
    var inventoryNotes: String?
}

// Sub-model for individual inventory items
struct InventoryItem: Identifiable, Codable {
    var id = UUID()
    var itemName: String // e.g., "Burger Buns", "Salsa"
    var quantity: Int
    var unit: String // e.g., "Packets", "Liters", "Boxes"
    var isPerishable: Bool
    var expirationDate: Date?
}

// MARK: - Logistics Management Model (Fourth Tab: Logistics Management)
struct LogisticsPlan: Identifiable, Codable {
    var id = UUID()
    var truckName: String
    var deliveryDate: Date
    var arrivalTime: String // e.g., "9:00 AM"
    var boothAssignment: String // e.g., "Booth #15"
    var parkingZone: String // e.g., "Zone A", "Zone B"
    var setupRequirements: [String] // e.g., ["Electricity", "Water Supply"]
    var securityClearance: Bool // Indicates if the truck has passed security checks
    var logisticsContact: String
    var logisticsNotes: String?
}

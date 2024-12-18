import SwiftUI

// MARK: - OverviewTabView
struct OverviewTabView: View {
    @EnvironmentObject var foodTruckManager: FoodTruckManager
    @EnvironmentObject var festivalEventManager: FestivalEventManager
    @EnvironmentObject var vendorInventoryManager: VendorInventoryManager
    @EnvironmentObject var logisticsPlanManager: LogisticsPlanManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Food Trucks Summary
                    SectionView(title: "Food Trucks", systemImage: "truck.box.fill", gradientColors: [Color(hex: "#FF7F50"), Color(hex: "#FF6347")]) {
                        SummaryRow(title: "Total Trucks", value: "\(foodTruckManager.foodTrucks.count)")
                        SummaryRow(title: "Eco-Friendly Trucks", value: "\(foodTruckManager.ecoFriendlyTrucks().count)")
                        SummaryRow(title: "Total Menu Items", value: "\(totalMenuItems())")
                    }

                    // Festival Events Summary
                    SectionView(title: "Festival Events", systemImage: "calendar", gradientColors: [Color(hex: "#6A5ACD"), Color(hex: "#836FFF")]) {
                        SummaryRow(title: "Total Events", value: "\(festivalEventManager.festivalEvents.count)")
                        SummaryRow(title: "Ticketed Events", value: "\(festivalEventManager.eventsRequiringTickets().count)")
                        SummaryRow(title: "Unique Entertainment Types", value: "\(uniqueEntertainmentTypes().count)")
                    }

                    // Vendor Inventory Summary
                    SectionView(title: "Vendor Inventory", systemImage: "shippingbox.fill", gradientColors: [Color(hex: "#20B2AA"), Color(hex: "#66CDAA")]) {
                        SummaryRow(title: "Total Inventories", value: "\(vendorInventoryManager.vendorInventories.count)")
                        SummaryRow(title: "Perishable Items", value: "\(vendorInventoryManager.inventoriesWithPerishableItems().count)")
                        SummaryRow(title: "Items Needing Restock", value: "\(itemsNeedingRestockCount())")
                    }

                    // Logistics Summary
                    SectionView(title: "Logistics Plans", systemImage: "map.fill", gradientColors: [Color(hex: "#4682B4"), Color(hex: "#5F9EA0")]) {
                        SummaryRow(title: "Total Plans", value: "\(logisticsPlanManager.logisticsPlans.count)")
                        SummaryRow(title: "Security Cleared Trucks", value: "\(logisticsPlanManager.plansWithSecurityClearance().count)")
                        SummaryRow(title: "Unique Parking Zones", value: "\(uniqueParkingZones().count)")
                    }
                }
                .padding()
            }
            .navigationTitle("Overview")
        }
    }

    // MARK: - Helper Methods

    /// Calculate total menu items across all food trucks
    private func totalMenuItems() -> Int {
        foodTruckManager.foodTrucks.reduce(0) { $0 + $1.menuItems.count }
    }

    /// Get unique entertainment types from festival events
    private func uniqueEntertainmentTypes() -> Set<String> {
        Set(festivalEventManager.festivalEvents.map { $0.entertainmentType })
    }

    /// Get total items needing restock based on a threshold of 5
    private func itemsNeedingRestockCount() -> Int {
        vendorInventoryManager.itemsNeedingRestock(threshold: 5).count
    }

    /// Get unique parking zones from logistics plans
    private func uniqueParkingZones() -> Set<String> {
        Set(logisticsPlanManager.logisticsPlans.map { $0.parkingZone })
    }
}

// MARK: - SectionView
struct SectionView<Content: View>: View {
    let title: String
    let systemImage: String
    let gradientColors: [Color]
    let content: Content

    init(title: String, systemImage: String, gradientColors: [Color], @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.gradientColors = gradientColors
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.white)
                    .font(.title)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(15)
            )

            VStack(spacing: 10) {
                content
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

// MARK: - SummaryRow
struct SummaryRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding(.vertical, 5)
    }
}



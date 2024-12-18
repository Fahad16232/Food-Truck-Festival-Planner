

import SwiftUI

@main
struct Food_Truck_Festival_PlannerApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}


import SwiftUI

// MARK: - TabBarView
struct TabBarView: View {
    @StateObject private var foodTruckManager = FoodTruckManager()
    @StateObject private var festivalEventManager = FestivalEventManager()
    @StateObject private var vendorInventoryManager = VendorInventoryManager()
    @StateObject private var logisticsPlanManager = LogisticsPlanManager()

    var body: some View {
        TabView {
            // Food Trucks Tab
            FoodTruckListView()
                .environmentObject(foodTruckManager)
                .tabItem {
                    Image(systemName: "truck.box.fill")
                    Text("Food Trucks")
                }

            // Festival Schedule Tab
            FestivalEventListView()
                .environmentObject(festivalEventManager)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Festival Schedule")
                }

            // Vendor Inventory Tab
            VendorInventoryListView()
                .environmentObject(vendorInventoryManager)
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Vendor Inventory")
                }

            // Logistics Tab
            LogisticsPlanListView()
                .environmentObject(logisticsPlanManager)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Logistics")
                }

            // Overview Tab
            OverviewTabView()
                .environmentObject(foodTruckManager)
                .environmentObject(festivalEventManager)
                .environmentObject(vendorInventoryManager)
                .environmentObject(logisticsPlanManager)
                .tabItem {
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                    Text("Overview")
                }
        }
    }
}

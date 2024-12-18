import Foundation
import SwiftUI

// MARK: - LogisticsPlanManager Class
class LogisticsPlanManager: ObservableObject {
    @Published private(set) var logisticsPlans: [LogisticsPlan] = [] {
        didSet {
            saveToUserDefaults()
        }
    }

    private let userDefaultsKey = "LogisticsPlansData"

    // MARK: - Initializer
    init() {
        loadFromUserDefaults()
    }

    // MARK: - CRUD Operations

    /// Add a new logistics plan
    func addLogisticsPlan(_ plan: LogisticsPlan) {
        logisticsPlans.append(plan)
    }

    /// Update an existing logistics plan
    func updateLogisticsPlan(_ updatedPlan: LogisticsPlan) {
        if let index = logisticsPlans.firstIndex(where: { $0.id == updatedPlan.id }) {
            logisticsPlans[index] = updatedPlan
        }
    }

    /// Delete a logistics plan by ID
    func deleteLogisticsPlan(by id: UUID) {
        logisticsPlans.removeAll { $0.id == id }
    }

    /// Retrieve a logistics plan by ID
    func getLogisticsPlan(by id: UUID) -> LogisticsPlan? {
        return logisticsPlans.first { $0.id == id }
    }

    /// Clear all logistics plans
    func clearAllLogisticsPlans() {
        logisticsPlans.removeAll()
    }

    // MARK: - Persistence with UserDefaults

    /// Save logistics plans to UserDefaults
    private func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(logisticsPlans) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    /// Load logistics plans from UserDefaults
    private func loadFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedPlans = try? JSONDecoder().decode([LogisticsPlan].self, from: savedData) {
            logisticsPlans = decodedPlans
        }
    }

    // MARK: - Utility Functions

    /// Filter logistics plans by truck name
    func filterPlansByTruckName(_ truckName: String) -> [LogisticsPlan] {
        return logisticsPlans.filter { $0.truckName.lowercased().contains(truckName.lowercased()) }
    }

    /// Search logistics plans by booth assignment or parking zone
    func searchPlans(byQuery query: String) -> [LogisticsPlan] {
        return logisticsPlans.filter {
            $0.boothAssignment.lowercased().contains(query.lowercased()) ||
            $0.parkingZone.lowercased().contains(query.lowercased())
        }
    }

    /// Get logistics plans that have passed security clearance
    func plansWithSecurityClearance() -> [LogisticsPlan] {
        return logisticsPlans.filter { $0.securityClearance }
    }

    /// Count logistics plans by parking zone
    func countPlansByParkingZone() -> [String: Int] {
        return logisticsPlans.reduce(into: [String: Int]()) { counts, plan in
            counts[plan.parkingZone, default: 0] += 1
        }
    }
}

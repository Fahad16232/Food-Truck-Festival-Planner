import Foundation
import SwiftUI

// MARK: - FestivalEventManager Class
class FestivalEventManager: ObservableObject {
    @Published private(set) var festivalEvents: [FestivalEvent] = [] {
        didSet {
            saveToUserDefaults()
        }
    }

    private let userDefaultsKey = "FestivalEventsData"

    // MARK: - Initializer
    init() {
        loadFromUserDefaults()
    }

    // MARK: - CRUD Operations

    /// Add a new festival event
    func addFestivalEvent(_ event: FestivalEvent) {
        festivalEvents.append(event)
    }

    /// Update an existing festival event
    func updateFestivalEvent(_ updatedEvent: FestivalEvent) {
        if let index = festivalEvents.firstIndex(where: { $0.id == updatedEvent.id }) {
            festivalEvents[index] = updatedEvent
        }
    }

    /// Delete a festival event by ID
    func deleteFestivalEvent(by id: UUID) {
        festivalEvents.removeAll { $0.id == id }
    }

    /// Retrieve a festival event by ID
    func getFestivalEvent(by id: UUID) -> FestivalEvent? {
        return festivalEvents.first { $0.id == id }
    }

    /// Clear all festival events
    func clearAllFestivalEvents() {
        festivalEvents.removeAll()
    }

    // MARK: - Persistence with UserDefaults

    /// Save festival events to UserDefaults
    private func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(festivalEvents) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    /// Load festival events from UserDefaults
    private func loadFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedEvents = try? JSONDecoder().decode([FestivalEvent].self, from: savedData) {
            festivalEvents = decodedEvents
        }
    }

    // MARK: - Utility Functions

    /// Filter events by date
    func filterEventsByDate(_ date: Date) -> [FestivalEvent] {
        let calendar = Calendar.current
        return festivalEvents.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    /// Search events by name, location, or featured trucks
    func searchEvents(byQuery query: String) -> [FestivalEvent] {
        return festivalEvents.filter {
            $0.eventName.lowercased().contains(query.lowercased()) ||
            $0.location.lowercased().contains(query.lowercased()) ||
            $0.featuredTrucks.joined(separator: ", ").lowercased().contains(query.lowercased())
        }
    }

    /// Get events that require tickets
    func eventsRequiringTickets() -> [FestivalEvent] {
        return festivalEvents.filter { $0.isTicketRequired }
    }

    /// Count events by entertainment type
    func countEventsByEntertainmentType() -> [String: Int] {
        return festivalEvents.reduce(into: [String: Int]()) { counts, event in
            counts[event.entertainmentType, default: 0] += 1
        }
    }
}

import SwiftUI

struct FestivalEventListView: View {
    @EnvironmentObject var festivalEventManager: FestivalEventManager
    @State private var selectedEvent: FestivalEvent? = nil
    @State private var showAddEditView = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(festivalEventManager.festivalEvents) { event in
                        Button(action: {
                            selectedEvent = event
                            showAddEditView = true
                        }) {
                            FestivalEventCardView(event: event)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: deleteEvent)
                }
                .navigationBarTitle("Festival Events")
                .navigationBarItems(trailing: EditButton())

                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            selectedEvent = nil
                            showAddEditView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showAddEditView) {
                AddEditFestivalEventView(festivalEventManager: festivalEventManager, event: $selectedEvent)
            }
        }
    }

    // Delete Function
    private func deleteEvent(at offsets: IndexSet) {
        offsets.forEach { index in
            let event = festivalEventManager.festivalEvents[index]
            festivalEventManager.deleteFestivalEvent(by: event.id)
        }
    }
}


import SwiftUI

// MARK: - FestivalEventCardView
struct FestivalEventCardView: View {
    let event: FestivalEvent

    var body: some View {
        VStack(spacing: 0) {
            // Display the event poster image
            if let imageData = event.eventPosterImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(15, corners: [.topLeft, .topRight])
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .foregroundColor(.white.opacity(0.8))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "#FFB6C1"), Color(hex: "#FFA07A")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15, corners: [.topLeft, .topRight])
            }

            // Content Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(event.eventName)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Text(event.entertainmentType)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }

                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.yellow)
                    Text(formattedDate(event.date))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.white)
                    Text("\(event.startTime) - \(event.endTime)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                Text("Location: \(event.location)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#6A5ACD"), Color(hex: "#836FFF")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
        .padding(.vertical, 5)
    }

    // Date Formatter
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

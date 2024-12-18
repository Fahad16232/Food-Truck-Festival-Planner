import SwiftUI

// MARK: - AddEditFestivalEventView
struct AddEditFestivalEventView: View {
    @ObservedObject var festivalEventManager: FestivalEventManager
    @Binding var event: FestivalEvent?

    // State variables for form fields
    @State private var eventName = ""
    @State private var date = Date()
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var location = ""
    @State private var featuredTrucks = ""
    @State private var entertainmentType = "Live Band"
    @State private var hostName = ""
    @State private var isTicketRequired = false
    @State private var notes = ""
    @State private var eventPosterImage: UIImage?
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    let entertainmentTypes = ["Live Band", "DJ Set", "Kids Play Area", "Comedy Show", "Dance Performance"]
    let locationOptions = ["Main Stage", "Booth Area 1", "Booth Area 2", "Food Court", "Kids Zone"]

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                // Event Details Section
                Section(header: Text("Event Details").font(.headline)) {
                    TextField("Event Name", text: $eventName)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Start Time (e.g., 2:00 PM)", text: $startTime)
                    TextField("End Time (e.g., 4:00 PM)", text: $endTime)

                    Picker("Location", selection: $location) {
                        ForEach(locationOptions, id: \.self) { Text($0) }
                    }
                    
                    TextField("Featured Trucks (comma-separated)", text: $featuredTrucks)

                    Picker("Entertainment Type", selection: $entertainmentType) {
                        ForEach(entertainmentTypes, id: \.self) { Text($0) }
                    }
                }

                // Additional Info Section
                Section(header: Text("Additional Info").font(.headline)) {
                    TextField("Host Name", text: $hostName)
                    Toggle("Ticket Required?", isOn: $isTicketRequired)
                    TextField("Notes", text: $notes)
                }

                // Event Poster Section
                Section(header: Text("Event Poster").font(.headline)) {
                    if let image = eventPosterImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    Button("Select Image") {
                        showImagePicker = true
                    }
                }
            }
            .navigationBarTitle(event == nil ? "Add Event" : "Edit Event", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") { saveEvent() }
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $eventPosterImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Fields"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: loadEventData)
        }
    }

    // MARK: - Load Existing Data
    private func loadEventData() {
        if let existingEvent = event {
            eventName = existingEvent.eventName
            date = existingEvent.date
            startTime = existingEvent.startTime
            endTime = existingEvent.endTime
            location = existingEvent.location
            featuredTrucks = existingEvent.featuredTrucks.joined(separator: ", ")
            entertainmentType = existingEvent.entertainmentType
            hostName = existingEvent.hostName ?? ""
            isTicketRequired = existingEvent.isTicketRequired
            notes = existingEvent.notes ?? ""
            if let imageData = existingEvent.eventPosterImageData {
                eventPosterImage = UIImage(data: imageData)
            }
        } else {
            // Default values for new event
            location = locationOptions.first ?? ""
            entertainmentType = entertainmentTypes.first ?? ""
        }
    }

    // MARK: - Save Event
    private func saveEvent() {
        guard !eventName.isEmpty, !startTime.isEmpty, !endTime.isEmpty, !location.isEmpty else {
            alertMessage = "Please fill in all required fields."
            showAlert = true
            return
        }

        let newEvent = FestivalEvent(
            id: event?.id ?? UUID(),
            eventName: eventName,
            date: date,
            startTime: startTime,
            endTime: endTime,
            location: location,
            featuredTrucks: featuredTrucks.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            entertainmentType: entertainmentType,
            hostName: hostName.isEmpty ? nil : hostName,
            isTicketRequired: isTicketRequired,
            eventPosterImageData: eventPosterImage?.jpegData(compressionQuality: 0.8),
            notes: notes.isEmpty ? nil : notes
        )

        if event != nil {
            festivalEventManager.updateFestivalEvent(newEvent)
        } else {
            festivalEventManager.addFestivalEvent(newEvent)
        }

        presentationMode.wrappedValue.dismiss()
    }
}

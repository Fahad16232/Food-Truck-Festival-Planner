import SwiftUI

// MARK: - AddEditFoodTruckView
struct AddEditFoodTruckView: View {
    @ObservedObject var foodTruckManager: FoodTruckManager
    @Binding var foodTruck: FoodTruck?

    // State variables for form fields
    @State private var name = ""
    @State private var cuisineType = "Mexican"
    @State private var specialtyDish = ""
    @State private var menuItems = ""
    @State private var ownerName = ""
    @State private var contactEmail = ""
    @State private var contactNumber = ""
    @State private var socialMediaLink = ""
    @State private var operatingHours = "10:00 AM - 8:00 PM"
    @State private var foodAllergenInfo = ""
    @State private var isEcoFriendly = false
    @State private var notes = ""
    @State private var truckImage: UIImage?
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Dropdown options
    let cuisineTypes = ["Mexican", "Italian", "BBQ", "Chinese", "Indian", "American", "Vegan"]
    let operatingHourOptions = ["9:00 AM - 5:00 PM", "10:00 AM - 8:00 PM", "11:00 AM - 9:00 PM", "12:00 PM - 10:00 PM"]

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                // Truck Details Section
                Section(header: Text("Truck Details")) {
                    TextField("Name", text: $name)
                    Picker("Cuisine Type", selection: $cuisineType) {
                        ForEach(cuisineTypes, id: \.self) { Text($0) }
                    }
                    TextField("Specialty Dish", text: $specialtyDish)
                    TextField("Menu Items (comma-separated)", text: $menuItems)
                }

                // Owner & Contact Section
                Section(header: Text("Owner & Contact")) {
                    TextField("Owner Name", text: $ownerName)
                    TextField("Email", text: $contactEmail)
                        .keyboardType(.emailAddress)
                    TextField("Contact Number", text: $contactNumber)
                        .keyboardType(.phonePad)
                    TextField("Social Media Link (e.g., Instagram:@handle)", text: $socialMediaLink)
                }

                // Additional Info Section
                Section(header: Text("Operating Hours & Info")) {
                    Picker("Operating Hours", selection: $operatingHours) {
                        ForEach(operatingHourOptions, id: \.self) { Text($0) }
                    }
                    TextField("Food Allergen Info", text: $foodAllergenInfo)
                    Toggle("Eco-Friendly Packaging?", isOn: $isEcoFriendly)
                    TextField("Notes", text: $notes)
                }

                // Truck Image Section
                Section(header: Text("Truck Image")) {
                    if let image = truckImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    }
                    Button("Select Image") {
                        showImagePicker = true
                    }
                }
            }
            .navigationBarTitle(foodTruck == nil ? "Add Food Truck" : "Edit Food Truck", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveFoodTruck()
                }
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $truckImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Fields"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: loadFoodTruckData)
        }
    }

    // MARK: - Load Existing Data
    private func loadFoodTruckData() {
        if let existingTruck = foodTruck {
            name = existingTruck.name
            cuisineType = existingTruck.cuisineType
            specialtyDish = existingTruck.specialtyDish
            menuItems = existingTruck.menuItems.joined(separator: ", ")
            ownerName = existingTruck.ownerName
            contactEmail = existingTruck.contactEmail
            contactNumber = existingTruck.contactNumber
            socialMediaLink = existingTruck.socialMediaLinks.values.first ?? ""
            operatingHours = existingTruck.operatingHours
            foodAllergenInfo = existingTruck.foodAllergenInfo ?? ""
            isEcoFriendly = existingTruck.isEcoFriendly
            notes = existingTruck.notes ?? ""
            if let imageData = existingTruck.truckImageData {
                truckImage = UIImage(data: imageData)
            }
        }
    }

    // MARK: - Save Food Truck
    private func saveFoodTruck() {
        guard !name.isEmpty, !specialtyDish.isEmpty else {
            alertMessage = "Please fill in all required fields."
            showAlert = true
            return
        }

        let newTruck = FoodTruck(
            id: foodTruck?.id ?? UUID(),
            name: name,
            cuisineType: cuisineType,
            specialtyDish: specialtyDish,
            menuItems: menuItems.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            ownerName: ownerName,
            contactEmail: contactEmail,
            contactNumber: contactNumber,
            socialMediaLinks: ["Link": socialMediaLink],
            operatingHours: operatingHours,
            truckImageData: truckImage?.jpegData(compressionQuality: 0.8),
            foodAllergenInfo: foodAllergenInfo.isEmpty ? nil : foodAllergenInfo,
            isEcoFriendly: isEcoFriendly,
            notes: notes.isEmpty ? nil : notes
        )

        if foodTruck != nil {
            foodTruckManager.updateFoodTruck(newTruck)
        } else {
            foodTruckManager.addFoodTruck(newTruck)
        }

        presentationMode.wrappedValue.dismiss()
    }
}

import SwiftUI

// MARK: - FoodTruckListView
struct FoodTruckListView: View {
    @EnvironmentObject var foodTruckManager: FoodTruckManager
    @State private var selectedFoodTruck: FoodTruck?
    @State private var showAddEditView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(foodTruckManager.foodTrucks) { foodTruck in
                    FoodTruckCardView(foodTruck: foodTruck)
                        .onTapGesture {
                            selectedFoodTruck = foodTruck
                            showAddEditView = true
                        }
                }
                .onDelete(perform: deleteFoodTruck)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Food Trucks")
            .navigationBarItems(
                trailing: Button(action: {
                    selectedFoodTruck = nil
                    showAddEditView = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                }
            )
            .sheet(isPresented: $showAddEditView) {
                AddEditFoodTruckView(foodTruckManager: foodTruckManager, foodTruck: $selectedFoodTruck)
            }
        }
    }

    // MARK: - Delete Food Truck
    private func deleteFoodTruck(at offsets: IndexSet) {
        for index in offsets {
            let truck = foodTruckManager.foodTrucks[index]
            foodTruckManager.deleteFoodTruck(by: truck.id)
        }
    }
}

// MARK: - FoodTruckCardView
import SwiftUI

// MARK: - FoodTruckCardView
struct FoodTruckCardView: View {
    let foodTruck: FoodTruck

    var body: some View {
        VStack(spacing: 0) {
            // Display the food truck image
            if let imageData = foodTruck.truckImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(15, corners: [.topLeft, .topRight])
            } else {
                Image(systemName: "truck.box.fill")
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
                    Text(foodTruck.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Image(systemName: "leaf.fill")
                        .foregroundColor(foodTruck.isEcoFriendly ? .green : .gray)
                }

                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.yellow)
                    Text(foodTruck.cuisineType)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.white)
                    Text(foodTruck.operatingHours)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                Text("Specialty: \(foodTruck.specialtyDish)")
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
}

// MARK: - Extension for Corner Radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


// MARK: - Extension for Hex Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

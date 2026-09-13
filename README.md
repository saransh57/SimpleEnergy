# 🚗 Vehicle Dashboard App — iOS

A simple iOS vehicle dashboard app built with **Swift, SwiftUI, and MVVM**. The app fetches vehicle telemetry from a REST API and displays the latest vehicle status and key operational metrics in a clean, easy-to-use interface.

The project also focuses on some important production-level practices such as **Swift Concurrency, dependency injection, structured logging, and unit testing**.

---
## 🎥 App Demo

Here is a quick walkthrough of the Vehicle Dashboard app, showing the vehicle list, telemetry details, refresh functionality, and navigation flow.



https://github.com/user-attachments/assets/061c121c-74c2-42c1-bd78-1e365a5953f4



## ✨ Features

* **Vehicle Overview**

  * Displays a list of vehicles.
  * Shows the current connectivity status with `ONLINE` / `OFFLINE` badges.

* **Vehicle Telemetry**

  * Battery level
  * Estimated range
  * Current speed
  * Odometer reading
  * Last updated timestamp

* **Pull to Refresh**

  * Pull down on the vehicle list to fetch the latest telemetry data.

* **Manual Sync**

  * Vehicle details can also be refreshed manually using the sync action.

* **Modern Swift Concurrency**

  * Uses `async/await` for network operations.
  * UI-related state is managed using `@MainActor`.

* **Structured Logging**

  * Uses Apple's `os.Logger` framework for application and network logs.

* **Unit Testing**

  * Uses the modern **Swift Testing** framework.
  * Network dependencies are mocked using protocols, making the ViewModel easier to test.

---

## 🛠️ Tech Stack

| Technology               | Usage                            |
| ------------------------ | -------------------------------- |
| **Swift**                | Primary programming language     |
| **SwiftUI**              | UI development                   |
| **MVVM**                 | Application architecture         |
| **Swift Concurrency**    | Async network operations         |
| **URLSession**           | REST API communication           |
| **OSLog / Logger**       | Structured logging               |
| **Swift Testing**        | Unit testing                     |
| **Protocol-Oriented DI** | Dependency injection and mocking |

---

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture.

Protocol-based dependency injection is used for the networking layer so that the ViewModel doesn't depend directly on a concrete network implementation. This makes the code easier to test and maintain.

```text
                ┌─────────────────────┐
                │     SwiftUI View    │
                │                     │
                │ VehicleListView     │
                │ VehicleDetailView   │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │     ViewModel       │
                │                     │
                │ VehicleListVM       │
                │ @MainActor          │
                └──────────┬──────────┘
                           │
                    Protocol / DI
                           │
                           ▼
                ┌─────────────────────┐
                │   Network Service   │
                │                     │
                │    URLSession       │
                │    async/await      │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │      REST API       │
                └─────────────────────┘
```

### Why MVVM?

The main goal is to keep the UI layer focused on presentation while the ViewModel handles application state and data loading.

For example:

* **View** → Displays vehicles and user interactions.
* **ViewModel** → Loads data and manages loading/error states.
* **Service** → Handles API communication.
* **Model** → Represents vehicle and telemetry data.

---

## 📁 Project Structure

```text
VehicleDashboard/
│
├── Models/
│   └── DataModel.swift
│       └── Vehicle models, telemetry data and enums
│
├── Services/
│   └── NetworkService.swift
│       └── REST API communication using URLSession
│
├── ViewModels/
│   └── VehicleListViewModel.swift
│       └── UI state and data loading logic
│
├── Views/
│   ├── VehicleListView.swift
│   │   └── Vehicle list and pull-to-refresh
│   │
│   └── VehicleDetailView.swift
│       └── Vehicle telemetry details
│
└── App/
    └── VehicleDashboardApp.swift
        └── Application entry point
```

---

## 🔄 Data Flow

The basic data flow in the application is:

```text
REST API
   ↓
Network Service
   ↓
Vehicle Model
   ↓
ViewModel
   ↓
SwiftUI View
   ↓
User Interface
```

When the user performs a refresh, the ViewModel requests the latest data from the network service. Once the request completes, the ViewModel updates its state on the main actor and SwiftUI automatically refreshes the UI.

---

## ⚡ Concurrency

The networking layer uses Swift's modern concurrency model:

```swift
func fetchVehicles() async throws -> [Vehicle] {
    // API request
}
```

The ViewModel can then load the data asynchronously:

```swift
@MainActor
func loadVehicles() async {
    do {
        vehicles = try await service.fetchVehicles()
    } catch {
        // Handle error
    }
}
```

Using `async/await` keeps the asynchronous code easier to read compared with deeply nested completion handlers.

---

## 🧩 Dependency Injection

The networking dependency is abstracted behind a protocol.

```swift
protocol NetworkServiceProtocol {
    func fetchVehicles() async throws -> [Vehicle]
}
```

The ViewModel depends on the protocol rather than a concrete implementation.

```swift
@MainActor
final class VehicleListViewModel: ObservableObject {

    private let service: NetworkServiceProtocol

    init(service: NetworkServiceProtocol) {
        self.service = service
    }
}
```

This makes it possible to inject a mock service during unit tests without making real API calls.

---

## 🧪 Testing

The project uses the **Swift Testing** framework for unit tests.

The network service can be replaced with a mock implementation:

```swift
struct MockNetworkService: NetworkServiceProtocol {

    func fetchVehicles() async throws -> [Vehicle] {
        // Return test data instead of calling the API
    }
}
```

This allows the ViewModel to be tested independently from the actual network layer.

### Areas covered by testing

* Successful vehicle loading
* API/network failure handling
* ViewModel state updates
* Mock service integration

---

## 📝 Logging

The application uses Apple's unified logging system through `Logger`.

Example:

```swift
import OSLog

private let logger = Logger(
    subsystem: "com.saransh.VehicleDashboard",
    category: "Network"
)

logger.info("Fetching vehicle telemetry")
logger.error("Failed to fetch vehicle data")
```

This provides structured logs that can be inspected through Xcode and the Console application.

---

## 🌐 API Assumptions

For this project, the telemetry data is assumed to come from a REST endpoint returning JSON data.

The timestamp follows an ISO-8601 format similar to:

```text
2026-09-13T10:30:00Z
```

The vehicle connectivity status is represented using:

```text
ONLINE
OFFLINE
```

These values are mapped to Swift types and used by the UI to display the appropriate status.

---

## 🚀 Build & Run

### Requirements

* **Xcode 15.0+**
* **Swift 5.9+**
* **iOS 17.0+**
* macOS capable of running the required Xcode version

### 1. Clone the repository

```bash
git clone https://github.com/saransh57/VehicleDashboard.git
cd VehicleDashboard
```

### 2. Open the project

```bash
open VehicleDashboard.xcodeproj
```

### 3. Select the target

Select:

```text
Target: VehicleDashboard
```

Then choose an iOS Simulator or a connected physical device.

### 4. Run

Press:

```text
Cmd + R
```

### 5. Run tests

Press:

```text
Cmd + U
```

---

## 📱 Screens / User Flow

The application follows a simple flow:

```text
Vehicle List
     │
     ├── View connectivity status
     │
     ├── Pull to refresh
     │
     ▼
Vehicle Details
     │
     ├── Battery
     ├── Range
     ├── Speed
     ├── Odometer
     │
     └── Manual Sync
```

---

## 🔐 Production Considerations

This project is intentionally kept small, but the architecture leaves room for production improvements such as:

* Environment-based API configuration
* Authentication and token management
* Better offline support
* Persistent caching
* Network reachability handling
* Retry policies
* Request cancellation
* Analytics and crash reporting
* UI testing with XCUITest / Maestro
* CI/CD integration

---

## ⚠️ Current Limitations

### No Local Persistence

The application currently fetches data from the API and doesn't persist vehicle telemetry locally.

A future version could use **SwiftData** for caching and offline access.

### Static API Configuration

The current network layer uses a fixed endpoint.

For a production application, the API configuration could be moved to environment-specific `.xcconfig` files.

### Network Dependency

The current implementation expects the API to be available. Offline-first behavior could be added in a future iteration.

---

## 🔮 Future Improvements

Some possible next steps:

* [ ] Add SwiftData caching
* [ ] Add offline mode
* [ ] Add network reachability monitoring
* [ ] Add API retry mechanism
* [ ] Add authentication
* [ ] Add pagination for large vehicle lists
* [ ] Add automated UI tests
* [ ] Add Maestro E2E tests
* [ ] Add CI/CD pipeline
* [ ] Add environment-specific configurations
* [ ] Add telemetry charts and historical data

---

## 📚 What This Project Demonstrates

This project is mainly intended to demonstrate practical iOS development concepts rather than just UI implementation.

It covers:

* Swift & SwiftUI
* MVVM architecture
* Protocol-oriented programming
* Dependency Injection
* REST API integration
* URLSession
* Swift Concurrency
* `async/await`
* `@MainActor`
* Error handling
* OSLog
* Swift Testing
* Mocking
* Pull-to-refresh
* Clean separation of responsibilities

---

## 📌 Repository

**GitHub:**
https://github.com/saransh57/VehicleDashboard

---

## 👨‍💻 Author

**Saransh Dubey**

iOS Developer | Swift | SwiftUI | UIKit | MVVM | Swift Concurrency

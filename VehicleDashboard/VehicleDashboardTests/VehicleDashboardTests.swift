//
//  VehicleDashboardTests.swift
//  VehicleDashboardTests
//
//  Created by Saransh Dubey on 13/09/26.
//

import Testing
import Foundation
@testable import VehicleDashboard

struct VehicleDashboardTests {

    // MARK: - Test Mocks
    
    final class MockSuccessService: VehicleServiceProtocol {
        func fetchVehicles() async throws -> [Vehicle] {
            return [
                Vehicle(
                    id: 1,
                    name: "Simple One",
                    model: "3.7 kWh",
                    battery: 72,
                    range: 118,
                    speed: 45,
                    odometer: 5420,
                    status: .online,
                    lastUpdated: Date()
                )
            ]
        }
    }
    
    final class MockFailureService: VehicleServiceProtocol {
        func fetchVehicles() async throws -> [Vehicle] {
            throw NetworkError.noInternet
        }
    }

    // MARK: - Unit Tests

    @Test("ViewModel successfully fetches and populates vehicle data")
    func testFetchVehiclesSuccess() async {
        // Given (Setup)
        let mockService = MockSuccessService()
        let viewModel = await VehicleListViewModel(service: mockService)
        
        // When (Action)
        await viewModel.loadVehicles()
        
        // Then (Verification)
        await MainActor.run {
            #expect(viewModel.vehicles.count == 1)
            #expect(viewModel.vehicles.first?.name == "Simple One")
            #expect(viewModel.vehicles.first?.battery == 72)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == nil)
        }
    }
    
    @Test("ViewModel handles network failure gracefully and shows error message")
    func testFetchVehiclesFailure() async {
        // Given (Setup)
        let mockService = MockFailureService()
        let viewModel = await VehicleListViewModel(service: mockService)
        
        // When (Action)
        await viewModel.loadVehicles()
        
        // Then (Verification)
        await MainActor.run {
            #expect(viewModel.vehicles.isEmpty)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == NetworkError.noInternet.localizedDescription)
        }
    }
}

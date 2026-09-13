//
//  VehicleListViewModel.swift
//  VehicleDashboard
//
//  Created by Saransh Dubey on 13/09/26.
//

import Foundation
import Combine

@MainActor
final class VehicleListViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var vehicles: [Vehicle] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service: VehicleServiceProtocol
    
    // MARK: - Initialization
    
    init(service: VehicleServiceProtocol? = nil) {
        self.service = service ?? RemoteVehicleService()
    }
    
    // MARK: - API Actions
    
    func loadVehicles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.vehicles = try await service.fetchVehicles()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

//
//  VehicleListView.swift
//  VehicleDashboard
//
//  Created by Saransh Dubey on 13/09/26.
//

import SwiftUI

struct VehicleListView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel = VehicleListViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.vehicles.isEmpty {
                    ProgressView("Fetching vehicles...")
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .foregroundColor(.red)
                        
                        Button("Retry") {
                            Task { await viewModel.loadVehicles() }
                        }
                    }
                } else {
                    List(viewModel.vehicles) { vehicle in
                        NavigationLink(destination: VehicleDetailView(vehicle: vehicle, onRefresh: viewModel.loadVehicles)) {
                            VehicleRowView(vehicle: vehicle)
                        }
                    }
                    .refreshable {
                        await viewModel.loadVehicles()
                    }
                }
            }
            .navigationTitle("Dashboard")
            .task {
                if viewModel.vehicles.isEmpty {
                    await viewModel.loadVehicles()
                }
            }
        }
    }
}

// MARK: - Subviews

struct VehicleRowView: View {
    let vehicle: Vehicle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(vehicle.name)
                    .font(.headline)
                
                Spacer()
                
                Text(vehicle.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(vehicle.status.isOnline ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                    .foregroundColor(vehicle.status.isOnline ? .green : .gray)
                    .cornerRadius(6)
            }
            
            HStack(spacing: 16) {
                Label("\(vehicle.battery)%", systemImage: "battery.100")
                Label("\(vehicle.range) km", systemImage: "paperplane")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

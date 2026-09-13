//
//  VehicleDetailView.swift
//  VehicleDashboard
//
//  Created by Saransh Dubey on 13/09/26.
//

import SwiftUI

struct VehicleDetailView: View {
    // MARK: - Properties
    
    let vehicle: Vehicle
    var onRefresh: () async -> Void
    
    @State private var isRefreshing = false
    
    // MARK: - Body
    
    var body: some View {
        List {
            Section(header: Text("Overview")) {
                DetailRow(title: "Name", value: vehicle.name)
                DetailRow(title: "Model", value: vehicle.model)
                DetailRow(title: "Status", value: vehicle.status.rawValue, highlightColor: vehicle.status.isOnline ? .green : .gray)
            }
            
            Section(header: Text("Metrics")) {
                DetailRow(title: "Battery Level", value: "\(vehicle.battery)%")
                DetailRow(title: "Estimated Range", value: "\(vehicle.range) km")
                DetailRow(title: "Current Speed", value: "\(vehicle.speed) km/h")
                DetailRow(title: "Odometer", value: "\(vehicle.odometer) km")
            }
            
            Section(header: Text("System Info")) {
                DetailRow(title: "Last Updated", value: vehicle.lastUpdated.formatted(date: .numeric, time: .standard))
            }
        }
        .navigationTitle(vehicle.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        isRefreshing = true
                        await onRefresh()
                        isRefreshing = false
                    }
                }) {
                    if isRefreshing {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

struct DetailRow: View {
    let title: String
    let value: String
    var highlightColor: Color? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .bold()
                .foregroundColor(highlightColor ?? .primary)
        }
    }
}

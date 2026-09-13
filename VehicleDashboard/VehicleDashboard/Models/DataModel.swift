//
//  DataModel.swift
//  VehicleDashboard
//
//  Created by Saransh Dubey on 13/09/26.
//

import Foundation

// MARK: - Vehicle Model

struct Vehicle: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let model: String
    let battery: Int
    let range: Int
    let speed: Int
    let odometer: Int
    let status: VehicleStatus
    let lastUpdated: Date
    
    // MARK: - Vehicle Status Enum
    
    enum VehicleStatus: String, Codable {
        case online = "ONLINE"
        case offline = "OFFLINE"
        
        var isOnline: Bool {
            self == .online
        }
    }
}

//
//  NetworkService.swift
//  VehicleDashboard
//
//  Created by Saransh Dubey on 13/09/26.
//

import Foundation
import OSLog

// MARK: - Error Types

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case serverError
    case decodingError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL. Please try again later."
        case .noInternet:
            return "Unable to connect. Please check your internet connection."
        case .serverError:
            return "Server is currently unavailable. Please try again in a few moments."
        case .decodingError:
            return "Received unexpected data format from the server."
        case .unknown:
            return "Something went wrong. Please try refreshing."
        }
    }
}

// MARK: - Protocols

protocol VehicleServiceProtocol {
    func fetchVehicles() async throws -> [Vehicle]
}

// MARK: - Remote Service Implementation

class RemoteVehicleService: VehicleServiceProtocol {
    
    // MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.vehicle.dashboard", category: "Network")
    private let urlString = "https://gist.githubusercontent.com/saransh57/31749205eb1bc74ff7d5b37592185f90/raw/"

    // MARK: - API Methods
    
    func fetchVehicles() async throws -> [Vehicle] {
        guard let url = URL(string: urlString) else {
            logger.error("Failed to construct URL from string: \(self.urlString, privacy: .public)")
            throw NetworkError.invalidURL
        }

        do {
            logger.info("Initiating network request to fetch vehicle data.")
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("Failed to receive a valid HTTP response type.")
                throw NetworkError.serverError
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                logger.error("API request failed with HTTP status code: \(httpResponse.statusCode)")
                throw NetworkError.serverError
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let vehicles = try decoder.decode([Vehicle].self, from: data)
            logger.info("Successfully fetched and decoded \(vehicles.count) vehicles.")
            return vehicles

        } catch let urlError as URLError {
            logger.error("Network failure occurred: \(urlError.localizedDescription, privacy: .public)")
            if urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                throw NetworkError.noInternet
            }
            throw NetworkError.unknown
        } catch let decodingError as DecodingError {
            logger.error("JSON decoding failure: \(decodingError.localizedDescription, privacy: .public)")
            throw NetworkError.decodingError
        } catch {
            logger.error("Unexpected error occurred: \(error.localizedDescription, privacy: .public)")
            throw NetworkError.unknown
        }
    }
}

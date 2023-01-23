//
//  EARequest.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation

/// Protocol that all EARequests must follow to be used in the API Service layer
protocol EARequest {
    var urlRequest: URLRequest? { get }
    var httpMethod: HTTPMethod { get }
}

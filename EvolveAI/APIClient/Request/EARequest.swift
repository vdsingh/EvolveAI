//
//  EARequest.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/2/23.
//

import Foundation

/// Protocol that all EARequests must follow to be used in the API Service layer
protocol EARequest {

    /// The URLRequest to be used in the URLSession task
    var urlRequest: URLRequest? { get }

    /// The HTTP Method that we're using for the request
    var httpMethod: HTTPMethod { get }
}

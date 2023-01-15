//
//  EAService.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import Foundation

/// Used to execute REST API requests
final class EAService {
    
    /// The shared instance that is used to access service functionality
    public static let shared = EAService()
    
    /// Private initializer forces use of shared.
    private init() { }
    
    /// Possible errors that can be encountered
    enum EAServiceError: Error {
        case failedToUnwrapURLRequest
        case failedToUnwrapData
        case failedToUnwrapResponse
        case failedToGetData
        case invalidResponseCode
        case failedToDecodeData
    }
    
    /// Executes requests and receives/decodes response
    /// - Parameters:
    ///   - request: The request that we are sending
    ///   - expecting: The type of object that we are expecting in response
    ///   - completion: The completion handler
    public func execute <T: EAAPIResponse>(
        _ request: EARequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void)
    {
        
        if(Flags.debugAPIClient) {
            print("$Log: Executing a PFService request.")
        }
        
        // Unwrap the urlRequest property from the PFRequest object
        guard let urlRequest = request.urlRequest else {
            completion(.failure(EAServiceError.failedToUnwrapURLRequest))
            print("$Error: url request is nil.")
            return
        }
        
        let task = URLSession.shared.dataTask(
            with: urlRequest,
            completionHandler: { data, response, error in
                // There was an error fetching the data.
                if let error = error {
                    print("$Error: \(String(describing: error))")
                    completion(.failure(error))
                }

                // The data came back nil
                guard let data = data else {
                    print("$Error: data is nil.")
                    completion(.failure(EAServiceError.failedToUnwrapData))
                    return
                }

                // There was an invalid response code.
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("$Error: couldn't read response as HTTPURLResponse.")
                    completion(.failure(EAServiceError.failedToUnwrapResponse))
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    print("$Error: invalid response code: \(httpResponse.statusCode).")
                    completion(.failure(EAServiceError.invalidResponseCode))
                    return
                }

                // Try to decode the data
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(type, from: data)
                    if(Flags.debugAPIClient) {
                        print("$Log: successfully decoded data to type \(type).")
                    }
                    
                    completion(.success(responseObject))
                } catch let error {
                    if let decodingError = error as? DecodingError {
                        // There was an error decoding the data
                        print("$Error decoding response data \(String(describing: decodingError))")
                        completion(.failure(EAServiceError.failedToDecodeData))
                    } else {
                        // There was some other error
                        completion(.failure(error))
                    }
                }
            })
        task.resume()
    }
}

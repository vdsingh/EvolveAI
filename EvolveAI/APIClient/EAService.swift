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
        printDebug("Executing a EAService request.")
        
        // Unwrap the urlRequest property from the EARequest object
        guard let urlRequest = request.urlRequest else {
            completion(.failure(EAServiceError.failedToUnwrapURLRequest))
            print("$Error: url request is nil.")
            return
        }
        
        let task = URLSession.shared.dataTask(
            with: urlRequest,
            completionHandler: { [weak self] data, response, error in
                guard let self = self else {
                    fatalError("$Error: EAService self is nil.")
                }
                
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
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(JSONString)")
                    }
                    
                    print("$Error: invalid response code: \(httpResponse.statusCode).")
                    completion(.failure(EAServiceError.invalidResponseCode))
                    return
                }

                // Try to decode the data
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(type, from: data)
                    self.printDebug("successfully decoded data to type \(type). Response Object: \(responseObject)")
                    completion(.success(responseObject))
                } catch let error {
                    if let decodingError = error as? DecodingError {
                        // There was an error decoding the data
                        print("$Error decoding response data \(String(describing: decodingError))")
                        completion(.failure(EAServiceError.failedToDecodeData))
                    } else {
                        // There was some other error
                        print("$Error: \(String(describing: error))")
                        completion(.failure(error))
                    }
                }
            })
        task.resume()
    }
    
    /// Reads the relevant flags and prints debug messages only if they are enabled
    /// - Parameter message: The message to print
    private func printDebug(_ message: String) {
        if(Flags.debugAPIClient) {
            print("$Log: \(message)")
        }
    }
    
    
    /// Takes a JSON object and turns it into a readable String
    /// - Parameters:
    ///   - json: The JSON object to stringify
    ///   - prettyPrinted: Whether the String should be formatted to read easily
    /// - Returns: A String representing the JSON object
    private func stringify(json: Any, prettyPrinted: Bool = true) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        
        return ""
    }
}

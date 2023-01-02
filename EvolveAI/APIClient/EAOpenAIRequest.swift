//
//  EARequest.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import Foundation
final class EAOpenAIRequest: EARequest {
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://api.openai.com/v1"
    }
    
    /// Desired Endpoint
    private let endpoint: EAOpenAIEndpoint
    /// Body for the request
    private let requestBody: EARequestBody?
    /// Path Components for API if any
    private let pathComponents: [String]
    /// Query Parameters for API if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the API request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        if !pathComponents.isEmpty {
            for component in pathComponents {
                string += "/\(component)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    private var requestBodyData: Data? {
        
        if let requestBody = self.requestBody {
            // Encode the object as JSON data
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(requestBody) else {
                print("$Error encoding object as JSON data")
                return nil
            }
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                print("$Log: Request Body DATA: \(string)")
            } else {
                print("$Error: Unable to convert request body data to string.")
            }
            return data
        }
        print("$Log: requestBody is nil.")
        return nil
    }
    
    
    // MARK: - Public
    
    /// Desired HTTP Method
    public let httpMethod: HTTPMethod
    
    /// Computed and constructed URL Request
    public var urlRequest: URLRequest? {
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { return nil }
        var urlRequest = URLRequest(url: unwrappedURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String,
        let organizationID = Bundle.main.infoDictionary?["ORGANIZATION_ID"] as? String else {
            
            fatalError("$Error retrieving API Key and Organization ID from config.")
        }
        
        
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue(organizationID, forHTTPHeaderField: "OpenAI-Organization")
        
        
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = requestBodyData
        
        return urlRequest
    }
    
    
    /// Constructor for request
    /// - Parameters:
    ///   - endpoint: target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameteres
    public init(endpoint: EAOpenAIEndpoint,
                requestBody: EARequestBody?,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.requestBody = requestBody
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        
        switch endpoint {
        case .completions:
            self.httpMethod = .POST
        }
    }
}

extension EAOpenAIRequest {
    
    /// Creates a EAOpenAIRequest for the completions endpoint
    /// - Parameters:
    ///   - model: the AI model that will receive the request
    ///   - prompt: the string to send to the model
    ///   - temperature: The sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    ///   - max_tokens: The maximum number of tokens to generate in the completion.
    /// - Returns: An EAOpenAIRequest object
    static func completionsRequest(
        model: EAOpenAICompletionsModel,
        prompt: String,
        temperature: Int = 1,
        max_tokens: Int = 100
    ) -> EAOpenAIRequest {
        let requestBody = EAOpenAICompletionsRequestBody(
            model: model,
            prompt: prompt,
            temperature: temperature,
            max_tokens: max_tokens)
        return EAOpenAIRequest(endpoint: .completions, requestBody: requestBody)
    }
//    static func getInsiderTradingReportsRequest(forSymbol symbol: String) -> IPRequest {
//        let query = IPInsiderTradingQuery(
//            highestJunction:
//                IPInsiderTradingClause(
//                    operator: .AND,
//                    junctionValues: [],
//                    queryItemValues: [
//                        IPInsiderTradingQueryItem(key: .tradingSymbol, value: symbol)
//                    ]
//                )
//        )
//
////        print("QUERY STRING: \(query.highestJunction.constructClauseString())")
//        let requestBody = IPInsiderTradingRequestBody(withQuery: query)
////        print("QUERY STRING V2: \(requestBody.query?.query_string.query)")
//
//        return IPRequest(endpoint: .insiderTrading,
//                         requestBody: requestBody)
//    }
//
//    /// Constructs a IPRequest to get a specified number of transactions
//    /// - Parameter numTransactions: The number of transactions to get
//    /// - Returns: an IPRequest object to be used for making the API call.
//    static func getInsiderTraingReportsRequest(numTransactions: Int) -> IPRequest {
//        let requestBody = IPInsiderTradingRequestBody(size: 20)
//        return IPRequest(endpoint: .insiderTrading, requestBody: requestBody)
//    }
}

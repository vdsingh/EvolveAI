//
//  EARequest.swift
//  EvolveAI
//
//  Created by Vikram Singh on 1/1/23.
//

import Foundation

/// Used to create requests to OpenAI endpoints
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

    /// Encodes the requestBody into data to be used in a request.
    private var requestBodyData: Data? {
        if let requestBody = self.requestBody {
            // Encode the object as JSON data
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(requestBody) else {
                print("$Error encoding object as JSON data")
                return nil
            }

            if let string = String(data: data, encoding: String.Encoding.utf8) {
                printDebug("Request Body DATA: \(string)")
            } else {
                print("$Error: Unable to convert request body data to string.")
            }
            return data
        }

        printDebug("requestBody is nil.")
        return nil
    }

    /// Reads the relevant flags and prints debug messages only if they are enabled
    /// - Parameter message: The message to print
    private func printDebug(_ message: String) {
        if Flags.debugAPIClient {
            print("$Log: \(message)")
        }
    }

    // MARK: - Public

    /// Desired HTTP Method
    public let httpMethod: HTTPMethod

    /// Computed and constructed URL Request
    public var urlRequest: URLRequest? {
        let url = URL(string: urlString)
        guard let unwrappedURL = url else {
            fatalError("$Error unwrapping URL.")
        }

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
    public init(
        endpoint: EAOpenAIEndpoint,
        requestBody: EARequestBody?,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
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

/// Static functions to construct commonly used EAOpenAIRequest objects live here
extension EAOpenAIRequest {

    /// Creates a EAOpenAIRequest for the completions endpoint
    /// - Parameters:
    ///   - model: the AI model that will receive the request
    ///   - prompt: the string to send to the model
    ///   - temperature: The sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    ///   - max_tokens: The maximum number of tokens to generate in the completion.
    /// - Returns: An EAOpenAIRequest object
    public static func completionsRequest(
        model: EAOpenAICompletionsModel = .davinci003,
        prompt: String,
        temperature: Int = 1,
        maxTokens: Int
    ) -> EAOpenAIRequest {
        if maxTokens > model.getTokenLimit() {
            print("$Error: The maximum number of tokens is greater than what is allowed (\(model.getTokenLimit())).")
        }

        let requestBody = EAOpenAICompletionsRequestBody(
            model: model,
            prompt: prompt,
            temperature: temperature,
            maxTokens: maxTokens - prompt.numTokens(separatedBy: CharacterSet(charactersIn: " "))
        )
        return EAOpenAIRequest(endpoint: .completions, requestBody: requestBody)
    }
}

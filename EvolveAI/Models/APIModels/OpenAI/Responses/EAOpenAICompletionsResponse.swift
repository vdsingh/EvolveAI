import Foundation

/// The response that is received from OpenAI completions requests
struct EAOpenAICompletionsResponse: EAGoalCreationAPIResponse {
    
    /// The id of the response
    let id: String
    
    /// The object used (ex: 'chat.completions')
    let object: String
    
    /// Date created
    let created: Float
    
    /// Model used for the response
    let model: EAOpenAICompletionsModel
    
    /// Choices of responses
    private let choices: [EAOpenAICompletionsChoice]
    
    /// Returns the choices available for us to choose from
    /// - Returns: the choices available for us to choose from
    func getChoices() -> [EAOpenAIChoice] {
        return self.choices
    }
}

/// Model for choices that we receive as a response from completions
struct EAOpenAICompletionsChoice: Decodable, EAOpenAIChoice {
    
    /// The text associated with the choice
    let text: String
    
    /// The index from which to start
    let index: Int
    
    /// The log probabilities on the logprobs most likely tokens, as well the chosen tokens
    let logprobs: String?
    
    /// The reason why the response was terminated
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case text
        case index
        case logprobs
        case finishReason = "finish_reason"
    }
}

protocol EAOpenAIChoice {

}

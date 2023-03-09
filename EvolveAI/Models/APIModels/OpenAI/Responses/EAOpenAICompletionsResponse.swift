import Foundation

// TODO: Docstrings

/// The response that is received from OpenAI completions requests
struct EAOpenAICompletionsResponse: EAGoalCreationAPIResponse {
    let id: String
    let object: String
    let created: Float
    let model: EAOpenAICompletionsModel
    private let choices: [EAOpenAICompletionsChoice]
    
    func getChoices() -> [EAOpenAIChoice] {
        return self.choices
    }
}

struct EAOpenAICompletionsChoice: Decodable, EAOpenAIChoice {
    let text: String
    let index: Int
    let logprobs: String?
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

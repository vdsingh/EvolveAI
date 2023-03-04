import Foundation

// TODO: Docstrings

/// The response that is received from OpenAI completions requests
struct EAOpenAICompletionsResponse: EAAPIResponse {
    let id: String
    let object: String
    let created: Float
    let model: EAOpenAICompletionsModel
    let choices: [EAOpenAICompletionsChoice]
}

struct EAOpenAICompletionsChoice: EAAPIResponse {
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

struct EAOpenAICompletionsResponseUsage: EAAPIResponse {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

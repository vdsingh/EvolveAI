import Foundation

/// The response that is received from OpenAI completions requests
struct EAOpenAICompletionsResponse: EAAPIResponse {
    let id: String
    let object: String
    let created: Float
    let model: EAOpenAICompletionsModel
    let choices: [EAOpenAICompletionsResponseChoice]
}

struct EAOpenAICompletionsResponseChoice: EAAPIResponse {
    let text: String
    let index: Int
    let logprobs: String?
    let finish_reason: String
}

struct EAOpenAICompletionsResponseUsage: EAAPIResponse {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}

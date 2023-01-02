import Foundation
struct EAOpenAICompletionsResponse: EAResponse {
    let id: String
    let object: String
    let created: Float
    let model: EAOpenAICompletionsModel
    let choices: [EAOpenAICompletionsResponseChoice]
}

struct EAOpenAICompletionsResponseChoice: EAResponse {
    let text: String
    let index: Int
    let logprobs: String?
    let finish_reason: String
}

struct EAOpenAICompletionsResponseUsage: EAResponse {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}

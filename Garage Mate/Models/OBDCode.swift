import Foundation

struct OBDCode: Identifiable, Hashable {
    var id: String { code }
    let code: String
    let title: String
    let explanation: String
    let possibleCauses: [String]
    let recommendations: [String]
}

import Foundation

@MainActor
final class ScanViewModel: ObservableObject {
    @Published var query = ""
    @Published var selectedCode: OBDCode?

    private let codeLibrary = MockData.obdCodes

    var filteredCodes: [OBDCode] {
        let cleanQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleanQuery.isEmpty {
            return codeLibrary
        }

        return codeLibrary.filter {
            $0.code.localizedCaseInsensitiveContains(cleanQuery) ||
            $0.title.localizedCaseInsensitiveContains(cleanQuery) ||
            $0.explanation.localizedCaseInsensitiveContains(cleanQuery)
        }
    }

    func chooseCode(_ code: OBDCode) {
        selectedCode = code
    }
}

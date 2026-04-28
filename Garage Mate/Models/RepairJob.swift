import Foundation

enum JobStatus: String, Codable, CaseIterable {
    case inProgress = "In Progress"
    case done = "Done"
}

enum PhotoStage {
    case before
    case after
}

struct ChecklistItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isDone: Bool
}

struct PartItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var quantity: Int
    var unitPrice: Double

    var totalPrice: Double {
        Double(quantity) * unitPrice
    }
}

struct RepairPhoto: Identifiable, Hashable, Codable {
    var id = UUID()
    var imageData: Data
    var createdAt: Date
}

struct RepairJob: Identifiable, Hashable, Codable {
    var id = UUID()
    var vehicleName: String
    var clientName: String
    var concern: String
    var status: JobStatus
    var createdAt: Date
    var elapsedSeconds: Int
    var isTimerRunning: Bool
    var checklist: [ChecklistItem]
    var parts: [PartItem]
    var beforePhotos: [RepairPhoto]
    var afterPhotos: [RepairPhoto]

    var checklistProgress: Double {
        guard !checklist.isEmpty else { return 0 }
        return Double(checklist.filter(\.isDone).count) / Double(checklist.count)
    }

    var partsTotal: Double {
        parts.reduce(0) { $0 + $1.totalPrice }
    }
}

extension RepairJob {
    static func defaultChecklist() -> [ChecklistItem] {
        [
            ChecklistItem(title: "Visual inspection", isDone: false),
            ChecklistItem(title: "Read OBD2 codes", isDone: false),
            ChecklistItem(title: "Check live sensor values", isDone: false),
            ChecklistItem(title: "Confirm repair plan", isDone: false),
            ChecklistItem(title: "Final test drive", isDone: false)
        ]
    }
}

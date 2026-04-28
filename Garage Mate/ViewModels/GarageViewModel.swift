import Foundation

@MainActor
final class GarageViewModel: ObservableObject {
    @Published private(set) var history: [RepairJob] = []
    @Published private(set) var customerCars: [String] = []
    @Published private(set) var usedParts: [PartItem] = []

    var completedJobsCount: Int {
        history.filter { $0.status == .done }.count
    }

    var activeJobsCount: Int {
        history.filter { $0.status == .inProgress }.count
    }

    var totalPartsCost: Double {
        usedParts.reduce(0) { $0 + $1.totalPrice }
    }

    func sync(from jobs: [RepairJob]) {
        history = jobs.sorted(by: { $0.createdAt > $1.createdAt })

        customerCars = Array(
            Set(history.map { "\($0.clientName) - \($0.vehicleName)" })
        ).sorted()

        usedParts = history
            .flatMap(\.parts)
            .sorted(by: { $0.name < $1.name })
    }
}

import Combine
import Foundation

@MainActor
final class JobsViewModel: ObservableObject {
    @Published private(set) var jobs: [RepairJob]

    private var ticker: AnyCancellable?
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.jobs = []
        loadJobs()
        startTicker()
    }

    deinit {
        ticker?.cancel()
    }

    var sortedJobs: [RepairJob] {
        jobs.sorted { lhs, rhs in
            if lhs.status != rhs.status {
                return lhs.status == .inProgress
            }
            return lhs.createdAt > rhs.createdAt
        }
    }

    func job(with id: UUID) -> RepairJob? {
        jobs.first(where: { $0.id == id })
    }

    func startJob(vehicleName: String, clientName: String, concern: String) {
        let cleanVehicle = vehicleName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanClient = clientName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConcern = concern.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanVehicle.isEmpty, !cleanClient.isEmpty, !cleanConcern.isEmpty else { return }

        let newJob = RepairJob(
            vehicleName: cleanVehicle,
            clientName: cleanClient,
            concern: cleanConcern,
            status: .inProgress,
            createdAt: Date(),
            elapsedSeconds: 0,
            isTimerRunning: true,
            checklist: RepairJob.defaultChecklist(),
            parts: [],
            beforePhotos: [],
            afterPhotos: []
        )
        jobs.insert(newJob, at: 0)
        persistJobs()
    }

    func toggleChecklist(jobID: UUID, itemID: UUID) {
        guard let jobIndex = jobs.firstIndex(where: { $0.id == jobID }),
              let itemIndex = jobs[jobIndex].checklist.firstIndex(where: { $0.id == itemID }) else { return }

        jobs[jobIndex].checklist[itemIndex].isDone.toggle()
        persistJobs()
    }

    func toggleTimer(jobID: UUID) {
        guard let index = jobs.firstIndex(where: { $0.id == jobID }) else { return }
        jobs[index].isTimerRunning.toggle()
        jobs[index].status = jobs[index].isTimerRunning ? .inProgress : jobs[index].status
        persistJobs()
    }

    func resetTimer(jobID: UUID) {
        guard let index = jobs.firstIndex(where: { $0.id == jobID }) else { return }
        jobs[index].elapsedSeconds = 0
        jobs[index].isTimerRunning = false
        persistJobs()
    }

    func markDone(jobID: UUID) {
        guard let index = jobs.firstIndex(where: { $0.id == jobID }) else { return }
        jobs[index].status = .done
        jobs[index].isTimerRunning = false
        persistJobs()
    }

    func addPart(jobID: UUID, name: String, quantity: Int, unitPrice: Double) {
        guard let index = jobs.firstIndex(where: { $0.id == jobID }) else { return }
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty, quantity > 0 else { return }

        let part = PartItem(name: cleanName, quantity: quantity, unitPrice: unitPrice)
        jobs[index].parts.append(part)
        persistJobs()
    }

    func addPhoto(jobID: UUID, stage: PhotoStage, imageData: Data) {
        guard let index = jobs.firstIndex(where: { $0.id == jobID }) else { return }
        let photo = RepairPhoto(imageData: imageData, createdAt: Date())

        switch stage {
        case .before:
            jobs[index].beforePhotos.append(photo)
        case .after:
            jobs[index].afterPhotos.append(photo)
        }

        persistJobs()
    }

    func persistNow() {
        persistJobs()
    }

    private func startTicker() {
        ticker = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func tick() {
        var shouldPersist = false
        for index in jobs.indices where jobs[index].isTimerRunning {
            jobs[index].elapsedSeconds += 1
            if jobs[index].elapsedSeconds.isMultiple(of: 15) {
                shouldPersist = true
            }
        }

        if shouldPersist {
            persistJobs()
        }
    }

    private func loadJobs() {
        guard let data = defaults.data(forKey: AppStorageKeys.jobs),
              let decoded = try? decoder.decode([RepairJob].self, from: data) else {
            jobs = MockData.jobs
            return
        }

        jobs = decoded
    }

    private func persistJobs() {
        guard let data = try? encoder.encode(jobs) else { return }
        defaults.set(data, forKey: AppStorageKeys.jobs)
    }
}

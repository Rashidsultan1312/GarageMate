import Foundation

enum MockData {
    static let obdCodes: [OBDCode] = [
        OBDCode(
            code: "P0420",
            title: "Catalyst System Efficiency Below Threshold",
            explanation: "The catalytic converter is not reducing emissions as expected.",
            possibleCauses: [
                "Aging catalytic converter",
                "Exhaust leak before catalyst",
                "Faulty oxygen sensor"
            ],
            recommendations: [
                "Check for exhaust leaks",
                "Inspect O2 sensor live data",
                "Verify fuel trims before replacing converter"
            ]
        ),
        OBDCode(
            code: "P0301",
            title: "Cylinder 1 Misfire Detected",
            explanation: "Cylinder 1 has intermittent or continuous misfires.",
            possibleCauses: [
                "Worn spark plug or ignition coil",
                "Low compression",
                "Injector issue"
            ],
            recommendations: [
                "Swap coil with another cylinder",
                "Inspect spark plug condition",
                "Perform compression test"
            ]
        ),
        OBDCode(
            code: "P0171",
            title: "System Too Lean (Bank 1)",
            explanation: "The engine is running with too much air and not enough fuel.",
            possibleCauses: [
                "Vacuum leak",
                "Dirty MAF sensor",
                "Weak fuel pressure"
            ],
            recommendations: [
                "Smoke test intake system",
                "Check short and long fuel trims",
                "Measure fuel pressure under load"
            ]
        ),
        OBDCode(
            code: "P0455",
            title: "EVAP System Large Leak Detected",
            explanation: "The EVAP system cannot hold pressure due to a major leak.",
            possibleCauses: [
                "Loose gas cap",
                "Cracked EVAP hose",
                "Faulty purge valve"
            ],
            recommendations: [
                "Inspect cap seal",
                "Run EVAP smoke test",
                "Command purge valve and monitor response"
            ]
        )
    ]

    static let jobs: [RepairJob] = [
        RepairJob(
            vehicleName: "2018 Honda Civic",
            clientName: "James Cooper",
            concern: "Check engine light and rough idle",
            status: .inProgress,
            createdAt: Date().addingTimeInterval(-4_800),
            elapsedSeconds: 3_120,
            isTimerRunning: true,
            checklist: [
                ChecklistItem(title: "Visual inspection", isDone: true),
                ChecklistItem(title: "Read OBD2 codes", isDone: true),
                ChecklistItem(title: "Check live sensor values", isDone: false),
                ChecklistItem(title: "Confirm repair plan", isDone: false),
                ChecklistItem(title: "Final test drive", isDone: false)
            ],
            parts: [
                PartItem(name: "Spark Plug", quantity: 4, unitPrice: 10),
                PartItem(name: "Air Filter", quantity: 1, unitPrice: 24)
            ],
            beforePhotos: [],
            afterPhotos: []
        ),
        RepairJob(
            vehicleName: "2020 Toyota RAV4",
            clientName: "Sarah Mills",
            concern: "Low power on acceleration",
            status: .done,
            createdAt: Date().addingTimeInterval(-86_400),
            elapsedSeconds: 5_700,
            isTimerRunning: false,
            checklist: [
                ChecklistItem(title: "Visual inspection", isDone: true),
                ChecklistItem(title: "Read OBD2 codes", isDone: true),
                ChecklistItem(title: "Check live sensor values", isDone: true),
                ChecklistItem(title: "Confirm repair plan", isDone: true),
                ChecklistItem(title: "Final test drive", isDone: true)
            ],
            parts: [
                PartItem(name: "MAF Sensor", quantity: 1, unitPrice: 92)
            ],
            beforePhotos: [],
            afterPhotos: []
        )
    ]
}

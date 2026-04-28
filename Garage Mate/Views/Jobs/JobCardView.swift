import SwiftUI

struct JobCardView: View {
    let job: RepairJob
    @EnvironmentObject private var settingsViewModel: AppSettingsViewModel
    @State private var animate = false

    var body: some View {
        FrostedCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(job.vehicleName)
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                        Text(job.clientName)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.78))
                    }

                    Spacer()
                    StatusBadge(status: job.status)
                }

                Text(job.concern)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Checklist")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.white.opacity(0.74))
                        Spacer()
                        Text("\(Int(job.checklistProgress * 100))%")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.white.opacity(0.82))
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.18))
                                .frame(height: 8)

                            Capsule()
                                .fill(job.status == .done ? AppTheme.success : AppTheme.accent)
                                .frame(width: max(8, geometry.size.width * job.checklistProgress), height: 8)
                                .scaleEffect(x: animate ? 1 : 0.94, y: 1, anchor: .leading)
                        }
                    }
                    .frame(height: 8)
                }

                HStack {
                    Label(job.elapsedSeconds.asTimerString, systemImage: "timer")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.82))
                    Spacer()
                    Label(job.partsTotal.asCurrencyString(settingsViewModel.selectedCurrency), systemImage: "shippingbox.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.82))
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct JobCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppBackground()
            if let firstJob = MockData.jobs.first {
                JobCardView(job: firstJob)
                    .padding()
                    .environmentObject(AppSettingsViewModel())
            }
        }
    }
}

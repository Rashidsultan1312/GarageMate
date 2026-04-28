import SwiftUI

struct GarageView: View {
    @ObservedObject var viewModel: GarageViewModel
    @EnvironmentObject private var settingsViewModel: AppSettingsViewModel

    private var latestJobs: [RepairJob] {
        Array(viewModel.history.prefix(6))
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Garage Archive")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        statCard(title: "Active", value: "\(viewModel.activeJobsCount)", tint: AppTheme.warning)
                        statCard(title: "Done", value: "\(viewModel.completedJobsCount)", tint: AppTheme.success)
                        statCard(title: "Parts Cost", value: viewModel.totalPartsCost.asCurrencyString(settingsViewModel.selectedCurrency), tint: AppTheme.accent)
                    }

                    FrostedCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Repair History")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)

                            if latestJobs.isEmpty {
                                Text("No archived repairs yet.")
                                    .foregroundColor(.white.opacity(0.8))
                            } else {
                                ForEach(latestJobs) { job in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(job.vehicleName)
                                                .foregroundColor(.white)
                                            Text(AppFormatters.shortDate.string(from: job.createdAt))
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.65))
                                        }
                                        Spacer()
                                        StatusBadge(status: job.status)
                                    }
                                    .font(.subheadline)
                                }
                            }
                        }
                    }

                    FrostedCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Clients and Vehicles")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)

                            if viewModel.customerCars.isEmpty {
                                Text("No client vehicles yet.")
                                    .foregroundColor(.white.opacity(0.8))
                            } else {
                                ForEach(viewModel.customerCars, id: \.self) { item in
                                    Text(item)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.88))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule().fill(Color.white.opacity(0.12))
                                        )
                                }
                            }
                        }
                    }

                    FrostedCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Used Parts")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)

                            if viewModel.usedParts.isEmpty {
                                Text("No parts usage yet.")
                                    .foregroundColor(.white.opacity(0.8))
                            } else {
                                ForEach(viewModel.usedParts) { part in
                                    HStack {
                                        Text("\(part.name) x\(part.quantity)")
                                            .foregroundColor(.white.opacity(0.88))
                                        Spacer()
                                        Text(part.totalPrice.asCurrencyString(settingsViewModel.selectedCurrency))
                                            .foregroundColor(.white.opacity(0.82))
                                    }
                                    .font(.subheadline)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Garage")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
    }

    @ViewBuilder
    private func statCard(title: String, value: String, tint: Color) -> some View {
        FrostedCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.72))
                Text(value)
                    .font(.headline.weight(.bold))
                    .foregroundColor(tint)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}

struct GarageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GarageView(viewModel: {
                let model = GarageViewModel()
                model.sync(from: MockData.jobs)
                return model
            }())
            .environmentObject(AppSettingsViewModel())
        }
    }
}

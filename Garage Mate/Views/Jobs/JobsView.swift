import SwiftUI

struct JobsView: View {
    @ObservedObject var viewModel: JobsViewModel
    @State private var showsNewJobSheet = false

    private var inProgressCount: Int {
        viewModel.jobs.filter { $0.status == .inProgress }.count
    }

    private var doneCount: Int {
        viewModel.jobs.filter { $0.status == .done }.count
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Active Workshop")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    FrostedCard {
                        HStack(spacing: 14) {
                            metricBlock(title: "In Progress", value: "\(inProgressCount)", tint: AppTheme.warning)
                            metricBlock(title: "Completed", value: "\(doneCount)", tint: AppTheme.success)
                            metricBlock(title: "Total", value: "\(viewModel.jobs.count)", tint: AppTheme.accent)
                        }
                    }

                    Button {
                        showsNewJobSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Start Job")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppTheme.accent)
                        )
                    }
                    .buttonStyle(.plain)

                    if viewModel.sortedJobs.isEmpty {
                        FrostedCard {
                            Text("No jobs yet. Tap Start Job to create your first repair.")
                                .foregroundColor(.white.opacity(0.82))
                        }
                    } else {
                        ForEach(viewModel.sortedJobs) { job in
                            NavigationLink {
                                JobDetailView(viewModel: viewModel, jobID: job.id)
                            } label: {
                                JobCardView(job: job)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Jobs")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $showsNewJobSheet) {
            NewJobSheet(viewModel: viewModel)
                .presentationDetents([.height(360)])
        }
    }

    @ViewBuilder
    private func metricBlock(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.75))

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JobsView(viewModel: JobsViewModel())
                .environmentObject(AppSettingsViewModel())
        }
    }
}

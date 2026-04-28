import PhotosUI
import SwiftUI
import UIKit

struct JobDetailView: View {
    @ObservedObject var viewModel: JobsViewModel
    let jobID: UUID
    @EnvironmentObject private var settingsViewModel: AppSettingsViewModel

    @State private var showsAddPartSheet = false
    @State private var beforePhotoItem: PhotosPickerItem?
    @State private var afterPhotoItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            AppBackground()

            if let job = viewModel.job(with: jobID) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        summaryCard(job)
                        checklistCard(job)
                        partsCard(job)
                        photosCard(title: "Before Repair", photos: job.beforePhotos, stage: .before)
                        photosCard(title: "After Repair", photos: job.afterPhotos, stage: .after)
                    }
                    .padding(20)
                }
                .scrollIndicators(.hidden)
            } else {
                Text("Job not found")
                    .foregroundColor(.white)
            }
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $showsAddPartSheet) {
            AddPartSheet(viewModel: viewModel, jobID: jobID)
                .presentationDetents([.height(320)])
        }
        .onChange(of: beforePhotoItem) { item in
            loadPhoto(from: item, stage: .before)
        }
        .onChange(of: afterPhotoItem) { item in
            loadPhoto(from: item, stage: .after)
        }
    }

    @ViewBuilder
    private func summaryCard(_ job: RepairJob) -> some View {
        FrostedCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(job.vehicleName)
                            .font(.title3.weight(.bold))
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

                HStack(spacing: 10) {
                    actionButton(
                        title: job.isTimerRunning ? "Pause Timer" : "Start Timer",
                        systemImage: job.isTimerRunning ? "pause.circle.fill" : "play.circle.fill",
                        color: AppTheme.accent
                    ) {
                        viewModel.toggleTimer(jobID: jobID)
                    }

                    actionButton(
                        title: "Reset",
                        systemImage: "gobackward",
                        color: .gray
                    ) {
                        viewModel.resetTimer(jobID: jobID)
                    }
                }

                HStack(spacing: 10) {
                    Label(job.elapsedSeconds.asTimerString, systemImage: "timer")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)

                    Spacer()

                    Button {
                        viewModel.markDone(jobID: jobID)
                    } label: {
                        Text("Mark Done")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(AppTheme.success.opacity(0.9))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private func checklistCard(_ job: RepairJob) -> some View {
        FrostedCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Diagnostic Checklist")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)

                ForEach(job.checklist) { item in
                    Button {
                        viewModel.toggleChecklist(jobID: jobID, itemID: item.id)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isDone ? AppTheme.success : .white.opacity(0.7))
                            Text(item.title)
                                .foregroundColor(.white.opacity(0.9))
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private func partsCard(_ job: RepairJob) -> some View {
        FrostedCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Parts")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(job.partsTotal.asCurrencyString(settingsViewModel.selectedCurrency))
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white.opacity(0.85))
                }

                if job.parts.isEmpty {
                    Text("No parts added yet.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.78))
                } else {
                    ForEach(job.parts) { part in
                        HStack {
                            Text("\(part.name) x\(part.quantity)")
                                .foregroundColor(.white.opacity(0.9))
                            Spacer()
                            Text(part.totalPrice.asCurrencyString(settingsViewModel.selectedCurrency))
                                .foregroundColor(.white.opacity(0.82))
                        }
                        .font(.subheadline)
                    }
                }

                Button {
                    showsAddPartSheet = true
                } label: {
                    Label("Add Part", systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(AppTheme.accent))
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private func photosCard(title: String, photos: [RepairPhoto], stage: PhotoStage) -> some View {
        FrostedCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)

                if photos.isEmpty {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 90)
                        .overlay {
                            Text("No photos")
                                .foregroundColor(.white.opacity(0.65))
                        }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(photos) { photo in
                                if let image = UIImage(data: photo.imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 94, height: 94)
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                }
                            }
                        }
                    }
                }

                if stage == .before {
                    PhotosPicker(selection: $beforePhotoItem, matching: .images, photoLibrary: .shared()) {
                        pickerButtonTitle(stage)
                    }
                } else {
                    PhotosPicker(selection: $afterPhotoItem, matching: .images, photoLibrary: .shared()) {
                        pickerButtonTitle(stage)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func pickerButtonTitle(_ stage: PhotoStage) -> some View {
        Label(stage == .before ? "Add Before Photo" : "Add After Photo", systemImage: "camera.fill")
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 10).fill(AppTheme.accent))
    }

    private func loadPhoto(from item: PhotosPickerItem?, stage: PhotoStage) {
        guard let item else { return }

        Task {
            if let data = try? await item.loadTransferable(type: Data.self) {
                await MainActor.run {
                    viewModel.addPhoto(jobID: jobID, stage: stage, imageData: data)
                }
            }

            await MainActor.run {
                if stage == .before {
                    beforePhotoItem = nil
                } else {
                    afterPhotoItem = nil
                }
            }
        }
    }

    @ViewBuilder
    private func actionButton(title: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(color.opacity(0.92))
                )
        }
        .buttonStyle(.plain)
    }
}

private struct AddPartSheet: View {
    @ObservedObject var viewModel: JobsViewModel
    let jobID: UUID
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var quantity = "1"
    @State private var price = ""

    private var validQuantity: Int? {
        Int(quantity)
    }

    private var validPrice: Double {
        Double(price) ?? 0
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (validQuantity ?? 0) > 0
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(alignment: .leading, spacing: 12) {
                Text("Add Part")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)

                sheetTextField("Part name", text: $name, keyboard: .default)
                sheetTextField("Quantity", text: $quantity, keyboard: .numberPad)
                sheetTextField("Unit price", text: $price, keyboard: .decimalPad)

                Button("Save") {
                    viewModel.addPart(
                        jobID: jobID,
                        name: name,
                        quantity: validQuantity ?? 1,
                        unitPrice: validPrice
                    )
                    dismiss()
                }
                .disabled(!canSave)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(canSave ? AppTheme.accent : Color.gray.opacity(0.45))
                )
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(20)
        }
    }

    @ViewBuilder
    private func sheetTextField(_ title: String, text: Binding<String>, keyboard: UIKeyboardType) -> some View {
        TextField(title, text: text)
            .keyboardType(keyboard)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.12))
            )
            .foregroundColor(.white)
    }
}

struct JobDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JobDetailView(viewModel: JobsViewModel(), jobID: MockData.jobs[0].id)
                .environmentObject(AppSettingsViewModel())
        }
    }
}

import SwiftUI

struct NewJobSheet: View {
    @ObservedObject var viewModel: JobsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var vehicleName = ""
    @State private var clientName = ""
    @State private var concern = ""

    private var canCreate: Bool {
        !vehicleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !clientName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !concern.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(alignment: .leading, spacing: 14) {
                Text("Start New Job")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)

                inputField("Vehicle", text: $vehicleName)
                inputField("Client", text: $clientName)
                inputField("Concern", text: $concern)

                HStack(spacing: 10) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))

                    Button("Create Job") {
                        viewModel.startJob(
                            vehicleName: vehicleName,
                            clientName: clientName,
                            concern: concern
                        )
                        dismiss()
                    }
                    .disabled(!canCreate)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(canCreate ? AppTheme.accent : Color.gray.opacity(0.5))
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(20)
        }
    }

    @ViewBuilder
    private func inputField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.75))
            TextField("Enter \(title.lowercased())", text: text)
                .textInputAutocapitalization(.words)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.12))
                )
                .foregroundColor(.white)
        }
    }
}

struct NewJobSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewJobSheet(viewModel: JobsViewModel())
    }
}

import SwiftUI

struct ScanView: View {
    @ObservedObject var viewModel: ScanViewModel

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("OBD2 Diagnostics")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    FrostedCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Enter code (example: P0420)")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.white.opacity(0.75))

                            TextField("Type code or symptom", text: $viewModel.query)
                                .textInputAutocapitalization(.characters)
                                .disableAutocorrection(true)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 11)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.white.opacity(0.12))
                                )
                                .foregroundColor(.white)
                        }
                    }

                    if viewModel.filteredCodes.isEmpty {
                        FrostedCard {
                            Text("No OBD2 matches. Try another code.")
                                .foregroundColor(.white.opacity(0.82))
                        }
                    } else {
                        ForEach(viewModel.filteredCodes) { code in
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    viewModel.chooseCode(code)
                                }
                            } label: {
                                FrostedCard {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(code.code)
                                                .font(.headline.weight(.bold))
                                                .foregroundColor(AppTheme.warning)
                                            Text(code.title)
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if let selectedCode = viewModel.selectedCode {
                        FrostedCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Code Details: \(selectedCode.code)")
                                    .font(.headline.weight(.bold))
                                    .foregroundColor(.white)

                                Text(selectedCode.explanation)
                                    .foregroundColor(.white.opacity(0.86))

                                itemBlock(title: "Possible Causes", items: selectedCode.possibleCauses)
                                itemBlock(title: "Recommended Actions", items: selectedCode.recommendations)
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Scan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private func itemBlock(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white.opacity(0.9))

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(AppTheme.accent)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)

                    Text(item)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScanView(viewModel: ScanViewModel())
        }
    }
}

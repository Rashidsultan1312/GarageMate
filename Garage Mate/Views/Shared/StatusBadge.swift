import SwiftUI

struct StatusBadge: View {
    let status: JobStatus

    private var tint: Color {
        status == .done ? AppTheme.success : AppTheme.warning
    }

    var body: some View {
        Text(status.rawValue)
            .font(.caption.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(tint.opacity(0.9))
            )
    }
}

struct StatusBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            StatusBadge(status: .inProgress)
            StatusBadge(status: .done)
        }
        .padding()
        .background(.black)
    }
}

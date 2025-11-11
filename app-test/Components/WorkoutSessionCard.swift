import SwiftUI

struct WorkoutSessionCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let session: WorkoutSession
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showDeleteConfirmation = false
    
    private var exerciseCountText: String {
        "\(session.exerciseCount) \(session.exerciseCount == 1 ? "exercise" : "exercises")"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with workout name and actions
            HStack {
                Button(action: onTap) {
                    Text(session.name)
                        .font(.headline)
                        .foregroundColor(CardStyleHelpers.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Menu {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(CardStyleHelpers.primaryText)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 36, height: 36) // larger hit target
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(CardStyleHelpers.headerBackground(for: colorScheme))
            .clipShape(TopRoundedCorners(radius: 28))
            
            // Content section with exercise count
            Button(action: onTap) {
                HStack {
                    Text(exerciseCountText)
                        .font(.subheadline)
                        .foregroundColor(CardStyleHelpers.secondaryText)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .glassCard(cornerRadius: 28, padding: 0)
        .contentShape(Rectangle())
        .alert("Delete Workout", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(session.name)\"? This action cannot be undone.")
        }
    }
}

#Preview {
    ZStack {
        BlurredBackgroundView()
        
        VStack(spacing: 16) {
            WorkoutSessionCard(
                session: WorkoutSession.sampleSessions[0],
                onTap: {},
                onDelete: {}
            )
            .padding(.horizontal, 16)
        }
    }
}

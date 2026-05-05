import SwiftUI

struct DiffViewerView: View {
    let oldVersion: DocVersion
    let newVersion: DocVersion
    let documentId: UUID
    @Environment(\.dismiss) private var dismiss

    private let versionStore = VersionStore()

    var changes: [ChangeItem] {
        versionStore.computeDiff(between: oldVersion, and: newVersion, documentId: documentId)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    comparisonHeader
                    diffContent
                    summaryFooter
                }
                .padding()
            }
            .navigationTitle("Compare Versions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var comparisonHeader: some View {
        HStack(spacing: 0) {
            VStack(spacing: 4) {
                Text("v\(oldVersion.versionNumber)")
                    .font(.headline)
                Text("Old")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(oldVersion.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)

            VStack(spacing: 4) {
                Text("v\(newVersion.versionNumber)")
                    .font(.headline)
                Text("Current")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(newVersion.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var diffContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Changes")
                .font(.headline)

            if changes.isEmpty {
                ContentUnavailableView {
                    Label("No Differences", systemImage: "checkmark.circle")
                } description: {
                    Text("These versions are identical")
                }
            } else {
                ForEach(changes) { change in
                    changeRow(change)
                }
            }
        }
    }

    private func changeRow(_ change: ChangeItem) -> some View {
        HStack {
            Image(systemName: changeIcon(change.type))
                .foregroundStyle(changeColor(change.type))
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(change.field.capitalized)
                    .font(.subheadline.bold())

                if let old = change.oldValue {
                    Text("Was: \(old)")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .strikethrough()
                }

                if let new = change.newValue {
                    Text("Now: \(new)")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }

            Spacer()

            Text(change.type.rawValue.capitalized)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(changeColor(change.type).opacity(0.15), in: Capsule())
                .foregroundStyle(changeColor(change.type))
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var summaryFooter: some View {
        HStack(spacing: 16) {
            Label("\(changes.filter { $0.type == .modified }.count) changed", systemImage: "pencil")
                .font(.caption)
                .foregroundStyle(.orange)
            Label("\(changes.filter { $0.type == .added }.count) added", systemImage: "plus")
                .font(.caption)
                .foregroundStyle(.green)
            Label("\(changes.filter { $0.type == .deleted }.count) removed", systemImage: "minus")
                .font(.caption)
                .foregroundStyle(.red)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func changeIcon(_ type: ChangeItem.ChangeType) -> String {
        switch type {
        case .added: return "plus.circle.fill"
        case .modified: return "pencil.circle.fill"
        case .deleted: return "minus.circle.fill"
        case .renamed: return "character.textbox"
        case .moved: return "arrow.right.circle.fill"
        }
    }

    private func changeColor(_ type: ChangeItem.ChangeType) -> Color {
        switch type {
        case .added: return .green
        case .modified: return .orange
        case .deleted: return .red
        case .renamed: return .blue
        case .moved: return .purple
        }
    }
}

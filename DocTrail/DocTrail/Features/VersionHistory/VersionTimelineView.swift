import SwiftUI
import SwiftData

struct VersionTimelineView: View {
    let document: DocumentRecord
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVersion: DocVersion?
    @State private var compareVersion: DocVersion?
    @State private var showingDiff = false
    @State private var showingRestoreAlert = false
    @State private var versionToRestore: DocVersion?

    private let versionStore = VersionStore()

    var sortedVersions: [DocVersion] {
        document.versions.sorted { $0.versionNumber > $1.versionNumber }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    documentHeaderView
                    versionTimeline
                }
                .padding()
            }
            .navigationTitle(document.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingDiff) {
                if let old = compareVersion, let current = sortedVersions.first {
                    DiffViewerView(oldVersion: old, newVersion: current, documentId: document.id)
                }
            }
            .alert("Restore Version", isPresented: $showingRestoreAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Restore") {
                    if let version = versionToRestore {
                        restoreVersion(version)
                    }
                }
            } message: {
                Text("This will create a new version based on v\(versionToRestore?.versionNumber ?? 0). The current version will be preserved.")
            }
        }
    }

    private var documentHeaderView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "doc.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading) {
                    Text(document.name)
                        .font(.title3.bold())
                    Text("v\(document.currentVersionNumber) · \(formatSize(document.fileSize)) · \(document.ownerName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if document.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var versionTimeline: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Version History")
                .font(.headline)
                .padding(.top, 16)
                .padding(.bottom, 8)

            ForEach(Array(sortedVersions.enumerated()), id: \.element.id) { index, version in
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(version.isCurrent ? Color.green : Color.gray.opacity(0.5))
                            .frame(width: 12, height: 12)

                        if index < sortedVersions.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 2)
                                .frame(minHeight: 40)
                        }
                    }
                    .padding(.top, 6)

                    versionCard(version)
                }
            }
        }
    }

    private func versionCard(_ version: DocVersion) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("v\(version.versionNumber)")
                    .font(.subheadline.bold())
                if version.isCurrent {
                    Text("Latest")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green, in: Capsule())
                }
                Spacer()
                Text(version.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Text("\(version.createdBy) · \(version.changeDescription)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                if !version.isCurrent {
                    Button {
                        versionToRestore = version
                        showingRestoreAlert = true
                    } label: {
                        Label("Restore", systemImage: "arrow.uturn.backward")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)

                    Button {
                        compareVersion = version
                        showingDiff = true
                    } label: {
                        Label("Compare", systemImage: "arrow.left.arrow.right")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func restoreVersion(_ version: DocVersion) {
        let manager = DocumentManager(versionStore: versionStore)
        do {
            let data = try manager.restoreVersion(version, for: document)
            _ = try versionStore.createVersion(
                for: document,
                fileData: data,
                author: "You",
                description: "Restored from v\(version.versionNumber)",
                modelContext: modelContext
            )
        } catch {
            print("Restore failed: \(error)")
        }
    }

    private func formatSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

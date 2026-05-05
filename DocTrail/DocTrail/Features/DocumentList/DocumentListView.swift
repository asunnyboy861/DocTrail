import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct DocumentListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DocumentRecord.modifiedAt, order: .reverse) private var documents: [DocumentRecord]
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var showingImporter = false
    @State private var showingNewVersion = false
    @State private var selectedDocument: DocumentRecord?
    @State private var showingPaywall = false

    private let versionStore = VersionStore()
    private let filters = ["All", "Recent", "Shared", "Locked"]

    var filteredDocuments: [DocumentRecord] {
        let base: [DocumentRecord]
        if searchText.isEmpty {
            base = documents
        } else {
            base = documents.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        switch selectedFilter {
        case "Recent": return base.filter { $0.category == "Recent" || $0.category.isEmpty }
        case "Shared": return base.filter { $0.isShared }
        case "Locked": return base.filter { $0.isLocked }
        default: return base
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if documents.isEmpty {
                    emptyStateView
                } else {
                    documentList
                }
            }
            .navigationTitle("DocTrail")
            .searchable(text: $searchText, prompt: "Search documents & tags...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingImporter = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingImporter,
                allowedContentTypes: [.item],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result)
            }
            .sheet(item: $selectedDocument) { doc in
                VersionTimelineView(document: doc)
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Documents Yet", systemImage: "doc.text.magnifyingglass")
        } description: {
            Text("Import your first document to start tracking versions")
        } actions: {
            Button("Import Document") {
                showingImporter = true
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var documentList: some View {
        List {
            Picker("Filter", selection: $selectedFilter) {
                ForEach(filters, id: \.self) { filter in
                    Text(filter).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))

            ForEach(filteredDocuments) { document in
                DocumentRowView(document: document)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedDocument = document
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteDocument(document)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            toggleLock(document)
                        } label: {
                            Label(document.isLocked ? "Unlock" : "Lock",
                                  systemImage: document.isLocked ? "lock.open" : "lock")
                        }
                        .tint(document.isLocked ? .green : .orange)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            selectedDocument = document
                        } label: {
                            Label("Versions", systemImage: "clock.arrow.circlepath")
                        }
                        .tint(.blue)
                    }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        do {
            guard let url = try result.get().first else { return }
            let manager = DocumentManager(versionStore: versionStore)
            let _ = try manager.importDocument(from: url, modelContext: modelContext)
        } catch {
            print("Import failed: \(error)")
        }
    }

    private func deleteDocument(_ document: DocumentRecord) {
        let manager = DocumentManager(versionStore: versionStore)
        try? manager.deleteDocument(document, modelContext: modelContext)
    }

    private func toggleLock(_ document: DocumentRecord) {
        let manager = DocumentManager(versionStore: versionStore)
        manager.toggleLock(document)
    }
}

struct DocumentRowView: View {
    let document: DocumentRecord

    private var icon: String {
        switch document.fileExtension {
        case "pdf": return "doc.fill"
        case "doc", "docx": return "doc.text.fill"
        case "xls", "xlsx": return "chart.bar.doc.horizontal.fill"
        case "ppt", "pptx": return "doc.richtext.fill"
        case "jpg", "jpeg", "png", "heic": return "photo.fill"
        default: return "doc.fill"
        }
    }

    private var versionBadge: some View {
        Text("v\(document.currentVersionNumber)")
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.purple, in: Capsule())
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(document.name)
                        .font(.headline)
                        .lineLimit(1)
                    versionBadge
                }

                HStack(spacing: 8) {
                    Text(document.ownerName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(formatSize(document.fileSize))")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if document.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }

                    if document.isShared {
                        Image(systemName: "person.2.fill")
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    }
                }

                if !document.tags.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(document.tags.prefix(3), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1), in: Capsule())
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }

            Spacer()

            Text(document.modifiedAt, style: .relative)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }

    private func formatSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

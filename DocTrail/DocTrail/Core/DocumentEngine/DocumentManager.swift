import Foundation
import SwiftData

@Observable
final class DocumentManager {
    private let versionStore: VersionStore

    init(versionStore: VersionStore) {
        self.versionStore = versionStore
    }

    func importDocument(from url: URL, modelContext: ModelContext) throws -> DocumentRecord {
        let accessing = url.startAccessingSecurityScopedResource()
        defer { if accessing { url.stopAccessingSecurityScopedResource() } }

        let data = try Data(contentsOf: url)
        let fileName = url.deletingPathExtension().lastPathComponent
        let fileExt = url.pathExtension.lowercased()

        let record = DocumentRecord(
            name: fileName,
            fileExtension: fileExt,
            fileSize: Int64(data.count)
        )

        modelContext.insert(record)

        _ = try versionStore.createVersion(
            for: record,
            fileData: data,
            author: "You",
            description: "Initial import",
            modelContext: modelContext
        )

        return record
    }

    func addVersion(
        to document: DocumentRecord,
        from url: URL,
        description: String,
        modelContext: ModelContext
    ) throws -> DocVersion {
        let accessing = url.startAccessingSecurityScopedResource()
        defer { if accessing { url.stopAccessingSecurityScopedResource() } }

        let data = try Data(contentsOf: url)

        return try versionStore.createVersion(
            for: document,
            fileData: data,
            author: "You",
            description: description,
            modelContext: modelContext
        )
    }

    func restoreVersion(_ version: DocVersion, for document: DocumentRecord) throws -> Data {
        return try versionStore.restoreVersion(version, for: document)
    }

    func deleteDocument(_ document: DocumentRecord, modelContext: ModelContext) throws {
        versionStore.deleteVersionFiles(documentId: document.id)
        modelContext.delete(document)
        try modelContext.save()
    }

    func toggleLock(_ document: DocumentRecord) {
        document.isLocked.toggle()
        document.lockOwner = document.isLocked ? "You" : nil
    }

    func addTag(_ tag: String, to document: DocumentRecord) {
        if !document.tags.contains(tag) {
            document.tags.append(tag)
        }
    }

    func removeTag(_ tag: String, from document: DocumentRecord) {
        document.tags.removeAll { $0 == tag }
    }
}

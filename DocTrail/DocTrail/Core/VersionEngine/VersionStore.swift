import Foundation
import CryptoKit
import SwiftData

@Observable
final class VersionStore {
    private let fileManager = FileManager.default
    private let versionsDirectory: URL

    init() {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        self.versionsDirectory = appSupport.appendingPathComponent("DocTrailVersions", isDirectory: true)
        try? fileManager.createDirectory(at: versionsDirectory, withIntermediateDirectories: true)
    }

    func createVersion(
        for document: DocumentRecord,
        fileData: Data,
        author: String,
        description: String,
        modelContext: ModelContext
    ) throws -> DocVersion {
        let hash = computeHash(fileData)
        let versionNumber = document.currentVersionNumber + 1

        let version = DocVersion(
            versionNumber: versionNumber,
            createdBy: author,
            changeDescription: description,
            fileSize: Int64(fileData.count),
            fileHash: hash
        )
        version.isCurrent = true
        version.documentRecord = document

        for oldVersion in document.versions {
            oldVersion.isCurrent = false
        }

        let versionFileURL = versionsDirectory
            .appendingPathComponent(document.id.uuidString, isDirectory: true)
            .appendingPathComponent("v\(versionNumber)")

        try fileManager.createDirectory(
            at: versionFileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try fileData.write(to: versionFileURL)

        document.currentVersionNumber = versionNumber
        document.modifiedAt = Date()
        document.versions.append(version)

        modelContext.insert(version)
        try modelContext.save()

        return version
    }

    func restoreVersion(_ version: DocVersion, for document: DocumentRecord) throws -> Data {
        let versionFileURL = versionsDirectory
            .appendingPathComponent(document.id.uuidString, isDirectory: true)
            .appendingPathComponent("v\(version.versionNumber)")

        return try Data(contentsOf: versionFileURL)
    }

    func computeDiff(between oldVersion: DocVersion, and newVersion: DocVersion, documentId: UUID) -> [ChangeItem] {
        var changes: [ChangeItem] = []

        if oldVersion.fileSize != newVersion.fileSize {
            changes.append(ChangeItem(
                type: .modified,
                field: "fileSize",
                oldValue: "\(oldVersion.fileSize)",
                newValue: "\(newVersion.fileSize)"
            ))
        }

        if oldVersion.fileHash != newVersion.fileHash {
            changes.append(ChangeItem(
                type: .modified,
                field: "content",
                oldValue: oldVersion.fileHash.prefix(8).lowercased(),
                newValue: newVersion.fileHash.prefix(8).lowercased()
            ))
        }

        return changes
    }

    func deleteVersionFiles(documentId: UUID) {
        let docDir = versionsDirectory.appendingPathComponent(documentId.uuidString, isDirectory: true)
        try? fileManager.removeItem(at: docDir)
    }

    private func computeHash(_ data: Data) -> String {
        let digest = SHA256.hash(data: data)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}

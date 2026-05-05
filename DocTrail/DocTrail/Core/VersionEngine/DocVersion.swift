import Foundation
import SwiftData

@Model
final class DocVersion {
    @Attribute(.unique) var id: UUID
    var versionNumber: Int
    var createdAt: Date
    var createdBy: String
    var changeDescription: String
    var fileSize: Int64
    var fileHash: String
    var parentVersionId: UUID?
    var isCurrent: Bool

    var documentRecord: DocumentRecord?

    @Relationship(deleteRule: .cascade)
    var changeItems: [ChangeItem]

    init(versionNumber: Int, createdBy: String, changeDescription: String, fileSize: Int64, fileHash: String) {
        self.id = UUID()
        self.versionNumber = versionNumber
        self.createdAt = Date()
        self.createdBy = createdBy
        self.changeDescription = changeDescription
        self.fileSize = fileSize
        self.fileHash = fileHash
        self.parentVersionId = nil
        self.isCurrent = false
        self.changeItems = []
    }
}

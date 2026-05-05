import Foundation
import SwiftData

@Model
final class DocumentRecord {
    @Attribute(.unique) var id: UUID
    var name: String
    var fileExtension: String
    var fileSize: Int64
    var createdAt: Date
    var modifiedAt: Date
    var tags: [String]
    var isLocked: Bool
    var lockOwner: String?
    var currentVersionNumber: Int
    var fileBookmarkData: Data?
    var isShared: Bool
    var ownerName: String
    var category: String

    @Relationship(deleteRule: .cascade)
    var versions: [DocVersion]

    init(name: String, fileExtension: String, fileSize: Int64, ownerName: String = "You") {
        self.id = UUID()
        self.name = name
        self.fileExtension = fileExtension
        self.fileSize = fileSize
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.tags = []
        self.isLocked = false
        self.lockOwner = nil
        self.currentVersionNumber = 0
        self.fileBookmarkData = nil
        self.isShared = false
        self.ownerName = ownerName
        self.category = "Recent"
        self.versions = []
    }
}

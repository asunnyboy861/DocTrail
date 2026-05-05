import Foundation
import SwiftData

@Model
final class ChangeItem {
    @Attribute(.unique) var id: UUID
    var typeRaw: String
    var field: String
    var oldValue: String?
    var newValue: String?

    var version: DocVersion?

    var type: ChangeType {
        get { ChangeType(rawValue: typeRaw) ?? .modified }
        set { typeRaw = newValue.rawValue }
    }

    enum ChangeType: String, Codable {
        case added, modified, deleted, renamed, moved
    }

    init(type: ChangeType, field: String, oldValue: String? = nil, newValue: String? = nil) {
        self.id = UUID()
        self.typeRaw = type.rawValue
        self.field = field
        self.oldValue = oldValue
        self.newValue = newValue
    }
}

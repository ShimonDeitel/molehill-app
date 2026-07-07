import Foundation

struct PestEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var pestType: String
    var location: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), pestType: String = "", location: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.pestType = pestType
        self.location = location
        self.notes = notes
    }
}

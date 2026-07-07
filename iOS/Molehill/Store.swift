import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [PestEntry] = []
    @Published var isProUnlocked: Bool = false

    /// Free tier keeps every seeded entry visible without hitting the paywall on first launch.
    static let freeTierLimit = 20

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = appSupport.appendingPathComponent("Molehill", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || entries.count < Store.freeTierLimit
    }

    func add(_ entry: PestEntry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: PestEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PestEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([PestEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData()
            save()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [PestEntry] {
        [
        PestEntry(pestType: "Pest Log 1", location: "Pest Log 1", notes: "Pest Log 1"),
        PestEntry(pestType: "Pest Log 2", location: "Pest Log 2", notes: "Pest Log 2"),
        PestEntry(pestType: "Pest Log 3", location: "Pest Log 3", notes: "Pest Log 3"),
        PestEntry(pestType: "Pest Log 4", location: "Pest Log 4", notes: "Pest Log 4")
        ]
    }
}

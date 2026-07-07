import XCTest
@testable import Molehill

@MainActor
final class MolehillTests: XCTestCase {
    var store: Store!

    override func setUp() async throws {
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeTierLimit)
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(PestEntry(pestType: "Test Entry"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddedEntryAppearsFirst() {
        store.add(PestEntry(pestType: "Newest"))
        XCTAssertEqual(store.entries.first?.pestType, "Newest")
    }

    func testDeleteRemovesEntry() {
        let entry = PestEntry(pestType: "ToDelete")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(entry))
    }

    func testCanAddMoreWhenBelowLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtFreeLimitWithoutPro() {
        store.entries = (0..<Store.freeTierLimit).map { _ in PestEntry(pestType: "X") }
        XCTAssertFalse(store.canAddMore)
    }

    func testAddBlockedAtLimitDoesNotAppend() {
        store.entries = (0..<Store.freeTierLimit).map { _ in PestEntry(pestType: "X") }
        let before = store.entries.count
        store.add(PestEntry(pestType: "Overflow"))
        XCTAssertEqual(store.entries.count, before)
    }

    func testUpdateModifiesExistingEntry() {
        let entry = PestEntry(pestType: "Original")
        store.add(entry)
        var updated = entry
        updated.pestType = "Updated"
        store.update(updated)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.pestType, "Updated")
    }
}

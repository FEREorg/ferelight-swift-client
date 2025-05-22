import Testing
import Foundation
@testable import FereLightSwiftClient

let host = "http://localhost"
let port = "8080"
let testDatabase = "v3c"
let testObjectId = "v_09905"
let testObjectIds = [testObjectId, "v_09906"]
let testSegmentId = "v_09905_1"
let testSegmentIds = [testSegmentId, "v_09906_1", "v_09906_2"]
let testSimilarityText = "A dog running through a field"
let testOcrText = "cabbage"
let testResultsLimit = 10
let alternativeTestDatabase = "mvk"
let alternativeTestSimilarityText = "A whale shark swimming through a field"
let testTimestamp = 0.1


@Test func getObjectInfo() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getObjectInfo(database: testDatabase, objectId: testObjectId)
    let objectName = "\(testObjectId.dropFirst(2)).mp4"
    #expect(result.objectId == testObjectId)
    #expect(result.name == objectName)
}

@Test func getSegmentInfo() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getSegmentInfo(database: testDatabase, segmentId: testSegmentId)
    #expect(result.objectId == testObjectId)
    #expect(result.segmentId == testSegmentId)
}

@Test func getObjectSegments() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getObjectSegments(database: testDatabase, objectId: testObjectId)
    #expect(result.count > 0)
    #expect(result.first?.objectId == testObjectId)
}

@Test func getObjectInfos() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getObjectInfos(database: testDatabase, objectIds: testObjectIds)
    #expect(result.count == testObjectIds.count)
}

@Test func getSegmentInfos() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getSegmentInfos(database: testDatabase, segmentIds: testSegmentIds)
    #expect(result.count == testSegmentIds.count)
}

@Test func similarityQuery() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.query(database: testDatabase, similarityText: testSimilarityText, ocrText: nil, limit: testResultsLimit)
    #expect(result.count == testResultsLimit)
}

@Test func ocrQuery() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.query(database: testDatabase, similarityText: nil, ocrText: testOcrText, limit: testResultsLimit)
    #expect(result.count > 0)
}

@Test func fullQuery() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.query(database: testDatabase, similarityText: testSimilarityText, ocrText: testOcrText, limit: testResultsLimit)
    #expect(result.count > 0)
}

@Test func similarityQueryAlternativeDatabase() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.query(database: alternativeTestDatabase, similarityText: alternativeTestSimilarityText, ocrText: nil, limit: testResultsLimit)
    #expect(result.count == testResultsLimit)
}

@Test func queryByExample() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.queryByExample(database: testDatabase, segmentId: testSegmentId, limit: testResultsLimit)
    #expect(result.count == testResultsLimit)
}

@Test func segmentByTime() async throws {
    let client = FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.segmentByTime(database: testDatabase, objectId: testObjectId, timestamp: testTimestamp)
    #expect(result == testSegmentId)
}

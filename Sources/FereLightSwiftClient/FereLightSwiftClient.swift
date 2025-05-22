import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

public struct FereLightClient : Sendable {
    let client: Client
    
    /// Instantiate client and perform login.
    public init(url: URL) {
        self.client = Client(serverURL: url, transport: URLSessionTransport())
    }
    
    /// Retrieves object information for the specified object ID.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - objectId: The ID of the object to retrieve info for.
    ///
    /// - Returns: Object information.
    public func getObjectInfo(database: String, objectId: String) async throws -> (objectId: String, mediaType: Int, name: String, path: String) {
        let response = try await client.get_sol_objectinfo_sol__lcub_database_rcub__sol__lcub_objectid_rcub_(path: .init(database: database, objectid: objectId))
        
        let message = try response.ok.body.json
        
        return (message.objectid!, message.mediatype!, message.name!, message.path!)
    }
    
    /// Retrieves segment information for the specified segment ID.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - segmentId: The ID of the segment to retrieve info for.
    ///
    /// - Returns: Segment information.
    public func getSegmentInfo(database: String, segmentId: String) async throws -> (segmentId: String, objectId: String, segmentNumber: Int, segmentStart: Int, segmentEnd: Int, segmentStartAbs: Double, segmentEndAbs: Double) {
        let response = try await client.get_sol_segmentinfo_sol__lcub_database_rcub__sol__lcub_segmentid_rcub_(path: .init(database: database, segmentid: segmentId))
        
        let message = try response.ok.body.json
        
        return (message.segmentid!, message.objectid!, message.segmentnumber!, message.segmentstart!, message.segmentend!, message.segmentstartabs!, message.segmentendabs!)
    }
    
    /// Retrieves all segments of the multimedia object with the specified objectID.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - objectId: The ID of the object to retrieve segments for.
    ///
    /// - Returns: Array of segment infos of the segments in the object.
    public func getObjectSegments(database: String, objectId: String) async throws -> [(segmentId: String, objectId: String, segmentNumber: Int, segmentStart: Int, segmentEnd: Int, segmentStartAbs: Double, segmentEndAbs: Double)] {
        let response = try await client.get_sol_objectsegments_sol__lcub_database_rcub__sol__lcub_objectid_rcub_(path: .init(database: database, objectid: objectId))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.segmentid!, $0.objectid!, $0.segmentnumber!, $0.segmentstart!, $0.segmentend!, $0.segmentstartabs!, $0.segmentendabs!) }
    }
    
    /// Retrieves object information for the specified object IDs.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - objectIds: The IDs of the objects to retrieve info for.
    ///
    /// - Returns: Object information array.
    public func getObjectInfos(database: String, objectIds: [String]) async throws -> [(objectId: String, mediaType: Int, name: String, path: String)] {
        let response = try await client.post_sol_objectinfos(body: .json(.init(database: database, objectids: objectIds)))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.objectid!, $0.mediatype!, $0.name!, $0.path!) }
    }
    
    /// Retrieves segment information for the specified segment IDs.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - segmentIds: The IDs of the segments to retrieve info for.
    ///
    /// - Returns: Segment information array.
    public func getSegmentInfos(database: String, segmentIds: [String]) async throws -> [(segmentId: String, objectId: String, segmentNumber: Int, segmentStart: Int, segmentEnd: Int, segmentStartAbs: Double, segmentEndAbs: Double)] {
        let response = try await client.post_sol_segmentinfos(body: .json(.init(database: database, segmentids: segmentIds)))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.segmentid!, $0.objectid!, $0.segmentnumber!, $0.segmentstart!, $0.segmentend!, $0.segmentstartabs!, $0.segmentendabs!) }
    }
    
    /// Queries the database with the given similarity text, ocr text, and results limit.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - similarityText: Text to use for nearest neighbor search based on a semantic embedding.
    ///   - ocrText: Text to use for a filtering text search.
    ///   - limit: Maximum number of results to return.
    ///
    /// - Returns: Array of segment ID and similarity score pairs.
    public func query(database: String, similarityText: String?, ocrText: String?, limit: Int?) async throws -> [(segmentId: String, score: Double)] {
        let response = try await client.post_sol_query(body: .json(.init(database: database, similaritytext: similarityText, ocrtext: ocrText, limit: limit)))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.segmentid!, $0.score!) }
    }
    
    /// Queries the database using the provided segment as an example.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - segmentId: The ID of the segment to use as example.
    ///   - limit: Maximum number of results to return.
    ///
    /// - Returns: Array of segment ID and similarity score pairs.
    public func queryByExample(database: String, segmentId: String, limit: Int?) async throws -> [(segmentId: String, score: Double)] {
        let response = try await client.post_sol_querybyexample(body: .json(.init(database: database, segmentid: segmentId, limit: limit)))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.segmentid!, $0.score!) }
    }
    
    /// Retrieve the segment at the specified time within the object.
    ///
    /// - Parameters:
    ///   - database: The name of the database to query.
    ///   - objectId: The ID of the object to find the segment of.
    ///   - timestamp: The time of the segment within the object.
    ///
    /// - Returns: Segment ID of the segment at the specified time within the object.
    public func segmentByTime(database: String, objectId: String, timestamp: Double) async throws -> String {
        let response = try await client.post_sol_segmentbytime(body: .json(.init(database: database, objectid: objectId, timestamp: timestamp)))
        
        let message = try response.ok.body.json
        
        return message.segmentid!
    }
}

import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension Octokit {
    /**
         Fetches the followers of the authenticated user
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myFollowers(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readAuthenticatedFollowers(configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self) { users, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let users = users {
                    completion(Response.success(users))
                }
            }
        }
    }

    /**
         Fetches the followers of a user
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter name: Name of the user
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func followers(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readFollowers(name, configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self) { users, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let users = users {
                    completion(Response.success(users))
                }
            }
        }
    }

    /**
         Fetches the users following the authenticated user
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myFollowing(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readAuthenticatedFollowing(configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self) { users, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let users = users {
                    completion(.success(users))
                }
            }
        }
    }

    /**
         Fetches the users following a user
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter name: The name of the user
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func following(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readFollowing(name, configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self) { users, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let users = users {
                    completion(Response.success(users))
                }
            }
        }
    }
}

enum FollowRouter: Router {
    case readAuthenticatedFollowers(Configuration)
    case readFollowers(String, Configuration)
    case readAuthenticatedFollowing(Configuration)
    case readFollowing(String, Configuration)

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var configuration: Configuration {
        switch self {
        case let .readAuthenticatedFollowers(config): return config
        case let .readFollowers(_, config): return config
        case let .readAuthenticatedFollowing(config): return config
        case let .readFollowing(_, config): return config
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedFollowers:
            return "user/followers"
        case let .readFollowers(username, _):
            return "users/\(username)/followers"
        case .readAuthenticatedFollowing:
            return "user/following"
        case let .readFollowing(username, _):
            return "users/\(username)/following"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}

import Foundation
@testable import MobileTechChallenge

final class ServicesMock {
    static var networkMonitor: NetworkMonitoring {
        return NetworkMonitorStub()
    }
    
    static var apiSession: APISessionProviding {
        return ApiSessionStub()
    }
}

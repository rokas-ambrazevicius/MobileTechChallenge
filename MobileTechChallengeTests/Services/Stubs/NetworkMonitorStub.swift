import Foundation
@testable import MobileTechChallenge

final class NetworkMonitorStub: NetworkMonitoring {
    var isAvailable = ObservableValue<Bool>(value: true)
    var isCellularUsed = ObservableValue<Bool>(value: true)
    var isWifiUsed = ObservableValue<Bool>(value: false)
}

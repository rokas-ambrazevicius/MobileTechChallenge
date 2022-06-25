import Network

protocol NetworkMonitoring {
    var isAvailable: ObservableValue<Bool> { get }
    var isCellularUsed: ObservableValue<Bool> { get }
    var isWifiUsed: ObservableValue<Bool> { get }
}

final class NetworkMonitor: NetworkMonitoring {
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: String(describing: NetworkMonitor.self))
    
    let isAvailable = ObservableValue<Bool>(value: true)
    let isCellularUsed = ObservableValue<Bool>(value: true)
    let isWifiUsed = ObservableValue<Bool>(value: true)
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connectionExists = path.status == .satisfied
            
            if path.usesInterfaceType(.wifi) {
                self?.isWifiUsed.value = true
                self?.isCellularUsed.value = false
            } else if path.usesInterfaceType(.cellular) {
                self?.isWifiUsed.value = false
                self?.isCellularUsed.value = true
            } else {
                self?.isWifiUsed.value = false
                self?.isCellularUsed.value = false
            }
            
            guard connectionExists != self?.isAvailable.value else { return }
            self?.isAvailable.value = connectionExists
        }
        monitor.start(queue: monitorQueue)
    }
}

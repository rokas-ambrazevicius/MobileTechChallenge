import Foundation

final class ObservableValue<T> {
    private var observers = [WeakObserver<T>]()
    
    public var value: T {
        didSet {
            removeDeallocatedObservers()
            notifyObservers()
        }
    }
    
    public init(value: T) {
        self.value = value
    }
    
    public func subscribe(_ observer: AnyObject, shouldInit: Bool, closure: @escaping(T) -> Void) {
        let newObserver = WeakObserver(observer, closure: closure)
        observers.append(newObserver)
        
        if shouldInit {
            closure(value)
        }
        
        removeDeallocatedObservers()
    }
    
    public func unsubscribe(_ observer: AnyObject) {
        observers.removeAll { $0.observer === observer }
    }
    
    // MARK: - Private -
    
    private func notifyObservers() {
        observers.forEach { $0.closure(value) }
    }
    
    private func removeDeallocatedObservers() {
        observers.removeAll { $0.observer == nil }
    }
}

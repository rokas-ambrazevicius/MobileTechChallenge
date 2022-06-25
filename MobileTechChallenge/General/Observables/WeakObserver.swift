import Foundation

final class WeakObserver<T> {
    let closure: (T) -> Void
    weak var observer: AnyObject?
    
    init(_ observer: AnyObject, closure: @escaping (T) -> Void) {
        self.observer = observer
        self.closure = closure
    }
}

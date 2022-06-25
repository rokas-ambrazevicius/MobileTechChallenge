import XCTest
import Combine
@testable import MobileTechChallenge

final class ApiSessionTests: XCTestCase {
    private  let apiSession = ApiSession()
    private var cancellableSet: Set<AnyCancellable> = []
    
    func testDownloadWebData() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api-pub.bitfinex.com"
        components.path = "/v2/conf/pub:map:currency:label"
        
        guard let url = components.url
        else {
            XCTFail("Can't create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
    }
    
    func testApiSession() {
        let request = CurrencyLabelsRequest()
        
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
            if case let .failure(error) = completion {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        
        let promise = expectation(description: "fetching currencies")
        let valueHandler: (CurrencyService.CurrencyResponseModel) -> Void = { currencies in
            XCTAssertNotNil(currencies)
            promise.fulfill()
        }
        
        apiSession.execute(request)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellableSet)
        
        wait(for: [promise], timeout: 8)
    }
}

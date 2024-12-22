import Foundation
import Combine
import Combine

struct CustomSubscriber: Subscriber {
    
    typealias Input = Int
    typealias Failure = Never
    
    
    // Add this property to conform to CustomCombineIdentifierConvertible
    var combineIdentifier: CombineIdentifier {
        return CombineIdentifier()
    }

    func receive(subscription: Subscription) {
        print("Subscribed")
        subscription.request(.unlimited) // 请求无限数量的数据
    }

    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value: \(input)")
        return .none // 不再请求更多值
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed with: \(completion)")
    }
}

let publisher = (1...5).publisher
let customSubscriber = CustomSubscriber()
publisher.subscribe(customSubscriber)

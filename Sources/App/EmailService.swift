import Foundation
import Vapor
import JobsRedisDriver

struct EmailService: Service {
    func send(to: String, from: String, message: String) -> String {
        print("EmailService - send")

        return "Sending message to: \(to), from: \(from), with message: \(message)"
    }

    func saveToRedis(_ worker: Worker) {
        print("EmailService - saveToRedis")

        //let redis = try worker.next().make(JobsRedisDriver.self)

    }

}

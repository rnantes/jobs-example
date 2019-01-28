import Foundation
import Jobs
import Vapor

struct EmailJob: Job {
    let to: String
    let from: String
    let message: String
    
    func dequeue(context: JobContext, worker: Worker) -> EventLoopFuture<Void> {
        print("EmailJob - Deque")
        print(to)
        print(from)
        print(message)

        if let emailService = context.emailService {
            print("emailService is NOT nil")
            emailService.send(to: "a", from: "b", message: "c")
        } else {
            print("emailService is nil")
        }

        return worker.future()
    }
    
    func error(context: JobContext, error: Error, worker: EventLoopGroup) -> EventLoopFuture<Void> {
        print("EmailJob - error")

        return worker.future()
    }
}

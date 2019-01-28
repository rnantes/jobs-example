import Vapor
import Jobs

/// Called after your application has initialized.
public func boot(_ app: Application) throws {

    // your code here
    let queue = try app.make(QueueService.self)
    let job = EmailJob(to: "to@to.com", from: "from@from.com", message: "A MESSAGE")
    let _ = queue.dispatch(job: job)


}

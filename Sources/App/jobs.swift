//
//  jobs.swift
//  App
//
//  Created by Jimmy McDermott on 12/3/18.
//

import Foundation
import Vapor
import Jobs

// called on startup
public func jobs(_ services: inout Services) throws {
    /// Jobs
    /// stores info about job 
    let jobsProvider = JobsProvider(refreshInterval: .seconds(10))
    try services.register(jobsProvider)

    // the service to run job actuons
    let emailService = EmailService()
    services.register { _ -> EmailService in
        return emailService
    }

    // stores the service available on dequeue
    var jobContext = JobContext()
    jobContext.emailService = emailService
    
    services.register { _ -> JobContext in
        return jobContext
    }
    
    // stores class that conforms to Job
    services.register { _ -> JobsConfig in
        var jobsConfig = JobsConfig()
        jobsConfig.add(EmailJob.self)
        return jobsConfig
    }

    // for command line
    services.register { _ -> CommandConfig in
        var commandConfig = CommandConfig.default()
        commandConfig.use(JobsCommand(), as: "jobs")
        
        return commandConfig
    }

    // scheduled jobs
    let anEmailJob = EmailJob(to: "to@to.com", from: "from@from.com", message: "\(Int.random(in: 0...100))")
    var scheduleEvaluationService = ScheduleEvaluationService()

    let recurrenceRule = try RecurrenceRule()
        .every(.years(5))
        .every(.seconds(5))
        .atHour(5)
    scheduleEvaluationService.add(ScheduledJob(job: anEmailJob, scheduleRule: recurrenceRule))
    services.register { _ -> ScheduleEvaluationService in
        return scheduleEvaluationService
    }
    
}

// allow a service to accessable in the dequeue(context:, worker:) function of your job
extension JobContext {
    var emailService: EmailService? {
        get {
            return userInfo["emailService"] as? EmailService
        }
        set {
            userInfo["emailService"] = newValue
        }
    }
}

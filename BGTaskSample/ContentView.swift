//
//  ContentView.swift
//  BGTaskSample
//
//  Created by Bartlomiej Mika on 2022-03-30.
//

import SwiftUI
import BackgroundTasks

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    func registerBGTaskScheduler() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.mikasoftware.BGTaskSample.Refresh", using: nil) { task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.mikasoftware.BGTaskSample.Processing", using: nil) { task in
             self.handleProcessingTask(task: task as! BGProcessingTask)
        }

    }
    
    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "com.mikasoftware.BGTaskSample.Refresh")
        
       // Fetch no earlier than 15 minutes from now.
//       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        // Try
        //  e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.mikasoftware.BGTaskSample.Refresh"]
        
        // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.mikasoftware.BGTaskSample.Refresh"]
            
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }
    
    func scheduleProcessing() {
       let request = BGProcessingTaskRequest(identifier: "com.mikasoftware.BGTaskSample.Processing")
        
       // Fetch no earlier than 15 minutes from now.
//       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
        // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.mikasoftware.BGTaskSample.Processing"]
            
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule processing: \(error)")
       }
    }
    
    func handleProcessingTask(task: BGProcessingTask) {
        // Create an operation that performs the main part of the background task.
        let operation = SampleOperation(text: "Hello world! v2")
        
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
           operation.cancel()
        }

        // Inform the system that the background task is complete
        // when the operation completes.
        operation.completionBlock = {
           task.setTaskCompleted(success: !operation.isCancelled)
        }

        // Start the operation.
         let queue = OperationQueue()

         queue.addOperation(operation)
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
       // Schedule a new refresh task.
       scheduleAppRefresh()

       // Create an operation that performs the main part of the background task.
       let operation = SampleOperation(text: "Hello world!")
       
       // Provide the background task with an expiration handler that cancels the operation.
       task.expirationHandler = {
          operation.cancel()
       }

       // Inform the system that the background task is complete
       // when the operation completes.
       operation.completionBlock = {
          task.setTaskCompleted(success: !operation.isCancelled)
       }

       // Start the operation.
        let queue = OperationQueue()

        queue.addOperation(operation)
     }
    
    var body: some View {
        VStack {
            Text("Hello, world!")
        }.onAppear() {
            self.registerBGTaskScheduler()
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .active {
                print("Active")
            } else if newPhase == .background {
                print("Background")
                self.scheduleAppRefresh()
                self.scheduleProcessing()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

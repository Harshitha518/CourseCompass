import SwiftUI

@main
struct MyApp: App {
    // Can be accessed by all views
    @StateObject var student = Student(studentName: "")
    @StateObject private var pageStore = PageStore()
    
    var body: some Scene {
        WindowGroup {
            // Starts with IntroView
            IntroView()
                .environmentObject(student)
                .environmentObject(pageStore)
        }
        
    }
}




import Foundation

// Attributes(information) of the student is stored here --> student's information will change and want to track and update a single instance throughout the app
class Student: Identifiable, ObservableObject {
    let id = UUID()
    
    var studentName: String // Name of user
    var currentGrade = 9 // 9, 10, 11, 12
    // Pathways for each subject
    var mathPathways = [[Course]]()
    var sciencePathways = [[Course]]()
    var englishPathways = [[Course]]()
    var historyPathways = [[Course]]()
    var langPathways = [[Course]]()
    var schedule = [Int: [Course]]()
 
    // Keeps track of electives
    @Published var completedFullYearElectives: [String?] = [nil, nil, nil, nil] // One per grade
    @Published var completedSemester1Electives: [String?] = [nil, nil, nil, nil] // One per grade
    @Published var completedSemester2Electives: [String?] = [nil, nil, nil, nil] // One per grade

    
    // Tacks all electives
     var completedElectives: [String] {
        let fullYear = completedFullYearElectives.compactMap { elective in
            if let elective = elective, !elective.isEmpty {
                return elective
            }
            return nil
        }
        let semester1 = completedSemester1Electives.compactMap { elective in
            if let elective = elective, !elective.isEmpty {
                return elective
            }
            return nil
        }
        let semester2 = completedSemester2Electives.compactMap { elective in
            if let elective = elective, !elective.isEmpty {
                return elective
            }
            return nil
        }
        
         let allElectives = fullYear + semester1 + semester2
         
         return Array(Set(allElectives))

    }
    
    init(studentName: String) {
        self.studentName = studentName
    }
    
    
    // Function which finds and returns all possible pathways of courses depending with starting course (bfs)
    func getCourses(start: String, graph: [String: [String]], courseInfo: [String: Course]) -> [[Course]] {
        
        // Check if the starting course exists in courseInfo
        guard let startCourse = courseInfo[start] else {
            print("ERROR: Start course \(start) was not found in courseInfo")
            return []
        }
        
        // Array for all pathways of courses to return
        var result: [[Course]] = []
        // Queue to keep track of nodes to visit in bfs
        var queue: [[Course]] = [[startCourse]]
        
        
        while !queue.isEmpty {
            // Continue exploring paths
            let currentPath = queue.removeFirst()
            
            // If we get to 4 courses, store this path, but continue looking for other paths
            if currentPath.count == 4 {
                result.append(currentPath)
                continue
            }
            
            // Finds the next courses, but skips if there aren't next courses
            guard let nextCourses = graph[currentPath.last!.name] else { continue }
            
            
            // Iterates over possible next courses
            for course in nextCourses {
                guard let nextCourseDetail = courseInfo[course] else { continue }
            
                // If it is an AP course
                if nextCourseDetail.name.hasPrefix("AP") {
                    // If the course is in apPrereqs
                    if let allowedPrereqs = CourseProgressions.apPrereqs[nextCourseDetail.name] {
                        // Check if it has at least 1 of listed prerequisites
                        let hasPrerequisite = currentPath.contains { allowedPrereqs.contains($0.name) }
                        if !hasPrerequisite {
                            // Skip course if prerequisites not met
                            continue
                        }
                    }
                    // If AP not in dictionary, allow it to pass by default
                } else {
                    // If it isn't an AP course, extract the base course name (remove CP/H)
                    let baseName = course.replacingOccurrences(of: " CP", with: "").replacingOccurrences(of: " H", with: "").replacingOccurrences(of: "AP ", with: "")
                    
                    // Check if another version (CP or H) already exists in the path
                    let alreadyTaken = currentPath.contains { existingCourse in existingCourse.name.replacingOccurrences(of: " CP", with: "").replacingOccurrences(of: " H", with: "") == baseName
                    }

                    if alreadyTaken {
                        // Don't add if another version exists
                        continue
                    }
                }
                // Add course to pathway if all requirements are met
                queue.append(currentPath + [nextCourseDetail])
            }
        }
        
        
        return result
    }
    
        
    
}

// To keep track of electives and elective information
struct Elective: Hashable, Identifiable, Equatable {
    let id = UUID()
    var electiveName: String
    var electiveType: String
    let allowedGrades: [Int]
    var credits = 2.5
    var grade: Int?
    var prerequisites = [String]()
    var freshman = false
    var semester: Bool {
        if credits == 2.5 {
            return true
        }
        return false
    }
    var fullYear: Bool {
        if credits == 2.5 {
            return false
        }
        return true
    }
    
    var firstElective: Bool {
        if freshman == true && prerequisites.isEmpty {
            return true
        } else {
            return false
        }
    }
}

// Defines what each course should contain
struct Course: Identifiable, Equatable {
    var id: String { return name }
    
    let name: String // "English I CP"
    let subject: String
    let difficulty: String // "CP", "H", "AP"
    let credits: Float // 5, 2.5
    var description: String = ""
}


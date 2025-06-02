
import Foundation

class ScheduleViewModel: ObservableObject {
    
    @Published var student: Student
    var electives = CourseDatabase.electives
    
    init(student: Student) {
        self.student = student
    }
      
    var completedElectives: [String] {
        student.completedElectives
    }
    
        
    var fullYearElectives: [Elective] {
        electives.filter { $0.fullYear }
    }
        
    var semesterElectives: [Elective] {
        electives.filter { $0.semester }
    }
    
    func allSelectedElectives(for grade: Int) -> [String] {
        var selected = [String]()

        // Check the full year elective for this grade.
        if grade < student.completedFullYearElectives.count, let fullYear = student.completedFullYearElectives[grade] {
            selected.append(fullYear)
          
        }
            
        return selected
    }

    
    func getAvailableElectives(grade: Int, semester: Bool, currentSelection: [String?] ) -> [Elective] {
                return electives.filter { elective in
                       // Condition 1: Check that the elective's semester flag matches
                       let matchesSemester = elective.semester == semester
                       
                       // Condition 2: Check that the elective is allowed for the given grade
                      let allowedForGrade = elective.allowedGrades.contains(grade)
                       
                       let prerequisitesMet = elective.prerequisites.allSatisfy { prereq in
                           completedElectives.contains(prereq)
                           
                       }
                    let notAlreadySelected = !currentSelection.contains(elective.electiveName)

                       
                       // Combine all conditions
                       return matchesSemester && allowedForGrade && prerequisitesMet && notAlreadySelected
                   }
                
    }
    


    
}

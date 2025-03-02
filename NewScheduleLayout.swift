

import SwiftUI
import PDFKit


struct newScheduleLayoutView: View {
    @EnvironmentObject var student: Student
    @StateObject var viewModel: ScheduleViewModel

    init(student: Student, allMathCourses: [[Course]], allScienceCourses: [[Course]], allHistoryCourses: [[Course]], allEnglishCourses: [[Course]], allLanguageCourses: [[Course]], language: String)
        {
            _viewModel = StateObject(wrappedValue: ScheduleViewModel(student: student))
            self.allMathCourses = allMathCourses
            self.allScienceCourses = allScienceCourses
            self.allHistoryCourses = allHistoryCourses
            self.allEnglishCourses = allEnglishCourses
            self.allLanguageCourses = allLanguageCourses
            self.language = language
        }


    
  
    // Pathways taken in from previous view
    @State var allMathCourses: [[Course]]
    @State var allScienceCourses: [[Course]]
    @State var allHistoryCourses: [[Course]]
    @State var allEnglishCourses: [[Course]]
    @State var allLanguageCourses: [[Course]]
    
    @State private var language: String
    
    // Pathway indicies
    @State private var mathPathwayIndex = 0
    @State private var sciencePathwayIndex = 0
    @State private var historyPathwayIndex = 0
    @State private var englishPathwayIndex = 0
    @State private var languagePathwayIndex = 0
    
    // Current pathways
    @State private var mathPathway = [Course]()
    @State private var sciencePathway = [Course]()
    @State private var historyPathway = [Course]()
    @State private var englishPathway = [Course]()
    @State private var languagePathway = [Course]()

    @State var history_12 = "Study Hall"

    // Selected elective courses
    @State private var selectedFullYearElectives: [String?] = [nil, nil, nil, nil] // One per grade
    @State private var selectedSemester1Electives: [String?] = [nil, nil, nil, nil]  // one per grade
    @State private var selectedSemester2Electives: [String?] = [nil, nil, nil, nil]  // one per grade
    
    // Filters out already selected electives so no 2 pickers have the same value
    private func filteredElectives(for grade: Int, selectedElectives: [String?], isFullYear: Bool) -> [Elective] {
        let allElectives = viewModel.getAvailableElectives(grade: grade + 9, semester: !isFullYear, currentSelection: selectedElectives)
        // Remove electives already selected in other pickers
        let selectedSet = Set(selectedElectives.compactMap { $0 })
        let filtered = allElectives.filter {
            elective in
            return ((grade ) < selectedElectives.count ? elective.electiveName == selectedElectives[grade] : false) || !selectedSet.contains(elective.electiveName)
        }
        return filtered
    }

    // Updates selections by replacing the old value with the new one
    private func updateSelections(for grade: Int, with newValue: String, selectedElectives: inout [String?], isFullYear: String) {
        for i in 0..<selectedElectives.count {
            if i != grade && selectedElectives[i] == newValue {
                selectedElectives[i] = nil
            }
        }
        
        
        // Sync back to student model
        if isFullYear == "F" {
            student.completedFullYearElectives = selectedElectives
        } else if isFullYear == "S1" {
            student.completedSemester1Electives = selectedElectives
        } else if isFullYear == "S2" {
            student.completedSemester2Electives = selectedElectives
        }
    }
    
    
    
    // List of filtered electives for each year/semester
    @State private var filteredElectives: [[Elective]] = [[Elective(electiveName: "Example 1", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 2", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 3", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 4", electiveType: "", allowedGrades: [])]]
    
    @State private var filteredElectivesSem1: [[Elective]] = [[Elective(electiveName: "Example 1", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 2", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 3", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 4", electiveType: "", allowedGrades: [])]]
    @State private var filteredElectivesSem2: [[Elective]] = [[Elective(electiveName: "Example 1", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 2", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 3", electiveType: "", allowedGrades: [])], [Elective(electiveName: "Example 4", electiveType: "", allowedGrades: [])]]

    // Keeps track of if user toggles year to be semester or full year
    @State private var gradeIsFullYear = [true, true, true, true]

    // Checks if schedule is finished
    var scheduleIsFinshed: Bool {
        var selected = [String]()
        var number = 0
        
        for grade in 0...3 {
            if gradeIsFullYear[grade] {
                number += 1
                if let electives = student.completedFullYearElectives[grade] {
                    if electives != "select" {
                        selected.append(electives)
                    }
                    
                }
            } else {
                number += 2
                if let electives1 = student.completedSemester1Electives[grade] {
                    if electives1 != "select" {
                        selected.append(electives1)
                    }
                    if let electives2 = student.completedSemester2Electives[grade] {
                        if electives2 != "select" {
                            selected.append(electives2)
                        }
                    }
                }
            }
        }
        if selected.count == number && electiveGradRequirementsCompleted {
            return true
        } else {
            return false
        }
    }
    
    @State private var electiveGradRequirementsCompleted = false
    
    // Keeps track of credits earned for each type of elective
    @State private var career = 0.0
    @State private var arts = 0.0
    @State private var financial = 0.0
    
    @State private var showingSheet = false
    
    @State private var scheduleConfirmed = false
    
    @State private var navigateToNextView = false
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical) {
                    VStack {
                        
                        Spacer()
                        
                        
                        // Grid to display schedule
                        Grid(alignment: .leading) {
                            
                            GridRow {
                                Text("*** Click on pathway buttons to see different options")
                                    .foregroundStyle(Color.accentColor)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: 250)
                                    .padding(.top)
                                    .font(.title2)
                                Text("    ")
                                    .font(.title2)
                                ForEach(9..<13) { number in
                                    HStack {
                                        Text("\(number)")
                                            .font(.title2)
                                            .bold()
                                    }
                                }
                            }
                            .padding(.vertical)
                            
                            Divider()
                                .frame(minHeight: 5)
                                .overlay(Color(.accent))
                                .padding(.horizontal)
                            
                            GridRowView(color: Color(.math), allPathways: allMathCourses, subject: "Math", pathway: $mathPathway, index: $mathPathwayIndex, lang: "")
                            
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color(.accent))
                                .padding(.horizontal)
                            
                            GridRowView(color: Color(.science), allPathways: allScienceCourses, subject: "Science", pathway: $sciencePathway, index: $sciencePathwayIndex, lang: "")
                            
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color(.accent))
                                .padding(.horizontal)
                            
                            GridRowView(color: Color(.english), allPathways: allEnglishCourses, subject: "English", pathway: $englishPathway, index: $englishPathwayIndex, lang: "")
                            
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color(.accent))
                                .padding(.horizontal)
                            
                            GridRowView(color: Color(.history),allPathways: allHistoryCourses, subject: "History", pathway: $historyPathway, index: $historyPathwayIndex, lang: "")
                            
                            
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color(.accent))
                                .padding(.horizontal)
                            
                            GridRowView(color: Color(.lang), allPathways: allLanguageCourses, subject: "Language", pathway: $languagePathway, index: $languagePathwayIndex, lang: language)
                            
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color(.accent))
                                .padding(.horizontal)
                            
                            GridRow {
                                VStack {
                                    // To evaluate electives, see if it passes graduation requirements
                                    Button {
                                       
                                        arts = 0
                                        career = 0
                                        financial = 0

                                        for electiveString in student.completedElectives {
                                            let elective = CourseDatabase.electives.first { $0.electiveName == electiveString
                                            }
                                            
                                            if let chosenElective = elective {
                                                if chosenElective.electiveType == "Visual and Performing Arts" {
                                                    arts += chosenElective.credits
                                                } else if chosenElective.electiveType == "Career Education" {
                                                    career += chosenElective.credits
                                                } else if chosenElective.electiveType == "Financial Literacy" {
                                                    financial += chosenElective.credits
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                        
                                        if arts >= 5 && career >= 5 && financial >= 2.5 {
                                            electiveGradRequirementsCompleted = true
                                        }
                                        
                                        showingSheet = true
                                            
                                    } label: {
                                        Text("Check Grad Req.")
                                            .dynamicTypeSize(.xLarge)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .foregroundStyle(.white)
                                            .padding()
                                            .background(Color.accentColor)
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 10)
                                            )
                                            .shadow(radius: 10)
                                    }
                                    .sheet(isPresented: $showingSheet, onDismiss: {
                                        showingSheet = false // Ensure the state resets
                                    }) {
                                        electiveGradInfoView(arts: arts, career: career, financial: financial, requirementsMet: electiveGradRequirementsCompleted, artsMet: arts >= 5, careerMet: career >= 5, financialMet: financial >= 2.5)
                                    }
                                }
                                Text("Elective")
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                
                                ForEach(0..<4) { grade in
                                    VStack {
                                        // Button to determine full year or semester electives
                                        HStack {
                                            Text(gradeIsFullYear[grade] == true ? "Full Year" : "Semester")
                                                .foregroundStyle(Color(.elective))
                                            Toggle("", isOn: $gradeIsFullYear[grade])
                                                .toggleStyle(CheckToggleStyle())
                                        }
                                        .onChange(of: gradeIsFullYear[grade]) {newValue in
                                            if newValue {
                                                
                                                
                                                if let sem1Elective = selectedSemester1Electives[grade] {
                                                   if let index1 = student.completedSemester1Electives.firstIndex(of: sem1Elective) {
                                                       student.completedSemester1Electives[index1] = nil
                                                       for i in (grade..<4) {
                                                           if i != grade {
                                                               student.completedSemester1Electives[i] = nil
                                                               student.completedSemester2Electives[i] = nil
                                                               student.completedFullYearElectives[i] = nil
                                                               
                                                           } else if i == grade {
                                                               student.completedSemester2Electives[i] = nil
                                                              
                                                           }
                                                       }
                                                    }
                                                }
                                                
                                                if let sem2Elective = selectedSemester2Electives[grade] {
                                                   if let index2 = student.completedSemester2Electives.firstIndex(of: sem2Elective) {
                                                       student.completedSemester2Electives[index2] = nil
                                                       for i in (grade..<4) {
                                                           if i != grade {
                                                               student.completedSemester1Electives[i] = nil
                                                               student.completedSemester2Electives[i] = nil
                                                               student.completedFullYearElectives[i] = nil
                                                              
                                                           } else if i == grade {
                                                               student.completedSemester1Electives[i] = nil
                                    
                                                           }
                                                       }
                                                    }
                                                }
                                                
                                                // Reset selected semester courses
                                                selectedSemester1Electives[grade] = nil
                                                selectedSemester2Electives[grade] = nil
                                                
                                            } else {
                                                if let fullyrElective = selectedFullYearElectives[grade] {
                                                    if let index3 = student.completedFullYearElectives.firstIndex(of: fullyrElective) {
                                                       student.completedFullYearElectives[index3] = nil
                                                    }
                                                }
                                                for i in (grade..<4) {
                                                    if i != grade {
                                                        student.completedFullYearElectives[i] = nil
                                                        student.completedSemester1Electives[i] = nil
                                                        student.completedSemester2Electives[i] = nil
                                                    }
                                                selectedFullYearElectives[grade] = nil
                                            }
                                            
                                            }
                                            
                                        }
                                        
                                        if gradeIsFullYear[grade] {
                                            //  Full year picker
                                            Picker("Select Full Year Elective", selection: Binding(
                                                get: { selectedFullYearElectives[grade] ?? "" },
                                                set: { newValue in
                                                    selectedFullYearElectives[grade] = newValue
                                                    updateSelections(for: grade, with: newValue, selectedElectives: &selectedFullYearElectives, isFullYear: "F")}
                                            )) {
                                                
                                                ForEach(filteredElectives[grade],id: \.electiveName) { elective in
                                                    Text(elective.electiveType == "placeholder" ? "select elective" : "\(elective.electiveName) - \(elective.electiveType == "Visual and Performing Arts" ? "Vis. & Perf. Arts" : elective.electiveType)")
                                                }
                                                
                                            }
                                            .onChange(of: selectedFullYearElectives[grade] ?? "") { newValue in
                                                // Refresh available electives based on picker changes and prerequisites
                                                for i in (grade..<4) {
                                                    if i != grade {
                                                        filteredElectives[i] = filteredElectives(for: i, selectedElectives: student.completedElectives, isFullYear: true)
                                                     
                                                    }
                                                    filteredElectivesSem1[i] = filteredElectives(for: i, selectedElectives:  student.completedElectives, isFullYear: false)
                                                    filteredElectivesSem2[i] = filteredElectives(for: i, selectedElectives:  student.completedElectives, isFullYear: false)
                                                    
                                                }
                                                electiveGradRequirementsCompleted = false
                                                
                                                
                                            }
                                        } else {
                                            // 1st Sememster Electives
                                            Picker("Select Semester Elective", selection: Binding(
                                                get: { selectedSemester1Electives[grade] ?? ""  },
                                                set: { newValue in
                                                    selectedSemester1Electives[grade] = newValue
                                                    updateSelections(for: grade, with: newValue, selectedElectives: &selectedSemester1Electives, isFullYear: "S1")}
                                            )) {
                                                
                                                ForEach(filteredElectivesSem1[grade], id: \.electiveName) { elective in
                                                    Text(elective.electiveType == "placeholder" ? "select elective" : "\(elective.electiveName) - \(elective.electiveType == "Visual and Performing Arts" ? "Vis. & Perf. Arts" : elective.electiveType)")

                                                }
                                                
                                            }
                                            .onChange(of: selectedSemester1Electives[grade] ?? "") { newValue in
                                               
                                                for i in (grade..<4) {
                                                    if i != grade {
                                                        filteredElectivesSem1[i] = filteredElectives(for: i, selectedElectives:  student.completedElectives, isFullYear: false)
                                                        student.completedSemester1Electives[i] = nil
                                    
                                                        
                                                    }
                                                 
                                                    filteredElectivesSem2[i] = filteredElectives(for: i, selectedElectives:  student.completedElectives, isFullYear: false)
                                                    
                                                    filteredElectives[i] = filteredElectives(for: i, selectedElectives: student.completedElectives, isFullYear: true)
                                                    
                                                   student.completedSemester2Electives[i] = nil
                                                   student.completedFullYearElectives[i] = nil
                                                   selectedFullYearElectives[i] = nil
                                                   selectedSemester2Electives[i] = nil
                                                    
                                                }
                                                electiveGradRequirementsCompleted = false
                                            }
                                            
                                            // 2nd Sememster Electives
                                            Picker("Select Semester Elective", selection: Binding(
                                                get: { selectedSemester2Electives[grade] ?? ""  },
                                                set: { newValue in
                                                    selectedSemester2Electives[grade] = newValue
                                                    updateSelections(for: grade, with: newValue, selectedElectives: &selectedSemester2Electives, isFullYear: "S2")}
                                            )) {
                                                
                                                ForEach(filteredElectivesSem2[grade],id: \.electiveName) { elective in
                                                    Text(elective.electiveType == "placeholder" ? "select elective" : "\(elective.electiveName) - \(elective.electiveType == "Visual and Performing Arts" ? "Vis. & Perf. Arts" : elective.electiveType)")

                                                }
                                                
                                            }
                                            .onChange(of: selectedSemester2Electives[grade] ?? "") { newValue in
                                                for i in (grade..<4) {
                                                    if i != grade {
                                                        filteredElectivesSem2[i] = filteredElectives(for: i, selectedElectives: student.completedElectives, isFullYear: false)
                                                        filteredElectivesSem1[i] = filteredElectives(for: i, selectedElectives:  student.completedElectives, isFullYear: false)
                                                        selectedFullYearElectives[i] = nil
                                                        selectedSemester1Electives[i] = nil
                                                        selectedSemester2Electives[i] = nil
                                                        student.completedFullYearElectives[i] = nil
                                                        student.completedSemester1Electives[i] = nil
                                                        student.completedSemester2Electives[i] = nil
                                                    }
                                                      
                                                        
                                                        filteredElectives[i] = filteredElectives(for: i, selectedElectives: student.completedElectives, isFullYear: true)
                                                    
                                                }
                                               
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    .onAppear {
                                        filteredElectives[grade] = filteredElectives(for: grade, selectedElectives: selectedFullYearElectives, isFullYear: true)
                                        filteredElectivesSem1[grade] = filteredElectives(for: grade, selectedElectives: selectedSemester1Electives, isFullYear: false)
                                        filteredElectivesSem2[grade] = filteredElectives(for: grade, selectedElectives: selectedSemester2Electives, isFullYear: false)
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                        .padding()
                        .border(Color(.accent), width: 5)
                        .padding()
                        .padding(.top, 35)
                        
                        Text("*** Make sure to select electives in order. Start with 9th grade and then move on. If you don't your selections will be reset to ensure prerequisites are met.")
                        .foregroundStyle(Color.accentColor)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.bottom, 35)
                       
                        
                        HStack {
                            VStack {
                                NavigationLink(destination: StartView()) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Reselect 9th Grade Courses")
                                    }
                                    .dynamicTypeSize(.xxxLarge)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color.accentColor)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 10)
                                    )
                                    .shadow(radius: 10)
                                }
                                .padding(.horizontal)
                                
                                Text("*** If you have made a mistake with the courses you selected for 9th grade, or would like to select new courses, click above to reselect. IMPORTANT: Your schedule here will be lost.")
                                    .foregroundStyle(Color.accentColor)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: 350)
                                    .padding(.top)
                            }
                            Spacer()
                            VStack{
                                VStack {
                                Button {
                                    student.schedule = [
                                        9: [mathPathway[0], englishPathway[0], sciencePathway[0], historyPathway[0], languagePathway[0]],
                                        10: [mathPathway[1], englishPathway[1], sciencePathway[1], historyPathway[1], languagePathway[1]],
                                        11: [mathPathway[2], englishPathway[2], sciencePathway[2], historyPathway[2], languagePathway[2]],
                                        12: [mathPathway[3], englishPathway[3], sciencePathway[3], historyPathway[3], languagePathway[3]]
                                    ]
                                    
                                    let pdfURL = generateAndSavePDF()
                                    openPDF(url: pdfURL)
                                    
                                    
                                } label: {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Save Schedule - pdf")
                                    }
                                    .dynamicTypeSize(.xxxLarge)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(scheduleIsFinshed ? Color.accentColor : Color.gray)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 10)
                                    )
                                    .shadow(radius: 10)
                                    
                                }
                                .disabled(!scheduleIsFinshed)
                                    
                                NavigationLink(destination: IntroView(), isActive: $navigateToNextView) {
                                                    EmptyView()
                                                }
                            }
                            .alert(isPresented: $scheduleConfirmed) {
                                Alert(title: Text("You've Done It!"), message: Text("You've created a 4-year plan, tailored to fit you! It is important to have a plan to help navigate your complex high school journey. However, you may not always be able to follow your plan. If so, just re-adjust your schedule to find a new path!"), dismissButton: .default(Text("OK!")))
                            }
                            .alert("You've Done It!", isPresented: $scheduleConfirmed) {
                                Button("OK", role: .cancel) { }
                                Button("Return To Start") {
                                    navigateToNextView = true
                                }
                            } message: {
                                Text("You've created a 4-year plan, tailored to fit you! It is important to have a plan to help navigate your complex high school journey. However, you may not always be able to follow your plan. If so, just re-adjust your schedule to find a new path!")
                            }

                                
                                Text(scheduleIsFinshed ? "*** You have successfully met all graduation requirements. You're schedule is good to go! Click above to save or share your schedule." : "*** It doesn't seem like you've met all graduation requirements. Select the 'Check Grad Req.' button by your elective pathway to ensure all requirements have been met. Then, you can save your accurate schedule.")
                                .foregroundStyle(Color.accentColor)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: 350)
                                .padding(.top)
                                
                        }
                            
                        }
                        .padding(.horizontal, 300)
                        
                        Spacer()
                        
                        VStack {
                            Text("Alter Your Journey!")
                                .dynamicTypeSize(.large)
                                .scaleEffect(2)
                                .foregroundStyle(Color.accentColor)
                                .padding()
                            
                            ListView(image: "checkmark.seal", text: "Evaluate your schedule! Take a look to see if it's right for you.", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                            ListView(image: "mountain.2", text: "Explore your options! Click on the pathway button on the left of each subject. Some have more pathways than others. Choose one that is best fit for you for each subject.", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                            ListView(image: "mappin", text: "Understand your selections! Click on the name of each course on your schedule to get more information about the course.", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                            ListView(image: "globe.europe.africa.fill", text: "Understand the big picture! Select the navigation guide on the upper-right corner to see all courses offered. You may not be eligible for all of them.", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                            ListView(image: "pencil.line", text: "Create your own path! Select your electives, full year or semester. As you select courses and prerequisites are met, more courses will be displayed.", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                            ListView(image: "road.lanes.curved.right", text: "Check if you are on the right path! Click on the 'Check Grad Req.' button above to check if elective graduation requirements are met. You MUST do so to get an accurate schedule you can save. Your other requirement will automatically be met by the generated pathways. ", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                            ListView(image: "map", text: "Take your map along with you on your journey! Export, share, & save a simple PDF version of your schedule for future reference. Keep in mind plans are subject to the availability of the master schedule which changes each year. You may not always get the course you planned on taking but thats okay. There is always more than one pathway to the same destination!", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                            
                        }
                        .padding(.vertical, 50)
                        
                        Button {
                            scheduleConfirmed = true
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                Text("Finished?")
                                Spacer()
                            }
                            .dynamicTypeSize(.xxxLarge)
                            .foregroundStyle(.white)
                            .padding()
                            .background(scheduleIsFinshed ? Color.accentColor : Color.gray)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            .shadow(radius: 10)
                        }
                        .disabled(!scheduleIsFinshed)
                        .padding(.bottom)
                        .padding(.horizontal, 100)

                        
                    }
                }
            .onAppear(perform: {
                student.completedFullYearElectives = [nil, nil, nil, nil]
                student.completedSemester1Electives = [nil, nil, nil, nil]
                student.completedSemester2Electives = [nil, nil, nil, nil]
            })
            
            .navigationTitle(student.studentName == "" ? "Your Schedule" : "\(student.studentName)'s Schedule")
            .navigationBarTitleDisplayMode(.large)
            .background {
                Color(.background)
                    .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                NavigationLink {
                    CourseCatalogView()
                } label: {
                    Image(systemName: "book.and.wrench")
                        .dynamicTypeSize(.xxxLarge)
                        .foregroundStyle(Color.accentColor)
                    
                }

            }
        }
    }
    
    // To generate and dave a PDF format of the schedule
    func generateAndSavePDF() -> URL {
        let pdfMetaData = [
            kCGPDFContextCreator: "Schedule Generator",
            kCGPDFContextAuthor: "Harshitha Rajesh"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        // Save to Documents directory
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = documentsURL.appendingPathComponent("StudentSchedule.pdf")

        do {
            let data = renderer.pdfData { context in
                context.beginPage()

                let title = student.studentName == "Your" ? "\(student.studentName) Schedule" : "Student Schedule: \(student.studentName)"
                let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
                title.draw(at: CGPoint(x: 50, y: 20), withAttributes: attributes)

                var yPosition: CGFloat = 60

                for grade in 9...12 {
                    if let courses = student.schedule[grade] {
                        let gradeText = "Grade \(grade):"
                        gradeText.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: attributes)
                        yPosition += 20
                        
                        for course in courses {
                            if language == "Latin" || language == "American Sign Language" {
                                language = ""
                            }
                            let courseText = course.subject == "Language" ? "- \(course.name) \(language)" : "- \(course.name)"
                            courseText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: nil)
                            yPosition += 20
                        }
                        
                    }
                    if gradeIsFullYear[grade - 9] {
                        if let electives = student.completedFullYearElectives[grade - 9] {
                            let electiveText = "- \(electives)"
                            electiveText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: nil)
                            yPosition += 20
                        }
                    } else {
                        if let electives = student.completedSemester1Electives[grade - 9] {
                            let electiveText = "- \(electives)"
                            electiveText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: nil)
                            yPosition += 20
                        }
                        
                        if let electives = student.completedSemester2Electives[grade - 9] {
                            let electiveText = "- \(electives)"
                            electiveText.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: nil)
                            yPosition += 20
                        }
                    }
                    yPosition += 10
                }
            }
            try data.write(to: pdfURL)
            print("PDF saved at: \(pdfURL.path)")
        } catch {
            print("Couldn't save PDF: \(error)")
        }
        
        return pdfURL
    }

    func openPDF(url: URL) {
        #if os(macOS)
        // If macOS open in Finder
        NSWorkspace.shared.open(url)
        #else
        // If iOS open share sheet
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
        #endif
        
    }
}

// Elective toggle button style
struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(Color(.elective))
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}

// Elective evaluating view
struct electiveGradInfoView: View {
    @Environment(\.dismiss) var dismiss
    let arts: Double
    let career: Double
    let financial: Double
    
    let requirementsMet: Bool
    
    let artsMet: Bool
    let careerMet: Bool
    let financialMet: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text(artsMet ? "You have met your Visual & Performing Arts requirements." : "You have not met your Visual & Performing Arts requirements.")
                        .bold()
                        .font(.title)
                        .foregroundStyle(artsMet ? .green : .red)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Text("You must complete 5.0 Visual & Performing Arts credits.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Text("You have completed \(String(format: "%.1f", round(arts * 10) / 10.0)) Visual & Performing Arts credits.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    
                    Spacer()
                    
                    Text(careerMet ? "You have met your Career Education requirements." : "You have not met your Career Education requirements.")
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(careerMet ? .green : .red)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Text("You must complete 5.0 Career Education credits.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Text("You have completed \(String(format: "%.1f", round(career * 10) / 10.0)) Career Education credits.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()

                    Spacer()
                    
                    Text(financialMet ? "You have met your Financial Literacy requirements." : "You have not met your Financial Literacy requirements.")
                        .bold()
                        .font(.title)
                        .foregroundStyle(financialMet ? .green : .red)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Text("You must complete 2.5 Financial Literacy credits.")                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(Color.accentColor)
                        .padding()
                    Text("You have completed \(String(format: "%.1f", round(arts * 10) / 10.0)) Financial Literacy credits.")
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(Color.accentColor)
                        .padding()

                   
                    
                    Spacer()
                    
                    Button{
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "x.circle")
                            Text("Close")
                        }
                        .dynamicTypeSize(.xxxLarge)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .shadow(radius: 10)
                    }
                    .padding()
                }
                .padding(.horizontal, 50)
                .background(Color(.background))
                .navigationTitle(requirementsMet == true ? "Graduation Requirements Met" : "Graduation Requirements Not Met")
                
            }
            
        }
    }
}

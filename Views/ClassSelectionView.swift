
import SwiftUI

// Page per course
class Page: Identifiable, Equatable {
    
    
    let id = UUID()
    var subject: String
    var subjectPathways: [[Course]] = [[Course]]()

    var directions: String
    var additionalInfo: String?
    var allSubjectStartCourses: [String]
    var subjectDetails: [String: Course]
    var subjectProgressions: [String: [String]]
    var firstSubject: String
    var color: Color
    var image: String
    var tag: Int
    

    
    init(
        subject: String,
        directions: String,
        additionalInfo: String? = nil,
        allSubjectStartCourses: [String],
        subjectDetails: [String: Course],
        subjectProgressions: [String: [String]],
        firstSubject: String,
        color: Color,
        image: String,
        tag: Int
    ) {
        self.subject = subject
        //self.subjectPathways = subjectPathways
        self.directions = directions
        self.additionalInfo = additionalInfo
        self.allSubjectStartCourses = allSubjectStartCourses
        self.subjectDetails = subjectDetails
        self.subjectProgressions = subjectProgressions
        self.firstSubject = firstSubject
        self.color = color
        self.image = image
        self.tag = tag

    }
    
    // To ensure it is Equatable
    static func == (lhs: Page, rhs: Page) -> Bool {
            lhs.id == rhs.id
    }

}

class PageStore: ObservableObject {
    @Published var pages: [Page]
    
    init() {
        self.pages = [
            Page(subject: "Math", directions: "To start, select the math course which you have been placed into or plan on taking for 9th grade.", allSubjectStartCourses: ["Algebra I CP", "Geometry CP", "Geometry H", "Algebra II CP", "Algebra II/Trigonometry H"], subjectDetails: CourseDatabase.mathCourseDetails, subjectProgressions: CourseProgressions.mathProgressionGraph, firstSubject: "Algebra I CP", color: Color(.math), image: "BGMath", tag: 0),
            Page(subject: "Science", directions: "Now, select the science course which you have been placed into or plan on taking for 9th grade.", allSubjectStartCourses: ["Environmental Science CP", "Environmental Science H", "Biology CP", "Biology H", "Chemistry H"], subjectDetails: CourseDatabase.scienceCourseDetails, subjectProgressions: CourseProgressions.scienceProgressionGraph, firstSubject: "Environmental Science CP", color: Color(.science), image: "BGScience", tag: 1),
            Page(subject: "English", directions: "It's time to select the english course which you have been placed into or plan on taking for 9th grade.", allSubjectStartCourses: ["English I CP", "English I H"], subjectDetails: CourseDatabase.englishCourseDetails, subjectProgressions: CourseProgressions.englishProgressionGraph, firstSubject: "English I CP", color: Color(.english), image: "BGEnglish", tag: 2),
            Page(subject: "History", directions: "Next, select the History course which you have been placed into or plan on taking for 9th grade.", allSubjectStartCourses: ["World History/Cultures CP", "World History H"], subjectDetails: CourseDatabase.historyCourseDetails, subjectProgressions: CourseProgressions.historyProgressionGraph, firstSubject: "World History/Cultures CP", color: Color(.history), image: "BGHistory", tag: 3),
            Page(subject: "Language", directions: "Lastly, choose which language you are taking or plan to take in highschool.", additionalInfo: "Now, select the level you have been placed into or plan on taking for 9th grade.", allSubjectStartCourses: ["Level I CP - ", "Level II CP - ", "Level III CP - "], subjectDetails: CourseDatabase.languageCourseDetails, subjectProgressions: CourseProgressions.langProgressionGraph, firstSubject: "Level I CP - ", color: Color(.lang), image: "BGLanguage", tag: 4)
        ]
    }
    
}

// Selecting each 9th grade course
struct ClassSelectionView: View {
    @EnvironmentObject var student: Student
    var page: Page
    
    @Binding var language: String
    @Binding var firstCourse: String
    @State private var langPlacementDiffers = true
    
    let langOptions = ["Spanish", "Chinese", "French", "Italian", "German", "Latin", "American Sign Language"]
  
    var singleLangFinal: String {
        if language == "Latin" {
            return "Latin I CP"
        } else if language == "American Sign Language" {
            return "American Sign Language I CP"
        }
        return language
    }
    
    var langStart: [String] {
        if language == "Latin" {
            firstCourse = "Latin I CP"
            return ["Latin I CP"]
        } else if language == "American Sign Language" {
            firstCourse = "American Sign Language I CP"
            return ["American Sign Language I CP"]
        } else {
            if firstCourse == "Latin I CP" || firstCourse == "American Sign Language I CP" {
                firstCourse = "Level I CP - "
                language = "Spanish"
            }
            return page.allSubjectStartCourses
        }
        
    }
    
    
    init(page: Page, firstCourse: Binding<String>, language: Binding<String>) {
        self.page = page
        self._firstCourse = firstCourse
        self._language = language
        
    }

    
    var body: some View {
        ZStack {
            Image(page.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading) {
                    Text("Getting Started...")
                        .font(.title)
                        .padding(.leading, 50)
                        .scaleEffect(1.5)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack(alignment: .center, spacing: 16) {
                        Text("\(page.subject) Courses:")
                            .foregroundStyle(.white)
                            .dynamicTypeSize(.xxxLarge)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(minWidth: 500)
                                    .foregroundStyle(page.color)
                            }
                            .shadow(radius: 3)
                        
                        Text(page.directions)
                            .multilineTextAlignment(.leading)
                            .font(.title)
                            .foregroundStyle(Color.accentColor)
                            .background(Color(.background))
                        
                        if page.subject == "Language" {
                            Picker("Language", selection: $language) {
                                ForEach(langOptions, id: \.self) { lang in
                                    Text(lang)
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                            .scaleEffect(2)
                            .onChange(of: language) { newValue in
                                if language == "Latin" || language == "American Sign Language" {
                                    langPlacementDiffers = false
                                } else {
                                    langPlacementDiffers = true
                                }
                            }
                        }
                        
                        
                        Picker("\(page.subject) Course", selection: $firstCourse) {
                            ForEach(langStart, id: \.self) { course in
                                if page.subject == "Language" {
                                    if langPlacementDiffers {
                                        Text("\(course) \(language)")
                                            .foregroundStyle(Color.accentColor)
                                    } else {
                                        Text("\(course)")
                                            .foregroundStyle(Color.accentColor)
                                    }
                                } else {
                                    Text(course)
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                            
                        }
                        .onChange(of: firstCourse, perform: {newValue in
                            if page.subject == "Language" {
                                page.firstSubject = singleLangFinal
                            }
                            page.firstSubject = firstCourse
                        })
                        .pickerStyle(.inline)
                        .scaleEffect(1.2)
                        
                        Text("*** NOTE: If your wish to modify your selection for 9th grade or change your mind, you can always change them later, once you have your schedule.")
                            .foregroundStyle(Color.accentColor)
                            .multilineTextAlignment(.leading)
                            .background(Color(.background))
                            .padding(.top)
                            .padding(.bottom, 200)
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, 100)
                    .padding()
                }
                  
            }
                
            }
        }
    }
}

struct StartView: View {
    @EnvironmentObject var student: Student
    @EnvironmentObject var pageStore: PageStore
    
    @State private var pageIndex = 0
    private var pages: [Page] {
        pageStore.pages
    }
    
    @State private var selectedCourses = false
    
    @State var language: String = "Spanish"
    @State var firstCourse: String = "Level I CP - "
    let firstCourses = ["Algebra I CP", "Environmental Science CP", "English I CP", "World History/Cultures CP", "Lecel I CP - Spanish"]
    
    @State private var showingSheet = false
    
    var body: some View {
            NavigationStack {
                
                TabView(selection: $pageIndex) {
                    ForEach(pageStore.pages.indices) { index in
                        let page = pageStore.pages[index]
                        VStack {
                            
                            ClassSelectionView(page: page, firstCourse: $firstCourse, language: $language)
                            
                                Button {
                                    // Logic to set 9th grade courses
                                    
                                    if page.subject == "Language" {
                                        firstCourse = ClassSelectionView(page: page, firstCourse: $firstCourse, language: $language).firstCourse
                                        page.firstSubject = firstCourse
                                        
                                    }
                                    
                                    pageStore.pages[index].firstSubject = firstCourse
                                    
                                    pageStore.pages[index].subjectPathways = student.getCourses(
                                        start: firstCourse,
                                        graph: page.subjectProgressions,
                                        courseInfo: page.subjectDetails
                                    )
                                    
                                    if pageStore.pages[index].subjectPathways.isEmpty {
                                        
                                        pageStore.pages[index].subjectPathways = student.getCourses(
                                            start: firstCourses[index],
                                            graph: page.subjectProgressions,
                                            courseInfo: page.subjectDetails
                                                                        )
                                        }
                                    
                                    // Show navigation link to next view if last page
                                    if page == pages.last {
                                        selectedCourses = true
                                    } else {
                                        pageIndex += 1
                                    }
                                    
                                } label: {
                                    HStack {
                                        Image(systemName: "checkmark.circle")
                                        Text("Confirm")
                                    }
                                    .dynamicTypeSize(.xxxLarge)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(selectedCourses ? Color.gray : Color.accentColor)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 10)
                                    )
                                    .shadow(radius: page == pages.last ? 30 : 10)
                                }
                                .padding(.bottom)
                                .onChange(of: firstCourse) { newValue in
                                    selectedCourses = false
                                }
                                .disabled(selectedCourses == true ? true : false)
                            
                            if page == pages.last && selectedCourses {
                                
                                NavigationLink {
                                    newScheduleLayoutView(student: student,
                                        allMathCourses: pages[0].subjectPathways,
                                        allScienceCourses: pages[1].subjectPathways,
                                        allHistoryCourses: pages[3].subjectPathways,
                                        allEnglishCourses: pages[2].subjectPathways,
                                        allLanguageCourses: pages[4].subjectPathways,
                                        language: language
                                    )
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.forward")
                                        Text("See Schedule")
                                    }
                                    .dynamicTypeSize(.xxxLarge)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color.accentColor)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 10)
                                    )
                                    .shadow(radius: 30)
                                }
                                .padding(.bottom)
                                
                            }
                            
                        }
                        .tag(page.tag)
                    }
                    .background {
                        Color(.background)
                            .ignoresSafeArea()
                    }
                    .navigationBarBackButtonHidden()
                }
            }
        }
    }

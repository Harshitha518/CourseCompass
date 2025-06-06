

import SwiftUI

// View which displays all courses offered at school with information about each
struct CourseCatalogView: View {
    @Environment(\.dismiss) var dismiss
    
    let displayElectives = CourseDatabase.electives.dropFirst(2)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Navigation Guide - All Courses Offered")
                    .font(.title)
                    .padding(.leading, 100)
                    .scaleEffect(1.5)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top)
                
                VStack {
                    Text("*** Note that not all courses may be available to take. Only courses shown in pathways & elective choices, depending on your 9th grade courses, are open to you.")
                        .foregroundStyle(Color.accentColor)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                    
                    Text("Math")
                        .font(.title)
                        .dynamicTypeSize(.xxxLarge)
                        .scaleEffect(1.5)
                        .foregroundStyle(Color(.math))
                        .bold()
                        .padding()
                    ForEach(CourseDatabase.mathCourseDetails.keys.sorted(), id: \.self) { key in
                        if let course = CourseDatabase.mathCourseDetails[key] {
                            CourseDescriptions(course: course, color: Color(.math))
                        }
                    }
                    
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color(.accent))
                        .padding(.horizontal)
                    
                    Text("Science")
                        .font(.title)
                        .dynamicTypeSize(.xxxLarge)
                        .scaleEffect(1.5)
                        .foregroundStyle(Color(.science))
                        .bold()
                        .padding()
                    ForEach(CourseDatabase.scienceCourseDetails.keys.sorted(), id: \.self) { key in
                        if let course = CourseDatabase.scienceCourseDetails[key] {
                            CourseDescriptions(course: course, color: Color(.science))
                        }
                    }
                    
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color(.accent))
                        .padding(.horizontal)
                    
                    Text("English")
                        .font(.title)
                        .dynamicTypeSize(.xxxLarge)
                        .scaleEffect(1.5)
                        .foregroundStyle(Color(.english))
                        .bold()
                        .padding()
                    ForEach(CourseDatabase.englishCourseDetails.keys.sorted(), id: \.self) { key in
                        if let course = CourseDatabase.englishCourseDetails[key] {
                            CourseDescriptions(course: course, color: Color(.english))
                        }
                    }
                    
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color(.accent))
                        .padding(.horizontal)
                    
                    Text("History")
                        .font(.title)
                        .dynamicTypeSize(.xxxLarge)
                        .scaleEffect(1.5)
                        .foregroundStyle(Color(.history))
                        .bold()
                        .padding()
                    ForEach(CourseDatabase.historyCourseDetails.keys.sorted(), id: \.self) { key in
                        if let course = CourseDatabase.historyCourseDetails[key] {
                            CourseDescriptions(course: course, color: Color(.history))
                        }
                    }
                    
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color(.accent))
                        .padding(.horizontal)
                    
                    Text("Languages")
                        .font(.title)
                        .dynamicTypeSize(.xxxLarge)
                        .scaleEffect(1.5)
                        .foregroundStyle(Color(.lang))
                        .bold()
                        .padding()
                    Text("Available Levels (5.0 credits per each): Level I CP, Level II CP, Level III CP, Level IV CP, AP Level")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    VStack (alignment: .leading) {
                        Text("- Spanish")
                        Text("- Chinese")
                        Text("- French")
                        Text("- Italian")
                        Text("- German")
                        
                    }
                    .bold()
                    .dynamicTypeSize(.xxLarge)
                    .font(.title)
                    .foregroundStyle(Color(.lang))
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    Text("Available Levels (5.0 credits per each): Level I CP, Level II CP, Level III CP, Level IV CP")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.accentColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    VStack (alignment: .leading) {
                        Text("- Latin")
                        Text("- American Sign Language")
                    }
                    .bold()
                    .dynamicTypeSize(.xxLarge)
                    .font(.title)
                    .foregroundStyle(Color(.lang))
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color(.accent))
                        .padding(.horizontal)
                    
                    
                    Text("Electives")
                        .font(.title)
                        .dynamicTypeSize(.xxxLarge)
                        .scaleEffect(1.5)
                        .foregroundStyle(Color(.elective))
                        .bold()
                        .padding()
                    
                    ForEach(displayElectives, id: \.electiveName) { elective in
                        Text(elective.electiveName)
                            .bold()
                            .dynamicTypeSize(.xxLarge)
                            .font(.title)
                            .foregroundStyle(Color(.elective))
                            .multilineTextAlignment(.center)
                            .padding()
                        Text("You earn \(String(format: "%.1f", round(elective.credits * 10) / 10.0)) \(elective.electiveType) credits for successfully completing this course.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.accentColor)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                        
                    }
                    
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
                .padding(.horizontal)
                
                
            }
            .background {
                Color(.background)
            }
            .toolbar(.hidden)
                
        }
       
    }
}


// Formatting for each course
struct CourseDescriptions: View {
    let course: Course
    let color: Color
    
    var body: some View {
        NavigationStack {
            
                VStack {
                    Text(course.name)
                        .bold()
                        .foregroundStyle(color)
                        .dynamicTypeSize(.xxLarge)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("You earn \(String(format: "%.1f", round(course.credits * 10) / 10.0)) credits for successfully completing this course.")
                        .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.accentColor)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    Text("This is a/an \(course.difficulty) \(course.subject.lowercased()) course.")
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(Color.accentColor)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(course.description)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(Color.accentColor)
                        .padding(.horizontal)
                }
            }
    }
}


import SwiftUI

struct PathwayButtonView: View {
    let allPathways: [[Course]]
    @Binding var pathway: [Course]
    @Binding var index: Int
    
    var body: some View {
        // Button to change the pathway
        Button {
            // Update the pathway when the button is clicked
            if allPathways.count > 0 {
                index += 1
                if index >= allPathways.count {
                    // Reset to the first pathway
                    index = 0
                }
                pathway = allPathways[index]
                
            }
        } label: {
            Text("Pathway #\(index + 1)")
                .dynamicTypeSize(.xxxLarge)
                .foregroundStyle(.white)
                .padding()
                .background(Color.accentColor)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
                .shadow(radius: 10)
        }

    }
}


struct GridRowView: View {
    @State private var selectedCourse: Course? = nil
    @State private var showingSheet = false
    let color: Color
    let allPathways: [[Course]]
    let subject: String
    @Binding var pathway: [Course]
    @Binding var index: Int
    let lang: String

    
    var body: some View {
        GridRow {
            
            PathwayButtonView(allPathways: allPathways, pathway: $pathway, index: $index)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text(subject)
                .font(.title2)
                .bold()
                .padding()
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            
            // Displaying courses in current pathway
            ForEach(pathway) { course in
                HStack {
                    Button {
                        selectedCourse = course
                    } label: {
                        Text((lang == "Latin" || lang == "American Sign Language") || course.name == "Study Hall" ? "\(course.name)" : "\(course.name)\(lang)")
                            .dynamicTypeSize(.xLarge)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundStyle(.white)
                            .padding()
                            .background(color)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            .shadow(radius: 10)
                    }
                    .sheet(item: $selectedCourse) { course in
                        courseInfoView(course: course, lang: lang)
                    }
                }
            }
        }
        .padding(.vertical)
        .onAppear {
            // Initialize first pathway when the view appears
            if allPathways.count > 0 {
                pathway = allPathways[index]
            }
        }

    }
}

struct courseInfoView: View {
    @Environment(\.dismiss) var dismiss
    let course: Course
    let lang: String
    
    var body: some View {
        NavigationStack {
    
            VStack {
                Text(lang == "Latin" || lang == "American Sign Language" ? course.name : "\(course.name) \(String(describing: lang))")
                    .font(.title2)
                    .padding()
                    .foregroundStyle(Color.accentColor)
                
                Text("You earn \(String(format: "%.1f", round(course.credits * 10) / 10.0)) credits for successfully completing this course.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .foregroundStyle(Color.accentColor)
                
                Text("This is a/an \(course.difficulty) \(course.subject.lowercased()) course.")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.accentColor)
                
                Spacer()
                Text(course.description)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .foregroundStyle(Color.accentColor)
                
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
            .background(Color(.background))
            .toolbar(.hidden)
            
        }
    }
}

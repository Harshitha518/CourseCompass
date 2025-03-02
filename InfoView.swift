

import SwiftUI

// View which provides information about app
struct InfoView: View {
    @EnvironmentObject var student: Student
    @EnvironmentObject var pageStore: PageStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        Text("Map Your Future: The Power Of A 4 - Year Plan")
                            .dynamicTypeSize(.large)
                            .scaleEffect(2)
                            .foregroundStyle(Color.accentColor)
                            .padding(.bottom)
                        
                        ListView(image: "clock.fill", text: "Visualize & Balance Workload", backgroundColor: Color.accentColor, textColor: Color(.background), borderColor: Color.accentColor)
                        ListView(image: "graduationcap.fill", text: "Meet All Graduation Requirements", backgroundColor: Color.accentColor, textColor: Color(.background), borderColor: Color.accentColor)
                        ListView(image: "trophy.fill", text: "Prepare for College & Competitive Majors", backgroundColor: Color.accentColor, textColor: Color(.background), borderColor: Color.accentColor)
                        ListView(image: "lock.open.fill", text: "Keep Your Options Open", backgroundColor: Color.accentColor, textColor: Color(.background), borderColor: Color.accentColor)
                        ListView(image: "brain.fill", text: "Take Advantage Of Elective Classes", backgroundColor: Color.accentColor, textColor: Color(.background), borderColor: Color.accentColor)
                        ListView(image: "exclamationmark.triangle.fill", text: "Reduce Stress & Last-Minute Scheduling Conflicts", backgroundColor: Color.accentColor, textColor: Color(.background), borderColor: Color.accentColor)
                    }
                    .padding(.vertical, 100)
                
                    
                    Spacer()
                    
                    VStack {
                        Text("Stay On Course: How Course Compass Helps You Plan Smarter")
                            .dynamicTypeSize(.large)
                            .scaleEffect(2)
                            .foregroundStyle(Color.accentColor)
                            .padding()
                        
                        Grid(alignment: .leading) {
                            
                            GridRow {
                                Text("Issues & Challenges")
                                    .font(.title2)
                                    .foregroundStyle(Color.accentColor)
                                
                                HStack {
                                    Image(systemName: "hand.thumbsdown.fill")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                    Text("Traditional Planning")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                        .bold()
                                        .padding()
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.trailing)
                                }
                                
                                HStack {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                    Text("Course Compass")
                                        .font(.title2)
                                        .foregroundStyle(Color.accentColor)
                                        .bold()
                                        .padding()
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.trailing)
                                }
                                
                            }
                            .padding(.trailing)
                            .padding(.bottom)
                            
                            GridRow {
                                Text("Last Minute Decisions")
                                    .foregroundStyle(Color.accentColor)
                                    .bold()
                                
                                
                                Text("Students are often provided with course selection information only a few weeks before needing to let counselors know and finalizing them. They are also overwhelmed with so much information that it can seem daunting to even create a schedule. This makes it difficult to optimize your 4 years of highschool courses, especially when selecting classes one year at a time.")
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("Course Compass provides a 4 - year roadmap, helping students plan strategically. They can get and modify their schedules any time and utilize this tool to plan ahead.")
                                    .foregroundStyle(Color.accentColor)
                            }
                            .padding(.trailing)
                            .padding(.bottom)
                            
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color.accentColor)
                                .padding(.horizontal)
                                .padding(.bottom)
                            
                            GridRow {
                                Text("Roadblocks & Missed Turns")
                                    .foregroundStyle(Color.accentColor)
                                    .bold()
                                
                                
                                Text("Due to choosing classes one year at a time, students often miss prerequisite classes for advanced classes like APs or higher level electives. This limits their future course options, and students often miss taking classes they are truly interested in or even need as a requirement to graduate. Being given all information at once, in a complicated format only adds on to this struggle.")
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("Course Compass calculates prerequisites for you! There is no need to worry about whether you are able to take a certain course in the future. It will appear there only if you have completed the necessry prerequisites. This allows students to see which pathways they must take in order to meet requirements for certain courses, and allows them to plan ahead ensuring their ability to take the desired course.")
                                    .foregroundStyle(Color.accentColor)
                            }
                            .padding(.trailing)
                            .padding(.bottom)
                            
                            Divider()
                                .frame(minHeight: 2)
                                .overlay(Color.accentColor)
                                .padding(.horizontal)
                                .padding(.bottom)
                            
                            
                            GridRow {
                                Text("Limited Flexibility & Redirection")
                                    .foregroundStyle(Color.accentColor)
                                    .bold()
                                
                                
                                Text("Schools usually only offer guidance on how to take traditional pathways in core subjects such as math, science, english, and history. They provide little guidance on how to create a flexible schedule, fit for you. It is also often difficult to understand which options you have if you start 9th grade with an atypical course in a subject area.")
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("Course Compass makes room for all oppurtunities. It provides as many pathways as possible based on the courses the student has been placed in for 9th grade. These pathways range in difficulty, and cover almost all options, even unconventional one! Having many pathways also allows the schedule to be easily modified as interests evolve.")
                                    .foregroundStyle(Color.accentColor)
                            }
                            .padding(.trailing)
                            .padding(.bottom)
                            
                            
                        }
                        .padding()
                        .border(Color(.accent), width: 5)
                        .padding(.horizontal, 30)
                        
                    }
                    .padding(.bottom, 100)
                    
                    Spacer()
                    
                    VStack {
                        Text("Start Your Journey!")
                            .dynamicTypeSize(.large)
                            .scaleEffect(2)
                            .foregroundStyle(Color.accentColor)
                            .padding()
                        
                        ListView(image: "1.circle", text: "Enter Your Course Placements for 9th Grade", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                        ListView(image: "2.circle", text: "Get back a Comprehensive & Simple 4 - Year Plan in Schedule Format", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                        ListView(image: "3.circle", text: "With The Tap Of A Button, Explore Different Pathways Available", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                        ListView(image: "4.circle", text: "Select Electives Based On Your Interests", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                        ListView(image: "5.circle", text: "After Making Final Selections, Check To See If Graduation Requirements Are Met", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                        ListView(image: "6.circle", text: "Export, Share, & Save A PDF Copy Of Your Schedule For Future Reference", backgroundColor: Color(.background), textColor: Color.accentColor, borderColor: Color.accentColor)
                        
                    }
                    .padding(.bottom, 100)
                    
                    NavigationLink {
                        
                        StartView(student: _student)
                        
                        
                    } label: {
                        HStack {
                            Image(systemName: "arrow.forward")
                            Text("Begin Planning")
                        }
                        .dynamicTypeSize(.xxxLarge)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .shadow(radius: 30)
                        .scaleEffect(1.2)
                    }
                    .padding(.bottom)

                }
                
            }
            .navigationTitle("Why Plan Your Courses?")
            .navigationBarTitleDisplayMode(.large)
            .background {
                Color(.background)
                    .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ListView: View {
    var image: String
    var text: String
    var backgroundColor: Color
    var textColor: Color
    var borderColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: "\(image)")
                .dynamicTypeSize(.xxxLarge)
                .foregroundStyle(textColor)
                .padding(.horizontal)
            Text(text)
                .dynamicTypeSize(.xxxLarge)
                .foregroundStyle(textColor)
            Spacer()
        }
        .padding(.vertical)
        .background(backgroundColor)
        .border(borderColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        .padding(.horizontal, 200)
        .padding(.bottom, 20)
    }
}

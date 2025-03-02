

import SwiftUI


// First view
struct IntroView: View {
    @EnvironmentObject var student: Student
    @State private var studentName = ""
    @EnvironmentObject var pageStore: PageStore
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("BGImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Image("Icon.png")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .padding()
                        
                        Text("Course Compass")
                            //.font(.largeTitle)
                            .font(.system(.largeTitle, design: .serif))
                            .dynamicTypeSize(.xxxLarge)
                            .scaleEffect(2)
                            .foregroundStyle(Color.accentColor)
                            .padding(.leading, 75)
                    }
                    .padding(.horizontal)
                    
                    Text("An all-in-one app to help you navigate through your highschool journey...")
                        .foregroundStyle(Color.accentColor)
                        .background(Color(.background))
                        .scaleEffect(1.5)
                        Spacer()
                    
                    // Allows users to enter name, not mandatory
                    TextField("Enter Your Name", text: $studentName)
                        .frame(height: 55)
                        .background(Color(.background))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .font(.largeTitle)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.accentColor))
                        .padding(.horizontal, 400)
                        .onChange(of: studentName) { newValue in
                            student.studentName = studentName
                        }
                    
                    
                    Spacer()
                    
                    NavigationLink {
                        
                        InfoView(student: _student)
                        
                        
                    } label: {
                        HStack {
                            Image(systemName: "airplane.departure")
                            Text("Get Started")
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
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}


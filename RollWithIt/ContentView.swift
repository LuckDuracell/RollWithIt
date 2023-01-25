//
//  ContentView.swift
//  RollWithIt
//
//  Created by Luke Drushell on 1/24/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newIdea: String = ""
    @State private var ideas: [String] = []
    
    @State private var buttonOffset: CGFloat = 0
    
    @State var selection = -1
    
    func animateButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            withAnimation {
                buttonOffset = -20
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            withAnimation {
                buttonOffset = 150
            }
        })
    }
    
    func pickIdea() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            withAnimation {
                selection = Int.random(in: 0...ideas.count - 1)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            withAnimation {
                buttonOffset = 0
            }
        })
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        TextField("Wacky Idea", text: $newIdea)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(3)
                            .padding()
                            .shadow(color: Color("SpecialShadow"), radius: 5)
                            .onSubmit {
                                withAnimation {
                                    ideas.insert(newIdea, at: 0)
                                    newIdea = ""
                                }
                            }
                    }
                    Divider()
                    VStack {
                        ForEach(ideas.indices, id: \.self, content: { index in
                                HStack {
                                    Text(ideas[index])
                                    Spacer()
                                }
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(3)
                                .onTapGesture {
                                    withAnimation {
                                        selection = -1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                                        ideas.remove(at: index)
                                    })
                                }
                                .overlay(alignment: .leading, content: {
                                    if selection == index {
                                        Color.accentColor
                                            .frame(width: 8)
                                            .cornerRadius(4, corners: [.topLeft, .bottomLeft])
                                            .cornerRadius(2, corners: [.topRight, .bottomRight])
                                            .offset(x: -7)
                                            .padding(.vertical, 5)
                                    }
                                })
                                .shadow(color: Color("SpecialShadow"), radius: 2)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                        })
                    } .padding(.top, 15)
                } .navigationTitle("Roll With It")
                    .toolbar(content: {
                        ToolbarItem(placement: .bottomBar, content: {
                            Button {
                                animateButton()
                                pickIdea()
                            } label: {
                                HStack {
                                    Text("Roll the Dice")
                                    Image(systemName: "dice.fill")
                                } .padding()
                                .background(.regularMaterial)
                                .cornerRadius(5)
                                .shadow(color: Color("SpecialShadow"), radius: 2)
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                                .offset(y: buttonOffset)
                            }
                            .padding(.bottom, 10)
                        })
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BigTitle: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle.bold())
                .padding()
            Spacer()
        }
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

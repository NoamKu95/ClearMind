//
//  OnboardingView.swift
//  Restart
//
//  Created by Noam Kurtzer on 18/02/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("onboarding") var hasSeenOnboarding : Bool = true
    
    let BUTTON_CIRCLE_WIDTH : CGFloat = 80
    @State private var entireButtonWidth : Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset : CGFloat = 0
    @State private var isAnimating : Bool = false
    @State private var imageOffset : CGSize = .zero
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
                // HEADER
               Spacer()
                VStack (spacing: 0) {
                    Text("Share.")
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("""
                    It's not about how much we give,
                    but about how much we put into giving.
                    """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeIn(duration: 1), value: isAnimating)
                
                // CENTER
                ZStack {
                    CirclesGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.4), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if abs(imageOffset.width) <= 150 {
                                        imageOffset = gesture.translation
                                    }
                                }
                                .onEnded{ _ in
                                    imageOffset = .zero
                                }
                        )
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }
                Image(systemName: "")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                // FOOTER
                Spacer()
                ZStack {
                    // WHITE CAPSULE
                    Capsule()
                        .fill(.white.opacity(0.2))
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .padding(8)
                    
                    // TEXT
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    
                    // BUTTON EXTENDING RED CAPSULE
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + BUTTON_CIRCLE_WIDTH)
                        
                        Spacer()
                    }
                    
                    
                    // BUTTON TOP CIRCLE
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: BUTTON_CIRCLE_WIDTH, height: BUTTON_CIRCLE_WIDTH, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= entireButtonWidth - BUTTON_CIRCLE_WIDTH {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(Animation.easeOut(duration: 0.4)) {
                                        if buttonOffset > entireButtonWidth / 2 {
                                            buttonOffset = entireButtonWidth - BUTTON_CIRCLE_WIDTH
                                            hasSeenOnboarding = true
                                        } else {
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        )
                        
                        Spacer()
                    }
                }
                .frame(width: entireButtonWidth ,height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeIn(duration: 1), value: isAnimating)
            }
        }
        .onAppear(perform: {
            isAnimating = true
        })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

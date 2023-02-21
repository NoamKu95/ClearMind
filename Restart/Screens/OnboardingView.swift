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
    @State private var indicatorOpacity : Double = 1.0
    @State private var textTitle : String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
                // MARK: HEADER
               Spacer()
                VStack (spacing: 0) {
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle) // to let the textView know it needs to render on text change
                    
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
                
                // MARK: CENTER
                ZStack {
                    // MARK: background circles
                    CirclesGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1) // move the ring in the opposite direction of the image
                        .blur(radius: abs(imageOffset.width / 5)) // higher blur the more the image moves
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    // MARK: main image
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.4), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0) // make the image to move right and left
                        .rotationEffect(.degrees(Double(imageOffset.width / 20))) // make the image rotate white moving horizontaly
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if abs(imageOffset.width) <= 150 { // limit the movement of the image
                                        imageOffset = gesture.translation
                                        
                                        withAnimation(.linear(duration: 0.25)) { // hide the indicator icon once gesture starts
                                            indicatorOpacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                }
                                .onEnded{ _ in
                                    imageOffset = .zero // reset image to original position
                                    
                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 1
                                        textTitle = "Share."
                                    }
                                }
                        )
                        .animation(.easeOut(duration: 1), value: imageOffset) // soften image movement by animation
                }
                .overlay( // put the icon on top of everything
                    // MARK: scroll indicator icon
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 1).delay(2), value: isAnimating) // display icon with animation in a 2 sec delay
                        .opacity(indicatorOpacity)
                    , alignment: .bottom // place the icon at the bottom if the ZStack
                )
                
                
                // MARK: FOOTER
                Spacer()
                ZStack {
                    // MARK: button whit capsule
                    Capsule()
                        .fill(.white.opacity(0.2))
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .padding(8)
                    
                    // MARK: button text
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    
                    // MARK: button expansing red capsule
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + BUTTON_CIRCLE_WIDTH)
                        
                        Spacer()
                    }
                    
                    
                    // MARK: button top circle
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
                                            playSound(withFile: "chimeup", ofType: "mp3")
                                            hapticFeedback.notificationOccurred(.success) // vibrate in success
                                        } else {
                                            buttonOffset = 0
                                            hapticFeedback.notificationOccurred(.warning) // vibrate in warning
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
        .preferredColorScheme(.dark) // determines what color scheme to use for each screen / single element we put this on
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

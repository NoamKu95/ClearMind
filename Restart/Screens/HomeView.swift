//
//  HomeView.swift
//  Restart
//
//  Created by Noam Kurtzer on 18/02/2023.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("onboarding") var hasSeenOnboarding : Bool = false
    @State private var isAnimating : Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            // MARK: CENTER
            // MARK: main image
            ZStack {
                CirclesGroupView(ShapeColor: .gray, ShapeOpacity: 0.1)
                Image("character-2")
                    .resizable()
                    .scaledToFit()
                .padding()
                .offset(y: isAnimating ? 35 : -35)
                .animation(
                    Animation
                        .easeInOut(duration: 4)
                        .repeatForever()
                    , value: isAnimating)
            }
            
            // MARK: text
            Text("The time that leads to mastery is dependant on the intensity of out focus")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            // MARK: FOOTER
            // MARK: button
            Button(action: {
                withAnimation{
                    playSound(withFile: "success", ofType: "m4a")
                    hasSeenOnboarding = false
                }
            }) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .imageScale(.large)
                
                Text("Restart")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                isAnimating = true
            })
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  ContentView.swift
//  Restart
//
//  Created by Noam Kurtzer on 18/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("onboarding") var hasSeenOnboarding : Bool = false
    
    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView()
            } else {
                HomeView()
            }
        }
        .animation(.easeOut(duration: 0.4), value: hasSeenOnboarding)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  SplashScreenView.swift
//  FindMySpot
//
//  Created by Randy Julian on 23/05/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Find My Spot")
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            isActive = true
                        }
                    }
                    .background(
                    NavigationLink(destination: ContentView(), isActive: $isActive){
                        ContentView()
                    }
                        .hidden()
                    )
            }
        }
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

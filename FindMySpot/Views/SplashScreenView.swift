//
//  SplashScreenView.swift
//  FindMySpot
//
//  Created by Randy Julian on 23/05/23.
//

import SwiftUI
import LottieUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    
    var body: some View {
        NavigationView{
            
            ZStack {
                Rectangle()
                    .foregroundColor(Color(hex: "B8E2F2"))
                    .background(Color(hex: "B8E2F2"))
                VStack{
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 50)
                            .frame(width: 250, height: 250)
                        
                    }
                    LottieView("splash3")
                        .loopMode(.playOnce)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    isActive = true
                }
            }
            .fullScreenCover(isPresented: $isActive){
                ContentView(isShowing: $isActive)
            }
            
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

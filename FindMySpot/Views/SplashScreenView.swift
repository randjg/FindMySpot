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
        NavigationStack{
            
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
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                    isActive = true
                                }
                            }
                            .background(
                            NavigationLink(destination: ContentView(), isActive: $isActive){
                            }
                                .hidden()
                        )
//                        Image("splash")
//                            .resizable()
//                            .scaledToFit()
                        LottieView("splash3")
                            .loopMode(.playOnce)
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

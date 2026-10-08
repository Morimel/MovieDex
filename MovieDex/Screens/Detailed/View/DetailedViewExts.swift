//
//  DetailedViewExts.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import Foundation
import SwiftUI
import Nuke
import NukeUI

extension DetailedView {
  
    struct BackdropImage: View {
           
           let url: URL?
           let height: CGFloat
           
           var body: some View {
               LazyImage(url: url) { state in
                   if let image = state.image {
                       image.resizable()
                           .scaledToFill()
                           .frame(height: height)
                           .overlay(
                               LinearGradient(stops: [.init(color: Color(uiColor: .systemBackground), location: 0.0),
                                                      .init(color: Color(uiColor: .systemBackground).opacity(0.0), location: 0.5),
                                                      .init(color: Color(uiColor: .systemBackground).opacity(0.0), location: 0.7),
                                                      .init(color: Color(uiColor: .systemBackground), location: 1.0)],
                                              startPoint: .bottom,
                                              endPoint: .top)
                           )
                   } else {
                       ProgressView().progressViewStyle(.circular)
                           .frame(height: height / 2)
                   }
               }
               .frame(minWidth: .zero, maxWidth: .infinity)
               .clipped()
           }
       }
    
    struct PosterImage: View {
            
            let url: URL?
            let width: CGFloat
            
            var body: some View {
                LazyImage(url: url) { state in
                    if let image = state.image {
                        image.resizable()
                            .scaledToFill()
                    } else {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                .frame(width: width)
                .clipped()
            }
        }
    
    struct Title: View {
        
        let title: String
        
        var body: some View {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
                .minimumScaleFactor(0.1)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding([.leading, .trailing], 10)
                .shadow(color: Color(uiColor: .systemBackground), radius: 1)
                .shadow(color: Color(uiColor: .systemBackground), radius: 1)
                .shadow(color: Color(uiColor: .systemBackground), radius: 1)
        }
    }
    
    struct Overview: View {
        
        let text: String?
        
        var body: some View {
            if let text = text,
               text != "" {
                Text(text)
            }
        }
        
    }
}

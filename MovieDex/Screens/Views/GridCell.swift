//
//  GridCell.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import SwiftUI
import Nuke
import NukeUI

struct GridCell<Item: MDBItem>: View {
    
    var item: Item
    var isLiked: Bool = false
    var imageURL: URL?
    var height: CGFloat
    var likePressed: (Item) -> Void
    
    var posterHeight: CGFloat {
        height * 0.8
    }
    var infoHeight: CGFloat {
        height * 0.25
    }
    var buttonHeight: CGFloat {
        height * 0.1
    }
    
    var body: some View {
        NavigationLink(destination: DetailedView(item: item)) {
            switch item.type {
            case .movie:
                setupMovieCell()
            case .tvShow:
                setupTVShowCell()
            case .person:
                setupPersonCell()
            }
        }
    }
    
    @ViewBuilder private func setupMovieCell() -> some View {
        let movie = item as! Movie
        VStack(spacing: buttonHeight / 2) {
            ZStack(alignment: .bottom) {
                PosterImage(url: imageURL, height: posterHeight)
                HStack {
                    if let rating = item.voteAverage {
                        RatingButton(value: rating)
                    }
                    Spacer()
                    LikeButton(item: item,
                               isLiked: isLiked,
                               action: { item in likePressed(item) })
                }
                .frame(height: buttonHeight)
                .offset(y: buttonHeight / 2)
                .padding(.horizontal, 15)
            }
            VStack {
                Title(title: movie.title)
                ReleaseDate(date: movie.dateString)
            }
            .padding(10)
            .frame(height: infoHeight)
        }
        .modifier(RoundedCorners(value: 20))
    }
    
    @ViewBuilder private func setupTVShowCell() -> some View {
        let tvShow = item as! TVShow
        VStack(spacing: buttonHeight / 2) {
            ZStack(alignment: .bottom) {
                PosterImage(url: imageURL, height: posterHeight)
                HStack {
                    if let rating = item.voteAverage {
                        RatingButton(value: rating)
                    }
                    Spacer()
                    LikeButton(item: item,
                               isLiked: isLiked,
                               action: { item in likePressed(item) })
                }
                .frame(height: buttonHeight)
                .offset(y: buttonHeight / 2)
                .padding(.horizontal, 15)
            }
            VStack {
                Title(title: tvShow.name)
                ReleaseDate(date: tvShow.dateString)
            }
            .padding(10)
            .frame(height: infoHeight)
        }
        .modifier(RoundedCorners(value: 10))
    }
    
    @ViewBuilder private func setupPersonCell() -> some View {
        let person = item as! Person
        VStack(spacing: buttonHeight / 2) {
            ZStack(alignment: .bottom) {
                PosterImage(url: imageURL, height: posterHeight)
                HStack {
                    if let rating = item.voteAverage {
                        RatingButton(value: rating)
                    }
                    Spacer()
                    LikeButton(item: item,
                               isLiked: isLiked,
                               action: { item in likePressed(item) })
                }
                .frame(height: buttonHeight)
                .offset(y: buttonHeight / 2)
                .padding(.horizontal, 15)
            }
            VStack {
                Title(title: person.name)
                HStack {
                    Information(value: person.knownForDepartment)
                    Information(value: person.localizedGender)
                }
            }
            .padding(10)
            .frame(height: infoHeight)
        }
        .modifier(RoundedCorners(value: 10))
    }
}

extension GridCell {
    
    struct Title: View {
        
        let title: String
        
        var body: some View {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(3)
                .minimumScaleFactor(0.2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    struct ReleaseDate: View {
        
        let date: Date?
        
        var body: some View {
            if let date = date {
                Text(date, style: .date)
                    .font(.footnote)
                    .foregroundColor(Color(uiColor: .systemGray))
            }
        }
    }
    
    struct Information: View {
        
        let value: String?
        
        var body: some View {
            if let value = value {
                Text(value)
                    .font(.footnote)
                    .foregroundColor(Color(uiColor: .systemGray))
            }
        }
    }
    
    struct RatingButton: View {
        
        let value: Double
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color(uiColor: ratingColor()))
                    .scaledToFit()
                    .shadow(color: .secondary.opacity(0.3), radius: 5)
                Text(String.init(format: "%.1f", value))
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1)
            }
        }
        
        private func ratingColor() -> UIColor {
            switch value {
            case .zero:
                return .systemGray
            case 0..<2.5 :
                return .systemRed
            case 2.5..<5.0:
                return .systemOrange
            case 5.0..<7.0:
                return .systemYellow
            case 7.0...:
                return .systemGreen
            default:
                return .systemGray
            }
        }
    }
    
    struct LikeButton: View {
        
        let item: Item
        let isLiked: Bool
        let action: (Item) -> Void
        
        var body: some View {
            Button {
                action(item)
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .scaledToFit()
                        .shadow(color: .secondary.opacity(0.3), radius: 5)
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .imageScale(.medium)
                        .foregroundColor(Color(uiColor: .systemPink))
                }
            }
        }
    }
    
    struct PosterImage: View {
        
        let url: URL?
        let height: CGFloat
        
        var body: some View {
            LazyImage(url: url) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: height, alignment: .bottom)
            .clipped()
        }
    }
    
    struct RoundedCorners: ViewModifier {
        
        let value: CGFloat
        
        func body(content: Content) -> some View {
            return content
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(value)
                .overlay(RoundedRectangle(cornerRadius: value).stroke(Color.secondary, lineWidth: 0.5))
        }
    }
}

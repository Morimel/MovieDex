//
//  SideInfoView.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import Foundation
import SwiftUI


struct SideInfo<Item: MDBItem>: View {
    
    let item: Item
    
    var body: some View {
        switch item.type {
        case .movie:
            setupMovieSideInfo(movie: item as! Movie)
        case .tvShow:
            setupTVShowSideInfo(tvShow: item as! TVShow)
        case .person:
            setupPersonSideInfo(person: item as! Person)
        }
    }
    
    func setupMovieSideInfo(movie: Movie) -> some View {
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                OriginalTitle(title: movie.originalTitle)
                Tagline(tagline: movie.tagline)
                Genres(genres: movie.genres)
                ReleaseDate(releaseDate: movie.dateString)
                Runtime(runtime: movie.timeString)
                Spacer()
            }
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        )
    }
    
    func setupTVShowSideInfo(tvShow: TVShow) -> some View {
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                OriginalTitle(title: tvShow.originalName)
                Tagline(tagline: tvShow.tagline)
                Genres(genres: tvShow.genres)
                ReleaseDate(releaseDate: tvShow.dateString)
                Status(status: tvShow.statusString)
                NumberOfEpisodes(number: tvShow.numberOfEpisodesString)
                Runtime(runtime: tvShow.runtime)
                Spacer()
            }
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        )
    }
    
    func setupPersonSideInfo(person: Person) -> some View {
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                PersonName(input: person.localizedName())
                Department(input: person.knownForDepartment)
                Gender(input: person.localizedGender)
                Birthplace(input: person.placeOfBirth)
                Dates(input: person.dates)
                Spacer()
            }
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        )
    }
}

extension SideInfo {
    struct OriginalTitle: View {
        let title: String?
        var body: some View {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
            }
        }
    }
    
    struct Tagline: View {
        let tagline: String?
        var body: some View {
            if let tagline = tagline,
               tagline != "" {
                Text(tagline)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
            }
        }
    }
    
    struct NumberOfEpisodes: View {
        let number: String?
        var body: some View {
            if let number = number {
                Label {
                    Text(number)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                } icon: {
                    Image(systemName: "play.circle")
                }
            }
        }
    }
    
    struct Status: View {
        let status: String?
        var body: some View {
            if let status = status {
                Label {
                    Text(status)
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "tv").imageScale(.small)
                }
            }
        }
    }
    
    struct Runtime: View {
        let runtime: String?
        var body: some View {
            if let runtime = runtime {
                Label {
                    Text(runtime)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                } icon: {
                    Image(systemName: "timer")
                }
            }
        }
    }
    
    struct Genres: View {
        let genres: [Genre]?
        var body: some View {
            if let genres = genres,
               !genres.isEmpty {
                let output = genres.map { $0.name }.joined(separator: " / ")
                
                Text(output)
                    .font(.subheadline)
                    .fontWeight(.thin)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
            }
        }
    }
    
    struct ReleaseDate: View {
        let releaseDate: Date?
        var body: some View {
            if let releaseDate = releaseDate {
                Label {
                    VStack(alignment: .leading) {
                        Text(releaseDate, style: .date)
                            .font(.subheadline)
                    }
                } icon: {
                    Image(systemName: "calendar")
                }
            }
        }
    }
    
    //MARK: Person info
    
    struct PersonName: View {
        let input: String
        var body: some View {
            Label{
            Text(input)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.1)
            } icon: {
                Image(systemName: "highlighter")
            }
        }
    }
    
    struct Department: View {
        let input: String?
        var body: some View {
            if let input = input,
               input != "" {
                Label {
                    Text(input)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                } icon: {
                    Image(systemName: "bookmark")
                }
            }
        }
    }
    
    struct Gender: View {
        let input: String?
        var body: some View {
            if let input = input,
               input != "" {
                Label {
                    Text(input)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                } icon: {
                    Image(systemName: "person")
                }
            }
        }
    }
    
    struct Birthplace: View {
        let input: String?
        var body: some View {
            if let input = input,
               input != "" {
                Label {
                    Text(input)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                } icon: {
                    Image(systemName: "map")
                }
            }
        }
    }
    
    struct Dates: View {
        let input: (Date, Date?, Int)?
        var body: some View {
            if let input = input {
                Label {
                    VStack(alignment: .leading) {
                        Text(input.0, style: .date)
                            .font(.subheadline)
                        + Text(" (\(input.2) лет)")
                            .font(.subheadline)
                            .fontWeight(.light)
                        if let deathdate = input.1 {
                            Text(deathdate, style: .date)
                                .font(.subheadline)
                        }
                    }
                } icon: {
                    Image(systemName: "calendar")
                }
            }
        }
    }
}

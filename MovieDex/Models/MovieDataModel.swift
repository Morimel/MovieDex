//
//  MovieDataModel.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import Foundation

struct Movie: MDBItem {
    
    var id: Int
    var type: MDBItemType = .movie
    let originalTitle: String
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int
    
    let backdropPath: String?
    let runtime: Int?
    let tagline: String?
    
    let genres: [Genre]?
    
    private enum CodingKeys: String, CodingKey {
        case id, originalTitle, title, overview, posterPath, releaseDate, voteAverage, voteCount, backdropPath, runtime, tagline, genres
    }
    
    var dateString: Date? {
        if let releaseDate = releaseDate,
            !releaseDate.isEmpty {
            return dateFormatter.date(from: releaseDate)
        } else {
            return nil
        }
    }
    
    var timeString: String? {
        guard let runtime = runtime, runtime > 0 else { return nil }
        return timeFormatter.string(from: TimeInterval(runtime * 60))
    }
    
    var mainImagePath: String? {
        if let posterPath = posterPath {
            return posterPath
        } else {
            return nil
        }
    }
    
}



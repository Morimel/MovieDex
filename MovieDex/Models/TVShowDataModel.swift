//
//  TVShowDataModel.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import Foundation
import SwiftUI

struct TVShow: MDBItem {
    
    var id: Int
    let type: MDBItemType = .tvShow
    let originalName: String
    let name: String
    let overview: String
    let posterPath: String?
    let firstAirDate: String
    let voteAverage: Double?
    let voteCount: Int
    
    let backdropPath: String?
    let status: String?
    let tagline: String?
    let episodeRunTime: [Int]?
    
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    
    let genres: [Genre]?
    
    private enum CodingKeys: String, CodingKey {
        case id, originalName, name, overview, posterPath, firstAirDate, voteAverage, voteCount, backdropPath, status, tagline, episodeRunTime, numberOfEpisodes, numberOfSeasons, genres
    }
    
    var dateString: Date? {
        if firstAirDate.isEmpty {
            return nil
        } else {
            return dateFormatter.date(from: firstAirDate)
        }
    }
    
    var runtime: String? {
        if let episodeRunTime = episodeRunTime,
           !episodeRunTime.isEmpty {
            return timeFormatter.string(from: TimeInterval(episodeRunTime.first! * 60))
        } else {
            return nil
        }
    }
    
    var numberOfEpisodesString: String? {
        if let numberOfEpisodes = numberOfEpisodes {
            let result = "Episode: \(numberOfEpisodes)"
            return result
        } else {
            return nil
        }
    }
    
    var statusString: String? {
        if let status = status {
            switch status {
            case "Returning Series":
                return "Returning Series"
            case "Ended":
                return "Ended"
            case "Planned":
                return "Planned"
            default:
                return status
            }
        } else {
            return nil
        }
    }
    
    var mainImagePath: String? {
        if let posterPath = posterPath {
            return posterPath
        } else {
            return nil
        }
    }
}

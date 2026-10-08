//
//  MovieDatabaseModel.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import Foundation

// MDB - Movie Database

protocol MDBItem: Decodable {
    var id: Int { get }
    var type: MDBItemType { get }
    var dateString: Date? { get }
    var voteAverage: Double? { get }
    var mainImagePath: String? { get }
}

protocol URLPathItemType {
    var rawValue: String {get}
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct MovieListResults: Decodable {
    let results: [Movie]
}

struct TVShowListResuls: Decodable {
    let results: [TVShow]
}

struct PersonListResults: Decodable {
    let results: [Person]
}


enum MDBItemType: String, URLPathItemType, Identifiable, CaseIterable {
    case movie
    case tvShow = "tv"
    case person
    
    var id: Self { self }
}

enum MDBListType: String, URLPathItemType, Identifiable, CaseIterable {
    case popular
    case topRated = "top_rated"
    
    var id: Self { self }
}

enum MDBImageSize: String, URLPathItemType {
    case original
    case poster = "w500"
    case backdrop = "w1280"
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.zeroFormattingBehavior = .dropAll
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter
}()

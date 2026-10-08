//
//  DetailedViewModel.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import Foundation
import SwiftUI
import Combine

class DetailedViewModel: ObservableObject {
    
    let userDefaults = UserDefaults.standard
    
    var networkManager = NetworkManager()
    
    var currentItem: MDBItem? {
        didSet {
            Task {
                await fetchDetails()
            }
        }
    }
    
    @Published var movie: Movie?
    @Published var tvShow: TVShow?
    @Published var person: Person?
    
    @Published var likedMovies: Set<Int> = []
    @Published var likedTVShows: Set<Int> = []
    @Published var likedPersons: Set<Int> = []
    
    init() {
        likedMovies = Set(userDefaults.array(forKey: "likedMovies") as? [Int] ?? [])
        likedTVShows = Set(userDefaults.array(forKey: "likedTVShows") as? [Int] ?? [])
        likedPersons = Set(userDefaults.array(forKey: "likedPersons") as? [Int] ?? [])
    }
    
    func fetchDetails() async {
        guard let currentItem = currentItem else { return }
        switch currentItem.type {
        case .movie:
            let detailedMovie = await networkManager.fetchDetailedData(for: currentItem as! Movie)
            DispatchQueue.main.async {
                self.movie = detailedMovie
            }
        case .tvShow:
            let detailedTVShow = await networkManager.fetchDetailedData(for: currentItem as! TVShow)
            DispatchQueue.main.async {
                self.tvShow = detailedTVShow
            }
        case .person:
            let detailedPerson = await networkManager.fetchDetailedData(for: currentItem as! Person)
            DispatchQueue.main.async {
                self.person = detailedPerson
            }
        }
    }
    
    func getImageUrl(size: MDBImageSize, path: String?) -> URL? {
        guard let path = path else {
            return nil
        }
        return networkManager.imageURL(size: size, path: path)
    }
    
}

extension DetailedViewModel {
    func isItemLiked(_ item: MDBItem) -> Bool {
        let id = item.id
        switch item.type {
        case .movie:
            return likedMovies.contains(id)
        case .tvShow:
            return likedTVShows.contains(id)
        case .person:
            return likedPersons.contains(id)
        }
    }
    
    func likePressed(for item: MDBItem) {
        let id = item.id
        switch item.type {
        case .movie:
            if likedMovies.contains(id) {
                likedMovies.remove(id)
            } else {
                likedMovies.insert(id)
            }
            userDefaults.set(Array(likedMovies), forKey: "likedMovies")
        case .tvShow:
            if likedTVShows.contains(id) {
                likedTVShows.remove(id)
            } else {
                likedTVShows.insert(id)
            }
            userDefaults.set(Array(likedTVShows), forKey: "likedTVShows")
        case .person:
            if likedPersons.contains(id) {
                likedPersons.remove(id)
            } else {
                likedPersons.insert(id)
            }
            userDefaults.set(Array(likedPersons), forKey: "likedPersons")
        }
    }
}

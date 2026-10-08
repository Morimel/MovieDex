//
//  FeedViewModel.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import Foundation
import SwiftUI
import Combine

class FeedViewModel: ObservableObject {
    
    private let userDefaults = UserDefaults.standard
    
    private let networkManager = NetworkManager()
    
    @Published var movies: [Movie] = []
    @Published var tvshows: [TVShow] = []
    @Published var persons: [Person] = []
    
    @Published var likedMovies: Set<Int> = []
    @Published var likedTVShows: Set<Int> = []
    @Published var likedPersons: Set<Int> = []
        
    @Published var currentPage: Int = 1
    private var totalPages: Int = 999
    
    @Published var currentListType: MDBListType = .popular {
        didSet{
            reloadList()
        }
    }
    
    @Published var currentItemType: MDBItemType = .movie {
        didSet {
            reloadList()
        }
    }
    
    init() {
        reloadList()
        networkManager.delegate = self
    }
    
    func loadMoreContent<Data, Item>(currentItem item: Item, in data: Data) async
    where Data: RandomAccessCollection,
          Data.Element: MDBItem,
          Item: MDBItem {
        let thresholdIndex = data.index(data.endIndex, offsetBy: -3)
        if data[thresholdIndex].id == item.id {
            currentPage += 1
            await getList()
        }
    }
    
    private func reloadList() {
        movies = []
        tvshows = []
        persons = []
        currentPage = 1
        Task {
            await getList()
        }
    }
    
    func getList() async {
        await networkManager.fetchList(itemType: currentItemType,
                                       url: networkManager.listURL(listType: currentListType,
                                                                   itemType: currentItemType,
                                                                   page: currentPage)
        )
    }
        
    func getImageUrl(path: String?) -> URL? {
        guard let path = path else {
            return nil
        }
        return networkManager.imageURL(size: .poster, path: path)
    }
}

extension FeedViewModel: NetworkManagerDelegate {
    func didMovieListUpdate(data: [Movie]) {
        movies.append(contentsOf: data)
    }
    
    func didTVShowListUpdate(data: [TVShow]) {
        tvshows.append(contentsOf: data)
    }
    
    func didPersonListUpdate(data: [Person]) {
        persons.append(contentsOf: data)
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    
}

extension FeedViewModel {
    func reloadLikes() {
        likedMovies = Set(userDefaults.array(forKey: "likedMovies") as? [Int] ?? [])
        likedTVShows = Set(userDefaults.array(forKey: "likedTVShows") as? [Int] ?? [])
        likedPersons = Set(userDefaults.array(forKey: "likedPersons") as? [Int] ?? [])
    }
    
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

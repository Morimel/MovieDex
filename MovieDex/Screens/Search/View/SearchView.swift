//
//  SearchView.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let cellHeight = geometry.frame(in: .global).width * 0.8
            NavigationView {
                switch viewModel.currentItemType {
                case .movie:
                    setupSearchResult(data: viewModel.movies, height: cellHeight)
                case .tvShow:
                    setupSearchResult(data: viewModel.tvshows, height: cellHeight)
                case .person:
                    setupSearchResult(data: viewModel.persons, height: cellHeight)
                }
            }
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Type a title here")
            .onSubmit(of: .search) {
                viewModel.reloadList()
            }
            .navigationViewStyle(.stack)
        }
    }
}

extension SearchView {
    @ViewBuilder func setupSearchResult<Data>(data: Data, height: CGFloat) -> some View
    where Data: RandomAccessCollection, Data.Element: MDBItem {
        ScrollView {
            if viewModel.searchText.isEmpty {
                Text("What are we going to find today?")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(20)
            } else if data.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            } else {
                GridView(data: data) { item in
                    GridCell(item: item,
                             isLiked: viewModel.isLiked(item),
                             imageURL: viewModel.getImageUrl(item.mainImagePath),
                             height: height,
                             likePressed: { item in viewModel.likePressed(item) })
                        .onAppear {
                            Task {
                                await viewModel.loadMoreContent(currentItem: item, from: data)
                            }
                        }
                }
            }
        }
        .onAppear {
            viewModel.reloadLikes()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarSelectItemTypeButton(type: $viewModel.currentItemType, titleMode: .right)
            }
            ToolbarItem(placement: .principal) {
                Text("Search")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
//  FeedView.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let cellHeight = geometry.frame(in: .global).width * 0.8
            NavigationView {
                switch viewModel.currentItemType {
                case .movie:
                    feed(data: viewModel.movies, height: cellHeight)
                case .tvShow:
                    feed(data: viewModel.tvshows, height: cellHeight)
                case .person:
                    feed(data: viewModel.persons, height: cellHeight)
                }
            }
            .navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder func feed<Data>(data: Data, height: CGFloat) -> some View
    where Data: RandomAccessCollection, Data.Element: MDBItem {
        ScrollView {
            if data.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            } else {
                GridView(data: data) { item in
                    GridCell(item: item,
                             isLiked: viewModel.isItemLiked(item),
                             imageURL: viewModel.getImageUrl(path: item.mainImagePath),
                             height: height,
                             likePressed: { item in viewModel.likePressed(for: item) })
                        .onAppear {
                            Task {
                                await viewModel.loadMoreContent(currentItem: item, in: data)
                            }
                        }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarSelectItemTypeButton(type: $viewModel.currentItemType, titleMode: .right)
            }
            ToolbarItem(placement: .principal) {
                Text("Feed")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavBarSelectListTypeButton(type: $viewModel.currentListType, titleMode: .left)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.reloadLikes()
        }
    }
}

//
//  DetailedView.swift
//  MovieDex
//
//  Created by Isa Melsov on 8/10/26.
//

import SwiftUI
import NukeUI

struct DetailedView<Item: MDBItem>: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = DetailedViewModel()
    
    var item: Item
    
    var body: some View {
        GeometryReader { geometry in
            switch item.type {
            case .movie:
                setupMovieView(with: geometry)
            case .tvShow:
                setupTVShowView(with: geometry)
            case .person:
                setupPersonView(with: geometry)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBarBackButton(action: dismiss)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavBarLikeButton(isLiked: viewModel.isItemLiked(item),
                                 action: { viewModel.likePressed(for: item) })
            }
        }
    }

    func setupMovieView(with geometry: GeometryProxy) -> some View {
        
        let frame = geometry.frame(in: .global)
        
        if viewModel.currentItem == nil {
            viewModel.currentItem = item
        }
        guard let movie = viewModel.movie else {
            return AnyView(
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
            )
        }
        return AnyView(
            VStack {
                ZStack(alignment: .bottom) {
                    BackdropImage(url: viewModel.getImageUrl(size: .backdrop, path: movie.backdropPath),
                                  height: frame.height * 0.4)
                    Title(title: movie.title)
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            PosterImage(url: viewModel.getImageUrl(size: .poster, path: movie.posterPath),
                                        width: frame.width * 0.35)
                            SideInfo(item: movie)
                            Spacer()
                        }
                        Overview(text: movie.overview)
                    }
                    .padding([.leading, .trailing], 10)
                }
                Spacer()
            }
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
        )
    }
    
    func setupTVShowView(with geometry: GeometryProxy) -> some View {
        
        let frame = geometry.frame(in: .global)
        
        if viewModel.currentItem == nil {
            viewModel.currentItem = item
        }
        guard let tvShow = viewModel.tvShow else {
            return AnyView(
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
            )
        }
        return AnyView(
            VStack(alignment: .leading) {
                ZStack(alignment: .bottom) {
                    BackdropImage(url: viewModel.getImageUrl(size: .backdrop, path: tvShow.backdropPath),
                                  height: frame.height * 0.4)
                    Title(title: tvShow.name)
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            PosterImage(url: viewModel.getImageUrl(size: .poster, path: tvShow.posterPath),
                                        width: frame.width * 0.35)
                            SideInfo(item: tvShow)
                            Spacer()
                        }
                        Overview(text: tvShow.overview)
                    }
                    .padding([.horizontal], 10)
                }
            }
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
        )
    }
    func setupPersonView(with geometry: GeometryProxy) -> some View {
        
        let frame = geometry.frame(in: .global)
        
        if viewModel.currentItem == nil {
            viewModel.currentItem = item
        }
        guard let person = viewModel.person else {
            return AnyView(
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
            )
        }
        return AnyView(
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        PosterImage(url: viewModel.getImageUrl(size: .poster, path: person.profilePath),
                                    width: frame.width * 0.35)
                        SideInfo(item: person)
                    }
                    Overview(text: person.biography)
                }
                .padding([.horizontal], 10)
            }
                .navigationTitle(person.name)
        )
    }
}

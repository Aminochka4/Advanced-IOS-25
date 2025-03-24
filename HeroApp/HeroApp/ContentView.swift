//
//  ContentView.swift
//  HeroApp
//
//  Created by Амина Аманжолова on 16.03.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: HeroViewModel
    let router: Router

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)

            Button(action: {
                router.push(to: .favorites)
            }) {
                Text("Favorite heroes")
            }

            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                List(viewModel.filteredHeroes) { hero in
                    HeroRow(hero: hero, viewModel: viewModel)
                        .onTapGesture {
                            router.push(to: .detail(hero))
                        }
                }
            }
        }
        .onAppear { viewModel.fetchHeroes() }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Text the hero's name...", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

struct HeroRow: View {
    let hero: Hero
    @ObservedObject var viewModel: HeroViewModel
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: hero.images.md)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 65, height: 65)
            .clipShape(Circle())
            Text(hero.name).font(.system(size: 18)).bold().padding()
            Spacer()
            Button(action: {
                viewModel.toggleFavorite(hero: hero)
            }) {
                Image(systemName: viewModel.isFavorite(hero: hero) ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isFavorite(hero: hero) ? .red : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct HeroDetailView: View {
    let heroId: Int
    @ObservedObject var viewModel: HeroViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading hero details...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if let hero = viewModel.selectedHero {
                VStack {
                    Text(hero.name)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Spacer(minLength: 20)
                    
                    HStack(alignment: .center, spacing: 16) {
                        AsyncImage(url: URL(string: hero.images.md)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 16) {
                                StatView(value: hero.powerstats.intelligence, label: "Intelligence")
                                StatView(value: hero.powerstats.strength, label: "Strength")
                                StatView(value: hero.powerstats.speed, label: "Speed")
                            }
                            HStack(spacing: 16) {
                                StatView(value: hero.powerstats.durability, label: "Durability")
                                StatView(value: hero.powerstats.power, label: "Power")
                                StatView(value: hero.powerstats.combat, label: "Combat")
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 20)
                    
                    Text("Biography")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                    
                    Divider()
                        .background(Color.gray)
                        .padding(.horizontal, 18)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fullname").foregroundColor(Color.gray).font(.caption).bold()
                            Text(hero.biography.fullName ?? "Unknown")
                            
                            Text("Place of birth").foregroundColor(Color.gray).font(.caption).bold()
                            Text(hero.biography.placeOfBirth ?? "Unknown")
                            
                            Text("Publisher").foregroundColor(Color.gray).font(.caption).bold()
                            Text(hero.biography.publisher ?? "Unknown")
                        }
                        .padding(.leading, 22)
                        Spacer()
                    }
                    
                    Spacer(minLength: 20)
                    
                    Text("Appearance")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                    
                    Divider()
                        .background(Color.gray)
                        .padding(.horizontal, 18)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gender").foregroundColor(Color.gray).font(.caption).bold()
                            Text("\(hero.appearance.gender)")
                            
                            Text("Race").foregroundColor(Color.gray).font(.caption).bold()
                            Text(hero.appearance.race ?? "Unknown")
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Height").foregroundColor(Color.gray).font(.caption).bold()
                                    Text("\(hero.appearance.height[1])")
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Eye color").foregroundColor(Color.gray).font(.caption).bold()
                                    Text("\(hero.appearance.eyeColor)")
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Hair color").foregroundColor(Color.gray).font(.caption).bold()
                                    Text("\(hero.appearance.hairColor)")
                                }
                                .padding(.horizontal, 18)
                            }
                        }
                        .padding(.leading, 22)
                        Spacer()
                    }
                    
                    Spacer(minLength: 20)
                    
                    Text("Work")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                    
                    Divider()
                        .background(Color.gray)
                        .padding(.horizontal, 18)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Occupation").foregroundColor(Color.gray).font(.caption).bold()
                            Text("\(hero.work.occupation)")
                        }
                        .padding(.leading, 22)
                        Spacer()
                    }
                    
                    Spacer(minLength: 18)
                }
                .padding(.horizontal, 16)
            } else {
                Text("Hero details not available.")
            }
        }
        .onAppear {
            viewModel.fetchHeroDetails(id: heroId)
        }
    }
}

struct StatView: View {
    let value: Int
    let label: String
        
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.title2)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 70)
    }
}

struct FavoritesView: View {
    @ObservedObject var viewModel: HeroViewModel
    @ObservedObject var router: Router

    var body: some View {
        VStack {
            Text("Favorite heroes")
                .font(.title)
                .bold()
                .padding()

            if viewModel.favorites.isEmpty {
                Text("No favorite heroes yet!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.favorites) { hero in
                    HeroRow(hero: hero, viewModel: viewModel)
                        .onTapGesture {
                            router.push(to: .detail(hero))
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HeroViewModel()
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController, viewModel: viewModel)

        return ContentView(viewModel: viewModel, router: router)
    }
}

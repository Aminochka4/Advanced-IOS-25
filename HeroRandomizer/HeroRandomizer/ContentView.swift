//
//  ContentView.swift
//  HeroRandomizer
//
//  Created by Амина Аманжолова on 02.03.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isStarted = false

    var body: some View {
        VStack {
            ScrollView {
                if viewModel.showFavorites {
                    VStack {
                        Text("Favorite Heroes")
                            .font(.title)
                            .bold()
                            .padding(.top, 20)

                        if viewModel.favorites.isEmpty {
                            Text("Empty...back to choose fav Hero")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(viewModel.favorites) { hero in
                                FavoriteHeroRow(hero: hero, viewModel: viewModel)
                            }
                        }
                    }
                } else {
                    if isStarted, let hero = viewModel.hero {
                        HeroDetailView(hero: hero, viewModel: viewModel)
                    } else {
                        VStack(alignment: .center) {
                            Spacer(minLength: 200)
                            Image("Loading")
                                .resizable()
                                .frame(width: 277, height: 200)
                            Text("Click to try")
                                .font(.headline)
                                .padding()
                                .foregroundColor(Color.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }

            VStack {
                if viewModel.showFavorites {
                    Button("Back to Randomizer") {
                        viewModel.toggleFavoritesView()
                    }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .bold()
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                        .padding(.horizontal, 18)
                } else {
                    Button("Get Random Hero") {
                        viewModel.fetchHeroes()
                        if !isStarted {
                            viewModel.fetchRandomHero()
                            isStarted = true
                        } else {
                            viewModel.fetchRandomHero()
                        }
                    }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .bold()
                        .clipShape(Capsule())
                        .padding(.bottom, 10)
                        .padding(.horizontal, 18)

                    Button("Favorite List") {
                        viewModel.toggleFavoritesView()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .bold()
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
                    .padding(.horizontal, 18)
                }
            }
        }
    }
}

struct HeroDetailView: View {
    let hero: Hero
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(hero.name)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    viewModel.toggleFavorite(hero: hero)
                }) {
                    Image(systemName: viewModel.isFavorite(hero: hero) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite(hero: hero) ? .red : .gray)
                        .font(.title2)
                }
            }
                .padding(.leading, 40)
                .padding(.trailing, 30)

            HStack(alignment: .center, spacing: 16) {
                Spacer(minLength: 5)

                AsyncImage(url: URL(string: hero.images.md)) { image in image.resizable()
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
                    Text("Fullname")
                        .foregroundColor(Color.gray)
                        .font(.caption)
                        .bold()
                    Text(hero.biography.fullName ?? "Unknown")

                    Text("Place of birth")
                        .foregroundColor(Color.gray)
                        .font(.caption)
                        .bold()
                    Text(hero.biography.placeOfBirth ?? "Unknown")

                    Text("Publisher")
                        .foregroundColor(Color.gray)
                        .font(.caption)
                        .bold()
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
                    Text("Gender")
                        .foregroundColor(Color.gray)
                        .font(.caption)
                        .bold()
                    Text("\(hero.appearance.gender)")
                    Text("Race")
                        .foregroundColor(Color.gray)
                        .font(.caption)
                        .bold()
                    Text(hero.appearance.race ?? "Unknown")
                    HStack(){
                        VStack(alignment: .leading, spacing: 8){
                            Text("Height")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                .bold()
                            Text("\(hero.appearance.height[1])")
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 8){
                            Text("Eye color")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                .bold()
                            Text("\(hero.appearance.eyeColor)")
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 8){
                            Text("Hair color")
                                .foregroundColor(Color.gray)
                                .font(.caption)
                                .bold()
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
                                        
            HStack{
                VStack(alignment: .leading, spacing: 8){
                    Text("Occupation")
                        .foregroundColor(Color.gray)
                        .font(.caption)
                        .bold()
                    Text("\(hero.work.occupation)")
                }
                    .padding(.leading, 22)
                Spacer()
            }
            
            Spacer(minLength: 18)
        }
            .animation(.bouncy, value: hero)
    }
}

struct FavoriteHeroRow: View {
    let hero: Hero
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: hero.images.md)) { image in image.resizable()
            } placeholder: {
                ProgressView()
            }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 3)

            Text(hero.name)
                .font(.headline)
                .bold()

            Spacer()

            Button(action: {
                viewModel.toggleFavorite(hero: hero)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.title2)
            }
        }
            .padding(.horizontal, 16)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}


//
//  Router.swift
//  HeroApp
//
//  Created by Амина Аманжолова on 16.03.2025.
//

import UIKit
import SwiftUI

// Enum для маршрутов — просмотр деталей героя и список избранных
enum Route {
    case detail(Hero)
    case favorites
}

class Router: ObservableObject {
    let navigationController: UINavigationController
    let viewModel: HeroViewModel

    init(navigationController: UINavigationController, viewModel: HeroViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    // Для навигации, при выборе героя создаёт HeroDetailView и открывает его, при выборе избранного — FavoritesView
    func push(to route: Route) {
        switch route {
        case .detail(let hero):
            let detailView = HeroDetailView(heroId: hero.id, viewModel: viewModel)
            let hostingController = UIHostingController(rootView: detailView)
            navigationController.pushViewController(hostingController, animated: true)
        case .favorites:
            let favoritesView = FavoritesView(viewModel: viewModel, router: self)
            let hostingController = UIHostingController(rootView: favoritesView)
            navigationController.pushViewController(hostingController, animated: true)
        }
    }
}





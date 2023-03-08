//
//  HomeViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let financeService = FinanceService()
    private var cancellables = Set<AnyCancellable>()

    lazy var homeView: HomeView = {
        let homeView = HomeView()
        homeView.delegate = self
        return homeView
    }()

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfile))
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        financeService.fetchHomeData()
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .compactMap {
                guard let balanceAmount = formatter.string(for: $0?.balance), let savingsAmount = formatter.string(for: $0?.savings), let spendingAmount = formatter.string(for: $0?.spending) else { return nil }
                return HomeHeaderViewState(balanceAmount: balanceAmount, savingsAmount: savingsAmount, spendingAmount: spendingAmount)
            }
            .assign(to: \.homeHeaderViewState, on: homeView.homeHeaderView)
            .store(in: &cancellables)
        
        financeService.fetchHomeData()
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .compactMap {
                $0?.activity.map {
                    let price = formatter.string(for: $0.price)
                    return ActivityCellViewState(name: $0.name, details: "\(price) • \($0.time)")
                }
            }
            .assign(to: \.activities, on: homeView.activityListView)
            .store(in: &cancellables)
    }

    override func loadView() {
        self.view = homeView
    }

    @objc
    func openProfile() {
        let navigationController = UINavigationController(rootViewController: UserProfileViewController())
        self.present(navigationController, animated: true)
    }
}

extension HomeViewController: HomeViewDelegate {

    func didSelectActivity() {
        let activityDetailsViewController = ActivityDetailsViewController()
        self.navigationController?.pushViewController(activityDetailsViewController, animated: true)
    }
}

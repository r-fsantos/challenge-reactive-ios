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
    
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfile))
        
        financeService.fetchHomeData()
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .compactMap { [weak self] homeData in
                return HomeViewState(
                    homeHeaderViewState: self?.mapHomeDataToHeaderViewState(homeData),
                    activityCellViewState: self?.mapHomeDataToActivities(homeData) ?? []
                )
            }
            .assign(to: \.homeViewState, on: homeView)
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
    
    private func mapHomeDataToHeaderViewState(_ homeData: HomeData?) -> HomeHeaderViewState? {
        guard
            let balanceAmount = formatter.string(for: homeData?.balance),
            let savingsAmount = formatter.string(for: homeData?.savings),
            let spendingAmount = formatter.string(for: homeData?.spending)
        else { return nil }
        let homeHeaderViewState = HomeHeaderViewState(
            balanceAmount: balanceAmount,
            savingsAmount: savingsAmount,
            spendingAmount: spendingAmount
        )
        return homeHeaderViewState
    }
    
    private func mapHomeDataToActivities(_ homeData: HomeData?) -> [ActivityCellViewState]? {
        return homeData?.activity.compactMap {
            guard let price = formatter.string(for: $0.price) else { return nil }
            return ActivityCellViewState(
                name: $0.name,
                details: "\(price) • \($0.time)"
            )
        }
    }
}

extension HomeViewController: HomeViewDelegate {

    func didSelectActivity() {
        let activityDetailsViewController = ActivityDetailsViewController()
        self.navigationController?.pushViewController(activityDetailsViewController, animated: true)
    }
}

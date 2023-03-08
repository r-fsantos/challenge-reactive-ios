//
//  HomeViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxSwift

// O saldo é exibido. Proposta: exibir o saldo com abordagem reativa
// é preciso guardar o saldo (BehaviorRelay)?

class HomeViewController: UIViewController {

    // MARK: - Reactive properties
    /// A viewController é responsável pela exibição e controlar fluxos de dados.
    /// Portanto observables são criados aqui. Então, como boa prática, é necessária
    /// uma instância de DisposeBag. Assim, ao fim do ciclo de vida dos observables, juntamente
    /// a viewController, a disposeBag será responsável por efetuar a liberação da memória alocada.
    private let disposeBag = DisposeBag()

    private let balanceObservable = PublishSubject<Double>()

    private func bindObservables() {
        balanceObservable.subscribe(onNext: { balance in
            print("balanceObservable onNext: \(balance)")
            self.homeView.homeHeaderView.label.text = String(format: "$%.3f", balance)
        }).disposed(by: disposeBag)
    }

    lazy var homeView: HomeView = {
        let homeView = HomeView()
        homeView.delegate = self
        return homeView
    }()

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfile))
        bindObservables()
        balanceObservable.onNext(42.543)
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

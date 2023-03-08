//
//  HomeViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxSwift
import RxCocoa

// O saldo é exibido. Proposta: exibir o saldo com abordagem reativa
// é preciso guardar o saldo (BehaviorRelay)?

class HomeViewController: UIViewController {

    // MARK: - Reactive properties
    /// `A viewController é responsável pela exibição e controlar fluxos de dados.
    /// `Portanto observables são criados aqui. Então, como boa prática, é necessária
    /// `uma instância de DisposeBag. Assim, ao fim do ciclo de vida dos observables, juntamente
    /// `a viewController, a disposeBag será responsável por efetuar a liberação da memória alocada.
    private let disposeBag = DisposeBag()

    // MARK: - Escolha por BehaviorRelay`
    /// `É necessário que o observable detenha o valor do último evento emitido,
    /// `É necessário acessar esse valor em tempo de execução e o seu acesso
    /// `Não pode levantar nenhuma exceção/erro, pois será utilizado para atualizar UI`
    private let balanceObservable = BehaviorRelay<Double>(value: 0)

    private func bindObservables() {
        balanceObservable.map { String(format: "$%.2f", $0) }
            .bind(to: homeView.homeHeaderView.label.rx.text)
            .disposed(by: disposeBag)

        homeView.homeHeaderView.incrementButton.rx
            .tap.bind(onNext: {
                let actualValue = self.balanceObservable.value
                let newValue = actualValue + 0.25
                self.balanceObservable.accept(newValue)
            }).disposed(by: disposeBag)

        homeView.homeHeaderView.decrementButton.rx
            .tap.bind(onNext: {
                let actualValue = self.balanceObservable.value
                let newValue = actualValue - 0.25
                self.balanceObservable.accept(newValue)
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
        balanceObservable.accept(42.00)
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

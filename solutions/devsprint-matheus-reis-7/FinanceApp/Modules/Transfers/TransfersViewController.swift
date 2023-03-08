//
//  TransfersViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxCocoa
import RxSwift

final class TransfersViewController: UIViewController {

    private let disposeBag = DisposeBag()

    lazy var transferView: TransfersView = {
        return TransfersView()
    }()

    // 3 - Bind de emissão do valor a ser transferido a um behaviorRelay
    let transferAmountObservable = BehaviorRelay<String>(value: "")

    override func loadView() {
        self.view = transferView
    }

    override func viewDidLoad() {
        bindObservables()
    }

    private func bindObservables() {

        // 3 - Bind de emissão do valor a ser transferido a um behaviorRelay
        transferView.amountTextField.rx
            .text.orEmpty
            .bind(to: transferAmountObservable)
            .disposed(by: disposeBag)

        // 4 subscribe para validar a ideia contida em 3
        // uncomment to debug!
        //        transferAmountObservable.subscribe(onNext: {
        //            print("valor a ser transferido: \($0)")
        //        }).disposed(by: disposeBag)

        // 1 - Reagir ao clique em Choose contact: mostrar os contatos?
        transferView.chooseContactButton.rx
            .tap.bind {
                self.didPressChooseContactButton()
            }.disposed(by: disposeBag)

        // 2 - Reagir ao clique transfer button: mostrar view de transferencia
        transferView.transferButton.rx
            .tap.bind {
                let amount = self.transferAmountObservable.value
                self.didPressTransferButton(withAmount: amount)
            }.disposed(by: disposeBag)
    }

}

// MARK: - Choose contact to transfer area
private extension TransfersViewController {

    // 1 - Reagir ao clique em Choose contact: mostrar os contatos?
    private func didPressChooseContactButton() {
        // TODO: Abstract such navigation knowledge to a coordinator design pattern / route
        let contactListViewController = ContactListViewController()
        contactListViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: contactListViewController)
        self.present(navigationController, animated: true)
    }

}

// MARK: - Transfer area
private extension TransfersViewController {

    // 2 - Reagir ao clique transfer button: mostrar view de transferencia
    private func didPressTransferButton(withAmount amount: String) {
        let confirmationViewController = ConfirmationViewController(amount: amount)
        let navigationController = UINavigationController(rootViewController: confirmationViewController)
        self.present(navigationController, animated: true)
    }

}

// MARK: - TODO: Refactor to Reactive Programming approach
extension TransfersViewController: ContactListViewControllerDelegate {

    func didSelectContact() { }

}

//
//  ActivityDetailsViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import RxCocoa
import RxSwift

final class ActivityDetailsViewController: UIViewController {

    // MARK: - UIView properties
    private let activityDetailsView: ActivityDetailsViewProtocol

    // MARK: - DataSource / UseCase dependencies
    private let service: FinanceService

    // MARK: - Reactive Properties
    private let disposeBag: DisposeBag
    private let activityDetailsObservable = BehaviorRelay<ActivityDetails>(
        value: .init(name: "",
                     price: 0,
                     category: "",
                     time: "")
    )

    // MARK: - Initializers
    // TODO: Abstract FinanceService as ServiceProtocol
    init(activityDetailsView: ActivityDetailsViewProtocol = ActivityDetailsView(),
         service: FinanceService = FinanceService(),
         disposeBag: DisposeBag = DisposeBag()) {
        self.activityDetailsView = activityDetailsView
        self.service = service
        self.disposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - UIViewController lifecycle methods
    override func loadView() {
        self.view = activityDetailsView
    }

    override func viewDidLoad() {
        activityDetailsView.delegate = self
        fetchDataView()
        bindObservables()
    }
}

// MARK: -
private extension ActivityDetailsViewController {

    private func fetchDataView() {
        service.fetchActivityDetails().subscribe(onSuccess: { [weak self ] activityDetails in
            guard let self = self else { return }
            self.activityDetailsObservable.accept(activityDetails)
        }, onFailure: { failure in
            // TODO: What should be the approach on errors?
            print("failure:", failure.localizedDescription)
        }).disposed(by: disposeBag)
    }

}

// MARK: - Observables binding
private extension ActivityDetailsViewController {

    private func bindObservables() {
        activityDetailsObservable
            .asDriver()
            .drive {
                self.activityDetailsView.show(viewModel: $0)
            }.disposed(by: disposeBag)
    }

}

extension ActivityDetailsViewController: ActivityDetailsViewDelegate {

    func didPressReportButton() {

        let alertViewController = UIAlertController(title: "Report an issue", message: "The issue was reported", preferredStyle: .alert)
        let action = UIAlertAction(title: "Thanks", style: .default)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true)
    }
}

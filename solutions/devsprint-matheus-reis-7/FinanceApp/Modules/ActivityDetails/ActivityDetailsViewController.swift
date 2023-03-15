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
    private lazy var activityDetailsView: ActivityDetailsView = {
        let activityDetailsView = ActivityDetailsView()
        activityDetailsView.delegate = self
        return activityDetailsView
    }()

    // MARK: - DataSource / UseCase dependencies
    private let service: FinanceService

    // MARK: - Reactive Properties
    private let disposeBag = DisposeBag()
    private let activityDetailsObservable = BehaviorRelay<ActivityDetails>(
        value: .init(name: "",
                     price: 0,
                     category: "",
                     time: "")
    )

    // MARK: - Initializers
    init(service: FinanceService = FinanceService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - UIViewController lifecycle methods
    override func loadView() {
        self.view = activityDetailsView
    }

    override func viewDidLoad() {
        bindObservables()
        fetchDataView()
    }
}

private extension ActivityDetailsViewController {

    func fetchDataView() {
        service.fetchActivityDetails().subscribe(onSuccess: { [weak self] activityDetails in
            guard let self = self else { return }
            self.activityDetailsObservable.accept(activityDetails)
        }, onFailure: { failure in
            print("failure:", failure.localizedDescription)
        }).disposed(by: disposeBag)
    }

}

private extension ActivityDetailsViewController {

    func bindObservables() {
        activityDetailsObservable
            .asDriver()
            .drive { [weak self] activityDetails in
                guard let self = self else { return }
                self.activityDetailsView.show(viewModel: activityDetails)
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

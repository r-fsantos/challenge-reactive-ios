//
//  ActivityDetailsViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit

final class ActivityDetailsViewController: UIViewController {

    // MARK: - UIView properties
    private let activityDetailsView: ActivityDetailsView

    // MARK: - Initializers
    // TODO: Abstract FinanceService as ServiceProtocol
    init(activityDetailsView: ActivityDetailsView = ActivityDetailsView()) {
        self.activityDetailsView = activityDetailsView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - UIViewController lifecycle methods
    override func loadView() {
        self.view = activityDetailsView
    }

    override func viewDidLoad() {
        activityDetailsView.delegate = self
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

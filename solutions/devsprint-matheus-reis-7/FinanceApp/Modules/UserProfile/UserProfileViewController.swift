//
//  UserProfileViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit
import Combine

class UserProfileViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let financeService = FinanceService()
    
    private lazy var userView: UserProfileView = {
        UserProfileView()
    }()

    override func loadView() {
        self.view = userView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        financeService.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: \.userProfileData, on: userView)
            .store(in: &cancellables)        
    }
}

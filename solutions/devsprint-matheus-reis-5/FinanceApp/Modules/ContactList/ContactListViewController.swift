//
//  ContactListViewController.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit

protocol ContactListViewControllerDelegate: AnyObject {
    func selected(contact: Contact)
}

final class ContactListViewController: UIViewController {

    weak var delegate: ContactListViewControllerDelegate?

    lazy var contactListView: ContactListView = {

        let contactListView = ContactListView()
        contactListView.delegate = self
        return contactListView
    }()

    override func loadView() {
        self.view = contactListView
    }

    override func viewDidLoad() {
        self.title = "Contact List"
    }
}

extension ContactListViewController: ContactListViewDelegate {
    func didSelect(contact: Contact) {
        delegate?.selected(contact: contact)
    }
}

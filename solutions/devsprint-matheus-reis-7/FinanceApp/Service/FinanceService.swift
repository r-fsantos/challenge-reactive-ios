//
//  FinanceService.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import Foundation
import Combine
import RxSwift

enum FinanceServiceEndpoints {
    case activityDetails

    var urlString: String {
        switch self {
        case .activityDetails:
            return "https://raw.githubusercontent.com/devpass-tech/challenge-viewcode-finance/10ce6c2e9c88199ad8c4e721212099f55b26dfbb/api/activity_details_endpoint.json"
        }
    }
}

final class FinanceService {

    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    init(urlSession: URLSession = URLSession.shared,
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    // MARK: - fetchHomeData
    func fetchHomeData() -> AnyPublisher<HomeData?, Error> {
        let url = URL(string: "https://raw.githubusercontent.com/devpass-tech/challenge-finance-app/main/api/home_endpoint.json")!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: HomeData?.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    // MARK: - fetchContactList
    func fetchContactList(_ completion: @escaping ([Contact]?) -> Void) {

        let url = URL(string: "https://raw.githubusercontent.com/devpass-tech/challenge-finance-app/main/api/contact_list_endpoint.json")!

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let contactList = try decoder.decode([Contact].self, from: data)
                completion(contactList)
            } catch {
                print(error)
                completion(nil)
            }
        }

        dataTask.resume()
    }

    // MARK: - transferAmount
    func transferAmount(_ completion: @escaping (TransferResult?) -> Void) {

        let url = URL(string: "https://raw.githubusercontent.com/devpass-tech/challenge-finance-app/main/api/transfer_successful_endpoint.json")!

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let transferResult = try decoder.decode(TransferResult.self, from: data)
                completion(transferResult)
            } catch {
                print(error)
                completion(nil)
            }
        }

        dataTask.resume()
    }

    func fetchUserProfile() -> AnyPublisher<UserProfile?, Error> {
        let url = URL(string: "https://raw.githubusercontent.com/devpass-tech/challenge-finance-app/main/api/user_profile_endpoint.json")!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UserProfile?.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

}

// MARK: - fetchActivityDetails using RxSwift
extension FinanceService {
    func fetchActivityDetails() -> Single<ActivityDetails> {
        return Single<ActivityDetails>.create { single in

            let urlInString = FinanceServiceEndpoints.activityDetails.urlString
            guard let url = URL(string: urlInString) else {
                single(.failure(NetworkServiceError.invalidURL))
                return Disposables.create()
            }

            let dataTask = self.urlSession.dataTask(with: url) { [weak self] data, response, error in

                guard let self = self else {
                    single(.failure(NetworkServiceError.networkError))
                    return
                }

                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let data = data else {
                    single(.failure(NetworkServiceError.noData))
                    return
                }

                do {
                    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let activityDetails = try self.jsonDecoder.decode(ActivityDetails.self, from: data)
                    single(.success(activityDetails))
                } catch {
                    single(.failure(NetworkServiceError.decodeError))
                }
            }

            dataTask.resume()

            return Disposables.create { dataTask.cancel() }
        }
    }
}

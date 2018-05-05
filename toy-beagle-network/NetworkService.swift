//
//  NetworkService.swift
//  toy-beagle-network
//
//  Created by Faiz Mokhtar on 04/05/2018.
//  Copyright © 2018 Faiz Mokhtar. All rights reserved.
//

import Foundation
import Alamofire

struct Route<Model> {
    let endpoint: String
}

struct Routes {
    static let allBreeds = Route<Breeds>(endpoint: "breeds/list/all")
}

enum Result<Model> {
    case success(Model)
    case failure(Error)
}

final class NetworkService {
    let baseURL: String

    init(withBaseURL baseURL: String) {
        self.baseURL = baseURL
    }

    func fetch<Model: Codable> (fromRoute route: Route<Model>, then: @escaping (Result<Model>) -> Void) {
        guard let url = URL(string: self.baseURL + route.endpoint) else {
            then(.failure(NSError(domain: "", code: 500, userInfo: nil)))
            return
        }

        Alamofire.request(url).responseData { response in
            guard response.error == nil else {
                then(.failure(response.error!))
                return
            }

            if let data = response.data,
                let model = try? JSONDecoder().decode(Model.self, from: data) {
                then(.success(model))
            } else {
                then(.failure(NSError(domain: "", code: 1000, userInfo: ["error": "wrong model"])))
            }
        }
    }
}

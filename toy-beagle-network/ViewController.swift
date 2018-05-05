//
//  ViewController.swift
//  toy-beagle-network
//
//  Created by Faiz Mokhtar on 04/05/2018.
//  Copyright © 2018 Faiz Mokhtar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var breeds = [String: [String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        let networkService = NetworkService(withBaseURL: "https://dog.ceo/api/")
        networkService.fetch(fromRoute: Routes.allBreeds) { result in
            switch result {
            case .success(let model):
                print(model.message)
                self.breeds = model.message
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let key = Array(self.breeds.keys)[indexPath.row]
        cell.textLabel?.text = key
        return cell
    }
}

extension ViewController: UITableViewDelegate {

}


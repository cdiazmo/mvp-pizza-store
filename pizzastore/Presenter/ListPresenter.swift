//
//  File.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import Foundation


protocol MasterViewPresenter: class {
    var pizzas: [Pizza] { get }
    var pizzaCount: Int { get }
    func loadPizzas()
    func getPizzaAt(position: IndexPath) -> Pizza?
}

class ListPresenter: MasterViewPresenter {
    final let urlPizzas = "https://gist.githubusercontent.com/cdiazmo/5259a435fa94162d26116e7d9fdb301f/raw"
    weak var viewController: PizzaListViewController?
    var pizzaList: [Pizza]? = []
    
    init(_ controller: PizzaListViewController) {
        viewController = controller
    }
    
    var pizzaCount: Int {
        return pizzaList?.count ?? 0
    }
    
    var pizzas: [Pizza] {
        return pizzaList ?? []
    }
    
    func loadPizzas() {
        NetworkManager.shared.networkRequest(url: urlPizzas) { (data, error) in
            DispatchQueue.main.async { [weak self] in
                if let pizzaArray = data {
                    do {
                        let decoder = JSONDecoder()
                        self?.pizzaList = try decoder.decode([Pizza].self, from: pizzaArray)
                    }
                    catch {
                        print (error)
                    }
                    self?.viewController?.reloadData()
                }
            }
        }
    }
    
    func getPizzaAt(position: IndexPath) -> Pizza? {
        if(position.row < (pizzaList?.count ?? 0)) {
            return pizzaList?[position.row]
        }
        return nil
    }
    
}

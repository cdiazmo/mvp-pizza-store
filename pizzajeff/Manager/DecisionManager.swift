//
//  DecisionManager.swift
//  pizzajeff
//
//  Created by Carlos Diaz Moreno on 4/2/21.
//

import Foundation

class DecisionManager {
    
    private final let defaultMovie = Movie(title: "Gladiator", year: "2000", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "https://m.media-amazon.com/images/M/MV5BMDliMmNhNDEtODUyOS00MjNlLTgxODEtN2U3NzIxMGVkZTA1L2ltYWdlXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", dvd: "", boxOffice: "", production: "", website: "", response: "")
    private var pizzaList:[Pizza]?
    private  var rules = ["SINGLE": "M", "MARRIED": "XL"]
    private var pizzaMargin = ["S": 1, "M": 3, "L": 5, "XL": 6]
    private var pizzaSizeRule = ["XL":"S", "L": "M", "M": "S", "S": "S"]
    private var isSingleClient: Bool = false
    private var orderedPizza: Pizza?
    private var orderedSize: String?
    
    init(pizzaList: [Pizza]?, orderedPizza: Pizza?, isSingleClient: Bool) {
        self.pizzaList = pizzaList
        self.orderedPizza = orderedPizza
        self.isSingleClient = isSingleClient
    }
    
    func run(orderedSize: String, _ completion: @escaping (AnyObject?) -> Void){
        self.orderedSize = orderedSize
        if(!isSingleClient) {
            suggestMovies({ movie in
                completion(movie as AnyObject)
            })
        } else {
            suggestAnotherItem( { pizzaOffer in
                completion(pizzaOffer as AnyObject)
            })
        }
    }
    
    func recommendedPizzaIndex() -> Int? {
        let pizzaSize = isSingleClient ? rules["SINGLE"] : rules["MARRIED"]
        return orderedPizza?.prices.compactMap({$0.size}).lastIndex(of: pizzaSize)
    }
    
    private func getMovie(_ completion: @escaping (Movie?) -> Void) {
        let character = ["r", "a", "n", "d", "o", "m"].randomElement() ?? "a"
        let year = ["2019", "2020", "2021"].randomElement() ?? "2020"
        let movieUrl = "http://www.omdbapi.com/?t=\(character)&y=\(year)&apikey=734db3f0"
        NetworkManager.shared.networkRequest(url: movieUrl) { (data, error) in
            if let data = data, error == nil {
                let movie = try? JSONDecoder().decode(Movie.self, from: data)
                completion(movie)
            } else {
                completion(nil)
            }
        }
    }
    
    private func generatePizzaOffer(nextSize: String, offeredPizza: Pizza) -> PizzaOffer? {
        if let price = offeredPizza.prices.first(where: { (price) -> Bool in
            price.size == nextSize
        })?.price, let margin = pizzaMargin[nextSize] {
            let total = Double(price) + Double(margin)
            let totalWithDiscount = Double(price) + Double(margin/2)
            let discount = (total - totalWithDiscount) / total * 100
            return PizzaOffer(pizza: offeredPizza, price: totalWithDiscount, size: nextSize, discount: discount)
        }
        return nil
    }
    
    private func suggestMovies(_ completion: @escaping (Movie?) -> Void) {
        getMovie({ [weak self] movie in
            let suggestedMovie = movie ?? self?.defaultMovie
            completion(suggestedMovie)
        })
    }
    
    private func suggestAnotherItem(_ completion: @escaping (PizzaOffer?) -> Void) {
        
        if let nextSize = pizzaSizeRule[orderedSize ?? "S"], let pizza = orderedPizza {
            var pizzaArray = pizzaList
            if let index = pizzaArray?.firstIndex(where: { (pizzaInArray) -> Bool in
                pizzaInArray.id == pizza.id
            }) {
                pizzaArray?.remove(at: index)
            }
            pizzaArray?.removeAll(where: { (pizzaInArray) -> Bool in
                pizzaInArray.id == pizza.id || !pizzaInArray.prices.contains(where: { (price) -> Bool in
                    price.size == nextSize
                })
            })
            
            let offeredPizza = pizzaArray?.randomElement() ?? pizza
            let pizzaOffer = generatePizzaOffer(nextSize: nextSize, offeredPizza: offeredPizza)
            completion(pizzaOffer)
            
        } else {
            completion(nil)
        }
    }
}

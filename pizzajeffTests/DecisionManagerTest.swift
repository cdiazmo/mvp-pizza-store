//
//  DecisionManager.swift
//  pizzajeffTests
//
//  Created by Carlos Diaz Moreno on 4/2/21.
//

import XCTest
@testable import pizzajeff

class DecisionManagerTest: XCTestCase {

    func createPizza() -> Pizza {
        return Pizza(id: 1, name: "Pizza", content: "Recipe", imageURL: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", prices: [Price(size: "L", price: 2), Price(size: "XL", price: 4)])
    }

    func createPizzaList() -> [Pizza] {
        return [Pizza(id: 1, name: "Pizza", content: "Recipe", imageURL: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", prices: [Price(size: "L", price: 3), Price(size: "XL", price: 4)]),Pizza(id: 2, name: "Pizza2", content: "Recipe2", imageURL: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", prices: [Price(size: "2", price: 1), Price(size: "M", price: 2)])]
    }

    
    func testRecommendedPizzaSuccess() {
        let pizza = createPizza()
        let pizzaList = createPizzaList()
        // other setup
        var recommendationResult: AnyObject?
        let decisionManager = DecisionManager(pizzaList: pizzaList, orderedPizza: pizza, isSingleClient: true)

        let exp = expectation(description: "Check pizza recommendation is successful")

        decisionManager.run(orderedSize: "L") { (recommended) in
            recommendationResult = recommended
            exp.fulfill()
        }

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertNotNil(recommendationResult is PizzaOffer)
        }
    }
    
    func testRecommendedMovieSuccess() {
        let pizza = createPizza()
        let pizzaList = createPizzaList()
        // other setup
        var recommendationResult: AnyObject?
        let decisionManager = DecisionManager(pizzaList: pizzaList, orderedPizza: pizza, isSingleClient: false)

        let exp = expectation(description: "Check pizza recommendation is successful")

        decisionManager.run(orderedSize: "L") { (recommended) in
            recommendationResult = recommended
            exp.fulfill()
        }

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertNotNil(recommendationResult is Movie)
        }
    }

}

//
//  PizzaListViewController.swift
//  pizzastoreTests
//
//  Created by Carlos Diaz Moreno on 4/2/21.
//

import XCTest
@testable import pizzastore


class MasterPresenterMock: MasterViewPresenter {
    private(set) var onGetPizzasCalled = false

    var pizzas: [Pizza] {
        get {
            onGetPizzasCalled = true
            return []
        }
        
    }
    
    private(set) var onGetPizzaCountCalled = false

    var pizzaCount: Int {
        get {
            onGetPizzaCountCalled = true
            return pizzas.count
        }
    }
    private(set) var onLoadPizzasCalled = false

    func loadPizzas() {
        onLoadPizzasCalled = true
    }
    
    private(set) var onGetPizzaAtCalled = false

    func getPizzaAt(position: IndexPath) -> Pizza? {
        onGetPizzaAtCalled = true
        return nil
    }
    
}

class PizzaListViewControllerTest: XCTestCase {

    let presenterMock = MasterPresenterMock()

    func createPizza() -> Pizza {
        return Pizza(id: 1, name: "Pizza", content: "Recipe", imageURL: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", prices: [Price(size: "L", price: 2), Price(size: "XL", price: 4)])
    }
    
    func loadUIMock() -> PizzaListViewController {
        let masterViewController = PizzaListViewController(nibName: String(describing: PizzaListViewController.self), bundle: nil)
        masterViewController.presenter = presenterMock
        masterViewController.loadViewIfNeeded()
        return masterViewController
    }
    
    func loadUI(pizza: Pizza) -> PizzaListViewController {
        let masterViewController = PizzaListViewController(nibName: String(describing: PizzaListViewController.self), bundle: nil)
        masterViewController.loadViewIfNeeded()
        return masterViewController
    }
    
    func testViewDidLoadCallsPresenter() {
        let vc = loadUIMock()
        vc.viewWillAppear(true)
        XCTAssertTrue(presenterMock.onLoadPizzasCalled)
    }
}

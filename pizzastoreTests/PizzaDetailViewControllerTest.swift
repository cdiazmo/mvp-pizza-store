//
//  PizzaDetailViewControllerTest.swift
//  pizzastoreTests
//
//  Created by Carlos Diaz Moreno on 4/2/21.
//

import XCTest
@testable import pizzastore


class DetailPresenterMock: DetailViewPresenter {
    
    private(set) var onLoadViewCalled = false

    func loadView() {
        onLoadViewCalled = true
    }
    
    private(set) var onFinishOrderCalled = false

    func finishOrder() {
        onFinishOrderCalled = true
    }
}

class PizzaDetailViewControllerTest: XCTestCase {

    let presenterMock = DetailPresenterMock()

    func createPizza() -> Pizza {
        return Pizza(id: 1, name: "Pizza", content: "Recipe", imageURL: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", prices: [Price(size: "L", price: 2), Price(size: "XL", price: 4)])
    }
    
    func loadUIMock() -> PizzaDetailViewController {
        let detailViewController = PizzaDetailViewController(nibName: String(describing: PizzaDetailViewController.self), bundle: nil, pizzaList: nil, pizza: createPizza(), isSingleClient: false)
        detailViewController.presenter = presenterMock
        detailViewController.loadViewIfNeeded()
        return detailViewController
    }
    
    func loadUI(pizza: Pizza) -> PizzaDetailViewController {
        let detailViewController = PizzaDetailViewController(nibName: String(describing: PizzaDetailViewController.self), bundle: nil, pizzaList: nil, pizza: pizza, isSingleClient: false)
        detailViewController.loadViewIfNeeded()
        return detailViewController
    }
    
    func testViewDidLoadCallsPresenter() {
        let vc = loadUIMock()
        
        vc.loadView()
        
        XCTAssertTrue(presenterMock.onLoadViewCalled)
    }

    func testOnfinishOrder() {
        let vc = loadUIMock()
        
        vc.continueAction((Any).self)
        
        XCTAssertTrue(presenterMock.onFinishOrderCalled)
    }
    
    func testView() {
        
        let pizza = createPizza()
        
        let vc = loadUI(pizza: pizza)
        vc.loadView()
    
        XCTAssertEqual(vc.navigationItem.title, pizza.name)
        XCTAssertEqual(vc.titleLabel.text, pizza.name)
        XCTAssertEqual(vc.descriptionLabel.text, pizza.content)
        XCTAssertEqual(vc.segmentedControl.titleForSegment(at: 0), "L - 2.00€")
    }
    
    func testViewError() {
        let pizza = createPizza()
        
        let vc = loadUI(pizza: Pizza(id: 3, name: "name", content: "desc", imageURL: "url", prices: [Price(size: "A", price: 3)]))
        vc.loadView()
    
        XCTAssertNotEqual(vc.navigationItem.title, pizza.name)
        XCTAssertNotEqual(vc.titleLabel.text, pizza.name)
        XCTAssertNotEqual(vc.descriptionLabel.text, pizza.content)
        XCTAssertNotEqual(vc.segmentedControl.titleForSegment(at: 0), "\(pizza.prices[0].size) - \(pizza.prices[0].price)€")
    }
}

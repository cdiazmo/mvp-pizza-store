//
//  pizzastoreUITests.swift
//  pizzastoreUITests
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import XCTest

class pizzastoreUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }


    func testHappyPath() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        //comprobar que estamos en la primera página
        let nameTextField = app.textFields["nameTextField"]
        XCTAssert(nameTextField.exists)
        tapElementAndWaitForKeyboardToAppear(element:nameTextField)
        nameTextField.typeText("name")

        let emailTextField = app.textFields["emailTextField"]
        XCTAssert(emailTextField.exists)
        tapElementAndWaitForKeyboardToAppear(element: emailTextField)
        emailTextField.typeText("email")

        let passwordTextField = app.secureTextFields["passwordTextField"]
        XCTAssert(passwordTextField.exists)
        tapElementAndWaitForKeyboardToAppear(element:passwordTextField)
        passwordTextField.typeText("password")
        passwordTextField.typeText("\n")

        let loginButton = app.buttons["loginButton"]
        XCTAssert(loginButton.exists)
        loginButton.tap()

        let pizzaList = app.collectionViews.firstMatch
        _ = pizzaList.waitForExistence(timeout: 5)
        XCTAssert(pizzaList.exists)
        pizzaList.cells.element(boundBy:0).tap()

        let finalizeOrderButton = app.buttons["finalizeOrderButton"]
        XCTAssert(finalizeOrderButton.exists)
        finalizeOrderButton.tap()

        let acceptButton = app.buttons["acceptButton"]
        XCTAssert(acceptButton.exists)
        acceptButton.tap()

        let continueButton = app.buttons["continueButton"]
        XCTAssert(continueButton.exists)
        continueButton.tap()

        let logoutButton = app.navigationBars.buttons["logoutButton"]
        XCTAssert(logoutButton.exists)
        logoutButton.tap()
        
        _ = app.buttons["loginButton"].waitForExistence(timeout: 5)
        XCTAssert(app.buttons["loginButton"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCTestCase {

    func tapElementAndWaitForKeyboardToAppear(element: XCUIElement) {
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            element.tap()
            if keyboard.exists {
                break;
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
    }
}

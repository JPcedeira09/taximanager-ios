//
//  TaxiManagerUITests.swift
//  TaxiManagerUITests
//
//  Created by Esdras Martins on 18/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import XCTest

class TaxiManagerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let textField = app.textFields["telaInicialTextFieldOrigem"]
        textField.tap()
        let searchSearchField = app.navigationBars["searchBar"].searchFields["Search"]
        searchSearchField.tap()
        searchSearchField.typeText("Avenida Paulista, 1374")
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["Avenida Paulista, 1374"].tap()
        searchSearchField.tap()
        
        let gaUnitedStatesStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["GA, United States"]/*[[".cells.staticTexts[\"GA, United States\"]",".staticTexts[\"GA, United States\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        gaUnitedStatesStaticText.tap()
        gaUnitedStatesStaticText.tap()
        searchSearchField.typeText("Avenida Ibirapuera")
        
                                
        
    }
    
}

//
//  CardapioServicesTests.swift
//  CardapioServicesTests
//
//  Created by Gustavo Avena on 7/3/18.
//  Copyright © 2018 Gustavo Avena. All rights reserved.
//

import XCTest
//import Firebase
@testable import BandecoUnicamp


class MockUserDefaults: UserDefaults {
    var vegetariano: Bool = false
    
    override func bool(forKey defaultName: String) -> Bool {
        if defaultName == VEGETARIANO_KEY_STRING {
            return self.vegetariano
        } else {
            return false
        }
    }
}


class CardapioServicesTests: XCTestCase {
    var cardapioServices = CardapioServices.shared
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cardapioServices.defaults = MockUserDefaults()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.xe
        super.tearDown()
    }
    
    func testUsarCardapioDoProximoDia() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let tuesdayMorning = formatter.date(from: "2018/03/06 08:00")
        
        XCTAssertEqual(cardapioServices.usarCardapioDoProximoDia(tuesdayMorning), false, "Teste de terca de manha falhou.")
        
        
        let wednesdayAfterNoon = formatter.date(from: "2018/03/07 13:00")
        
        XCTAssertEqual(cardapioServices.usarCardapioDoProximoDia(wednesdayAfterNoon), false, "Teste de quarta a tarde falhou.")
        
        let wednesdayEvening = formatter.date(from: "2018/03/07 21:00")
        
        XCTAssertEqual(cardapioServices.usarCardapioDoProximoDia(wednesdayEvening), true, "Teste de quarta a noite falhou.")
        
        let saturdayMorning = formatter.date(from: "2018/03/10 08:00")
        
        XCTAssertEqual(cardapioServices.usarCardapioDoProximoDia(saturdayMorning), true, "Teste de sabado de manha falhou.")
        
        let sundayAfternoon = formatter.date(from: "2018/03/11 14:00")
        
        XCTAssertEqual(cardapioServices.usarCardapioDoProximoDia(sundayAfternoon), true, "Teste de domingo de tarde falhou.")

        
        
        
    }
    

    func testGetTipoRefeicaoParaExibir() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let almoco = formatter.date(from: "2018/03/07 09:00")
        let jantar = formatter.date(from: "2018/03/07 15:00")

        
        // testo almoco tradicional
        let almocoTradicional = cardapioServices.getTipoRefeicaoParaExibir(dataCardapio: almoco!, almoco)
        
        let jantarTradicional = cardapioServices.getTipoRefeicaoParaExibir(dataCardapio: jantar!, jantar)
        
        XCTAssertEqual(almocoTradicional, TipoRefeicao.almoco, "Almoco Tradicional falhou.")
        
        XCTAssertEqual(jantarTradicional, TipoRefeicao.jantar, "Jantar Tradicional falhou.")
        
        // testo jantar tradicional
        
        (cardapioServices.defaults as! MockUserDefaults).vegetariano = true
        
        let almocoVegetariano = cardapioServices.getTipoRefeicaoParaExibir(dataCardapio: almoco!, almoco)
        
        let jantarVegetariano = cardapioServices.getTipoRefeicaoParaExibir(dataCardapio: almoco!, jantar)
        
        XCTAssertEqual(almocoVegetariano, TipoRefeicao.almocoVegetariano, "Almoco Tradicional falhou.")
        
        XCTAssertEqual(jantarVegetariano, TipoRefeicao.jantarVegetariano, "Jantar Tradicional falhou.")
    }
    
}

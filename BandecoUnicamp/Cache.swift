//
//  Cache.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 24/07/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit


class Cache: NSObject {
    
    private static var sharedCache: Cache = {
        let cache = Cache()
        return cache
    }()
    
    class func shared() -> Cache {
        return sharedCache
    }
    
    public var cardapios: [Cardapio]
   
    
    private override init() {
       self.cardapios = [Cardapio]()
    }
}

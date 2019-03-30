//
//  LibraryModel.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

protocol LibraryModel {
    
    associatedtype Item
    
    func getItems() -> [Item]
    
//    func load(index: Int, completion: (Item?) -> ())
}

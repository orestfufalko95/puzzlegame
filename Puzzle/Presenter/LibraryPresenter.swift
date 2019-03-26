//
//  File.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

protocol LibraryPresenter{
    
    associatedtype View: LibraryView
    
    func attachView(view: View)
    
    func detachView()
}

//
//  PhotoLibraryPresenter.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

class PhotoLibraryPresenter: LibraryPresenter {
    
    typealias View = LibraryTableViewController
    
    // TODO: maybe add as weak
    private weak var view: View?
    
    func attachView(view: LibraryTableViewController) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
}

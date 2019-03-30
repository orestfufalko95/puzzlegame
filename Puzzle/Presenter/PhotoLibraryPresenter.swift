//
//  PhotoLibraryPresenter.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class PhotoLibraryPresenter: LibraryPresenter {
    
    typealias View = LibraryTableViewController
    typealias Model = PhotoLibraryModel
    
    // TODO: maybe add as weak
    private weak var view: View?
    private weak var model: Model?
    
    func attachView(view: View, model: Model) {
        self.view = view
        self.model = model
    }
    
    func detachView() {
        self.view = nil
    }
    
    func load(index: Int, completion: (UIImage?) -> ()) {
        self.model?.load(index: index, completion: completion)
    }
}

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
    
    private weak var view: View?
    
    private var model: Model!
    
    init(model: Model) {
        self.model = model
    }
    
    func attachView(view: View) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func load(index: Int, completion: @escaping (UIImage?) -> ()) {
        print("presenter load")
        self.model?.load(index: index, completion: completion)
    }
}

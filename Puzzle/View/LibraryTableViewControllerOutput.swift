//
// Created by Orest Fufalko on 2019-04-03.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

protocol LibraryTableViewControllerOutput: class {

	var itemsCount: Int { get }

	func handleViewCreated()

	func fetchNewItems()

	func photo(index: Int) -> PhotoEntity
}

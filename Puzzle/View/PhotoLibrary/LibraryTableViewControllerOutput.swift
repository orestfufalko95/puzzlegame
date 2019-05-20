//
// Created by Orest Fufalko on 2019-04-03.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

protocol LibraryTableViewControllerOutput: class {

	var itemsCount: Int { get }

	var title: String { get }

	var isPrefetchEnabled: Bool { get }

	func handleViewCreated()

	func prefetch(indexes: [Int])

	func photo(index: Int) -> Photo

	func photoSelected(index: Int)
}

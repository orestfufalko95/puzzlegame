//
// Created by Orest Fufalko on 2019-04-03.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

protocol PhotoLibraryModelInput {

	func updateItems()

	func fetchNewItems(startIndex: Int, count: Int)
}

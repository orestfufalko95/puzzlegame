//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

protocol PhotoPuzzleModelInput {

	func createPuzzles(photo: Photo, puzzlesSize: Int)

	func saveCompletedPuzzle(photo: Photo, index: Int)
}
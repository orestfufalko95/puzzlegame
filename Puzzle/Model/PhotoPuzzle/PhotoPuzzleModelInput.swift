//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

protocol PhotoPuzzleModelInput: class {

	func createPuzzles(photo: PhotoEntity, puzzlesSize: Int)
}
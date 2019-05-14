//
// Created by Orest Fufalko on 2019-04-10.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

protocol PhotoPuzzleViewControllerInput: class {

	var selectedPuzzleSize: Int { get }

	func reload()

	func setTime(seconds: Int)

	func setTimerView()

	func setStartView()
}

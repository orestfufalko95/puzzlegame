//
// Created by Orest Fufalko on 2019-04-08.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleViewController: UIViewController {

	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet weak var puzzleSizeSegment: UISegmentedControl!

	var output: PhotoPuzzleViewControllerOutput?

	private lazy var startButton: UIBarButtonItem = { [weak self] in
		return UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(self?.handleStart))
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "Puzzle Game"

		self.collectionView.dataSource = self

		self.output?.handleViewLoaded()

		self.setStartView()

		self.collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:))))

		self.collectionView.collectionViewLayout = PuzzleCollectionViewFlowLayout(delegate: self)
	}

	@IBAction func handlePuzzleSizeSelected(_ sender: Any) {
		self.output?.handlePuzzleSizeSelected()
	}

	@objc private func handleStart() {
		self.output?.startGame()
	}

	@objc private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
		switch (gesture.state) {

		case .began:
			if let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) {
				self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
				self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
			}

		case .changed:
			self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))

		case .ended:
			self.collectionView.endInteractiveMovement()

		default:
			self.collectionView.cancelInteractiveMovement()
		}
	}
}

extension PhotoPuzzleViewController: PhotoPuzzleViewControllerInput {

	var selectedPuzzleSize: Int {
		return self.puzzleSizeSegment.selectedSegmentIndex
	}


	func reload() {
		self.collectionView.reloadData()
	}

	func setTime(seconds: Int) {
		self.navigationItem.rightBarButtonItem?.title = String(seconds)

	}

	func setTimerView() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
	}

	func setStartView() {
		self.navigationItem.rightBarButtonItem = startButton
	}
}

extension PhotoPuzzleViewController: UICollectionViewDataSource {

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.output?.puzzlesCount ?? 0
	}

	public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return true
	}

	public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		self.output?.swap(fromIndex: sourceIndexPath.item, toIndex: destinationIndexPath.item)
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPuzzleCell.identifier, for: indexPath)

		if let puzzleCell = cell as? PhotoPuzzleCell {
			let puzzleEntity: Puzzle! = self.output?.puzzleEntity(for: indexPath.row)
			puzzleCell.photo?.image = puzzleEntity?.image
			puzzleCell.coordinateLabel?.text = "\(puzzleEntity.x)-\(puzzleEntity.y)"
		}

		return cell
	}
}

extension PhotoPuzzleViewController: PuzzleFlowLayoutDelegate {

    var gridSize: Int {
	    if let size = self.output?.puzzlesSize {
		    return size
	    } else {
		    return 1
	    }
    }
}

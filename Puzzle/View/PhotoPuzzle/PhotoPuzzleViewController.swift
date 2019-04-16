//
// Created by Orest Fufalko on 2019-04-08.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleViewController: UIViewController {

	@IBOutlet private weak var collectionView: UICollectionView!

	var output: PhotoPuzzleViewControllerOutput?

	private var cellSize: CGSize? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "Puzzle Me"
		let backItem = UIBarButtonItem()
		backItem.title = "Something Else"
		self.navigationItem.hidesBackButton = false
		self.navigationItem.leftBarButtonItem = backItem

		self.navigationController?.navigationBar.topItem?.title = "asdfasdf"

		self.collectionView.delegate = self
		self.collectionView.dataSource = self

		self.output?.handleViewLoaded()

		self.collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:))))

		if let height = self.output?.puzzlesCellHeight(containerHeight: Int(self.collectionView.frame.height)),
		   let width = self.output?.puzzlesCellWidth(containerWidth: Int(self.collectionView.frame.width)) {

			self.cellSize = CGSize(width: width, height: height)
		} else {
			self.cellSize = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
		}
	}

	@objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
		switch (gesture.state) {

		case .began:
			guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
				break
			}
			self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
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

	func reload() {
		self.collectionView.reloadData()
	}
}

extension PhotoPuzzleViewController: UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return self.cellSize!
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
		print("Starting Index: \(sourceIndexPath.item) Ending Index: \(destinationIndexPath.item)")
		self.output?.swap(fromIndex: sourceIndexPath.item, toIndex: destinationIndexPath.item)
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPuzzleCell.identifier, for: indexPath)

		if let puzzleCell = cell as? PhotoPuzzleCell {
			let puzzleEntity: PuzzleEntity! = self.output?.puzzleEntity(for: indexPath.row)
			puzzleCell.photo?.image = puzzleEntity?.image
			puzzleCell.coordinateLabel?.text = "\(puzzleEntity.x)-\(puzzleEntity.y)"
		}

		return cell
	}
}

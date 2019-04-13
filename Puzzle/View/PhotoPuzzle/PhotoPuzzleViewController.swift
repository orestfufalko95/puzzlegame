//
// Created by Orest Fufalko on 2019-04-08.
// Copyright (c) 2019 Orest Fufalko. All rights reserved.
//

import UIKit

final class PhotoPuzzleViewController: UIViewController {

	@IBOutlet private weak var collectionView: UICollectionView!

	var output: PhotoPuzzleViewControllerOutput?

	private var cellWidth: CGFloat = 0
	private var cellHeight: CGFloat = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView.delegate = self

		let count: Int? = self.output?.puzzlesCount
//		print("count: \(count)")
		let puzzlesCount: CGFloat = CGFloat(3)//count ?? 1)
		self.cellWidth = self.collectionView.frame.size.width / puzzlesCount
		self.cellHeight = self.collectionView.frame.size.height / puzzlesCount
		print("\(puzzlesCount)")

//		print(" cellHeight: \(self.cellHeight)")
		self.collectionView.dataSource = self

		self.output?.handleViewLoaded()
	}
}

extension PhotoPuzzleViewController: PhotoPuzzleViewControllerInput {
	func reload() {
		self.collectionView.reloadData()
	}
}

extension PhotoPuzzleViewController: UICollectionViewDataSource {

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.output?.puzzlesCount ?? 0
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPuzzleCell.identifier, for: indexPath)

		if let puzzleCell = cell as? PhotoPuzzleCell {
			let puzzleEntity: PuzzleEntity! = self.output?.puzzleEntity(for: indexPath.row)
			let image: UIImage? = puzzleEntity?.image
			puzzleCell.photo?.image = image
			puzzleCell.coordinateLabel?.text = "\(puzzleEntity.x)-\(puzzleEntity.y)"
		}

		return cell
	}
}

extension PhotoPuzzleViewController: UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.frame.width * 0.95
//		print("width: \(width)   rounded: \((width/3).rounded(.down))")
		return CGSize(width: (width/3).rounded(.down), height: (width/3).rounded(.down))
	}
}

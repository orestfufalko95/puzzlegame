//
//  LibraryTableViewController.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

	private var images = [UIImage]()

	var presenter: ViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()

		ScreenBuilder.initLibraryView(controller: self)

		self.presenter?.handleViewCreated()

		self.tableView.prefetchDataSource = self
	}

}

// MARK: -  View Input methods
extension LibraryTableViewController: ViewInput {
	func handleImagesUpdated(images: [UIImage]) {
		self.images = images
		self.tableView.reloadData()
	}
}

// MARK: - Table view data source prefetching
extension LibraryTableViewController: UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		print("prefetchRowsAt index: \(indexPaths.last?.row)")

		if let indexPath = indexPaths.last, indexPath.row + 1 > tableView.numberOfRows(inSection: indexPath.section) {
//			self.presenter?.fetchNewItems()
		}
	}
}

// MARK: - Table view data source
extension LibraryTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.images.count
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("start cellForRowAt timestamp: \(Date().timeIntervalSince1970) index: \(indexPath.row)")

		let cell = tableView.dequeueReusableCell(withIdentifier: GaleryPhotoCell.identifier, for: indexPath)
		if let newCell = cell as? GaleryPhotoCell {
			newCell.photo?.image = self.images[indexPath.row]
		}

		return cell
	}

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/
}

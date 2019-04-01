//
//  LibraryTableViewController.swift
//  Puzzle
//
//  Created by Orest Fufalko on 3/26/19.
//  Copyright © 2019 Orest Fufalko. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

	private var presenter: PhotoLibraryPresenter?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.presenter = PhotoLibraryPresenter(model: PhotoLibraryModel())
		self.tableView.prefetchDataSource = self
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.presenter?.attachView(view: self)
		tableView.rowHeight = UITableView.automaticDimension
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		self.presenter?.detachView()
	}
}

// MARK: - Library View methods
extension LibraryTableViewController: LibraryView {

	func showProgress(message: String) {

	}

	func hideProgress() {

	}
}

// MARK: - Table view data source prefetching
extension LibraryTableViewController: UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		print("prefetchRowsAt index: \(indexPaths.last?.row)")

		if let indexPath = indexPaths.last, indexPath.row + 1 > tableView.numberOfRows(inSection: indexPath.section) {
			self.presenter?.fetchNewItems()
		}
	}
}

// MARK: - Table view data source
extension LibraryTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.presenter?.itemsCount ?? 0
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: GaleryPhotoCell.identifier, for: indexPath)
//		print("start cellForRowAt timestamp: \(Date().timeIntervalSince1970) index: \(indexPath.row)")

		if let newCell = cell as? GaleryPhotoCell, let newImage = self.presenter?.item(for: indexPath.row) {
			newCell.photo?.image = newImage
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

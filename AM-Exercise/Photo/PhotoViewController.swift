//
//  ViewController.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import UIKit

extension PhotoViewController {
    enum Constants {
        static let interLineSpacing: CGFloat = 10
        static let interItemSpacing: CGFloat = 10
        static let sectionInset: CGFloat = 10
        static let cellHeight: CGFloat = 200/1.85
        static let photosPerPage = 16
        static let numberOfSections: CGFloat = 2
        static let sectionEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

final class PhotoViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInsetAdjustmentBehavior = .always
        return view
    }()
    
    private let networkClient = NetworkClient()

    private var photos = [Photo]()
    
    private var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Photos"
        view.backgroundColor = .darkGray
        view.addSubview(collectionView)
        setupCollectionView()
        fetchImages()
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
       ])
        collectionView.reloadData()
    }
    
    private func fetchImages() {
        networkClient.fetchImages(page: currentPage, perPage: Constants.photosPerPage) { [weak self] result in
            switch result {
            case .success(let downLoadedPhotos):
                self?.photos.append(contentsOf: downLoadedPhotos)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription, preferredStyle: .alert
                )
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func fetchMoreImages() {
        currentPage += 1
        fetchImages()
    }
    
    private func showPhotoDetails(_ photo: Photo) {
        let viewModels = prepareDetailViewModels(photo)
        let controller = PhotoDetailViewController()
        controller.configure(with: viewModels)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        present(controller, animated: true)
    }
    
    private func prepareDetailViewModels(_ photo: Photo) -> [PhotoDetailItemView.ViewModel] {
        let keyAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.lightGray
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor : UIColor.white
        ]
        
        let authorKey = NSAttributedString(string: "Author", attributes: keyAttributes)
        let authorValue = NSAttributedString(string: photo.user, attributes: valueAttributes)
        let downloadsKey = NSAttributedString(string: "Downloads", attributes: keyAttributes)
        let downloadsValue = NSAttributedString(string: "\(photo.downloads)", attributes: valueAttributes)
        let viewsKey = NSAttributedString(string: "Views", attributes: keyAttributes)
        let viewsValue = NSAttributedString(string: "\(photo.views)", attributes: valueAttributes)
        let likesKey = NSAttributedString(string: "Likes", attributes: keyAttributes)
        let likesValue = NSAttributedString(string: "\(photo.likes)", attributes: valueAttributes)
        let commentsKey = NSAttributedString(string: "Comments", attributes: keyAttributes)
        let commentsValue = NSAttributedString(string: "\(photo.comments)", attributes: valueAttributes)
        
        let authorViewModel = PhotoDetailItemView.ViewModel(name: authorKey, value: authorValue)
        let downloadsViewModel = PhotoDetailItemView.ViewModel(name: downloadsKey, value: downloadsValue)
        let viewsViewModel = PhotoDetailItemView.ViewModel(name: viewsKey, value: viewsValue)
        let likesViewModel = PhotoDetailItemView.ViewModel(name: likesKey, value: likesValue)
        let commentsViewModel = PhotoDetailItemView.ViewModel(name: commentsKey, value: commentsValue)
        
        return [authorViewModel, downloadsViewModel, viewsViewModel, likesViewModel, commentsViewModel]
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        showPhotoDetails(photo)
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let contentInset = (cell.frame.origin.y + cell.frame.size.height) - (collectionView.frame.height / 2)
        if contentInset > 0 {
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.id = photo.id
        cell.configure(photo: photo)
        
        if indexPath.row == photos.count - 1 {
            fetchMoreImages()
        }
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / Constants.numberOfSections - Constants.interItemSpacing * 3 / 2
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionEdgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.interItemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.interLineSpacing
    }
}

extension PhotoViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = InfoPresentationController(presentedViewController: presented, presenting: presenting)
        return controller
    }
}

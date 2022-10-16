//
//  ViewController.swift
//  AM-Exercise
//
//  Created by Michael Mavris on 20/07/2021.
//  Copyright © 2021 Michael Mavris. All rights reserved.
//

import UIKit

final class PhotoViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInsetAdjustmentBehavior = .always
        return view
    }()
    
    private let networkClient = NetworkClient()

    private var photos = [Photo]()
    
    private var currentPage = 1
    
    private var requestInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])
        collectionView.reloadData()
    }
    
    private func fetchImages() {
        requestInProgress = true
        networkClient.fetchImages(page: currentPage, perPage: 16) { [weak self] result in
            switch result {
                case .success(let downLoadedPhotos):
                    self?.photos.append(contentsOf: downLoadedPhotos)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.requestInProgress = false
                }
                case .failure(let error):
                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription, preferredStyle: .alert
                )
                self?.present(alert, animated: true)
                self?.requestInProgress = false
            }
        }
    }
    
    private func fetchMoreImages() {
        guard !requestInProgress else { return }
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
    
    private func prepareDetailViewModels(_ photo: Photo) -> [KeyValueView.ViewModel] {
        //author, downloads, count of views, count of likes and count of comments
        let keyAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.lightGray
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor : UIColor.white
        ]
        
        let authorKey = NSAttributedString(string: "Author", attributes: keyAttributes) //author
        let authorValue = NSAttributedString(string: photo.user, attributes: valueAttributes)
        
        let authorViewModel = KeyValueView.ViewModel(key: authorKey, value: authorValue)
        
        let downloadsKey = NSAttributedString(string: "Downloads", attributes: keyAttributes) //downloads
        let downloadsValue = NSAttributedString(string: "\(photo.downloads)", attributes: valueAttributes)
        
        let downloadsViewModel = KeyValueView.ViewModel(key: downloadsKey, value: downloadsValue)
        
        let viewsKey = NSAttributedString(string: "Views", attributes: keyAttributes) // count of views
        let viewsValue = NSAttributedString(string: "\(photo.views)", attributes: valueAttributes)
        
        let viewsViewModel = KeyValueView.ViewModel(key: viewsKey, value: viewsValue)
        
        let likesKey = NSAttributedString(string: "Likes", attributes: keyAttributes) // count of likes
        let likesValue = NSAttributedString(string: "\(photo.likes)", attributes: valueAttributes)
        
        let likesViewModel = KeyValueView.ViewModel(key: likesKey, value: likesValue)
        
        let commentsKey = NSAttributedString(string: "Comments", attributes: keyAttributes) // count of comments
        let commentsValue = NSAttributedString(string: "\(photo.comments)", attributes: valueAttributes)
        
        let commentsViewModel = KeyValueView.ViewModel(key: commentsKey, value: commentsValue)
        
        return [authorViewModel, downloadsViewModel, viewsViewModel, likesViewModel, commentsViewModel]
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        showPhotoDetails(photo)
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let contentInset = cell.frame.origin.y + cell.frame.size.height - collectionView.frame.height / 2
        
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
            print("FETCH MORE DATA")
        }
        
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 30 / 2, height: 200/1.85)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
}

extension PhotoViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = InfoPresentationController(presentedViewController: presented, presenting: presenting)
        
        return controller
    }
}

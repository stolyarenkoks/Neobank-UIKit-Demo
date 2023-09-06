//
//  AwardsViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - AwardsViewController

class AwardsViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Internal Properties

    var updatePageControl: ((Bool) -> Void)?
    weak var pageViewController: CardsPageViewController?

    // MARK: - Private Properties

    private var awards: [Award] = []

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updatePageControl(dependOn: collectionView.contentOffset)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        updatePageControl?(true)
    }

    // MARK: - Setup

    override func setupSettings() {
        collectionView.register(nibName: Const.AwardCollectionViewCell.cellNibName,
                                cellId: Const.AwardCollectionViewCell.cellId)
        collectionView.register(nibName: Const.AwardHeaderView.viewNibName,
                                viewId: Const.AwardHeaderView.viewId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupDataSource() {
        awards = MockDataManager.shared.generateAwardsDataSource()
        collectionView.reloadData()
    }

    // MARK: - Private Methods

    private func updatePageControl(dependOn contentOffset: CGPoint) {
        let isVisible = contentOffset.y < Const.AwardsViewController.pageControlVisibleOffset &&
        contentOffset.y > -Const.AwardsViewController.pageControlVisibleOffset
        updatePageControl?(isVisible)
    }
}

// MARK: - UICollectionViewDataSource Extension

extension AwardsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awards.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.AwardCollectionViewCell.cellId,
                                                      for: indexPath)
        guard let awardCell = cell as? AwardCollectionViewCell else { return UICollectionViewCell() }
        let award = awards[indexPath.row]
        awardCell.setupCell(with: award)
        return awardCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reuseIdentifier = Const.AwardHeaderView.viewId
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: reuseIdentifier,
                                                                             for: indexPath)
            guard let awardHeaderView = headerView as? AwardHeaderView else { return UICollectionReusableView() }
            let achivedAwardsCount = awards.filter({ $0.isAchived == true }).count
            let achivedAwardsTitle = String(format: Const.AwardHeaderView.achivedAwardsFormat,
                                            achivedAwardsCount,
                                            awards.count)
            awardHeaderView.updateTitle(achivedAwardsTitle)
            return awardHeaderView
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate Extension

extension AwardsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let award = awards[indexPath.row]
        debugPrint("Open AwardDetailViewController Award.title: \(award.title)!")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extension

extension AwardsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Const.AwardCollectionViewCell.cellSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Const.AwardsViewController.collectionViewEdgeInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.AwardsViewController.collectionViewMinimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let height = pageViewController?.cardsViewContainerHeight else { return .zero }
        return CGSize(width: collectionView.frame.width,
                      height: height + Const.CardsPageViewController.pageIndicatorHeight)
    }
}

// MARK: - UIScrollViewDelegate Extension

extension AwardsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl(dependOn: scrollView.contentOffset)
    }
}

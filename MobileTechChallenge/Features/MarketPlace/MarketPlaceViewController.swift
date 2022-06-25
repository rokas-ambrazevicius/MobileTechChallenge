import UIKit
import SwiftUI

final class MarketPlaceViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var filterTextField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let cellIdentifier = "MarketplaceCell"
    private let cellHeight: CGFloat = 64
    private let minimumLineSpacing: CGFloat = 5
    
    private var viewModel: MarketPlaceViewModelProviding
    private var noInternetViewController: UIHostingController<NoInternetView>?
    
    init?(coder: NSCoder, viewModel: MarketPlaceViewModelProviding) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup -
    
    private func setup() {
        setupObservers()
        setupCollectionView()
        setupFilterTextField()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .vertical
        carouselLayout.minimumLineSpacing = minimumLineSpacing
        collectionView.collectionViewLayout = carouselLayout
        
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupFilterTextField() {
        filterTextField.delegate = self
        
        let editingChanged = UIAction { [weak self] action in
            self?.viewModel.filter.value = self?.filterTextField.text ?? ""
        }
        filterTextField.addAction(editingChanged, for: .editingChanged)
        
        // Hide keyboard on tap outside filter inout
        let gesture = UITapGestureRecognizer(target: view, action: #selector(UITextView.endEditing(_:)))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    private func setupObservers() {
        viewModel.cellViewModels.subscribe(self, shouldInit: true) { [weak self] viewModels in
            DispatchQueue.main.async {
                !viewModels.isEmpty ? self?.activityIndicator.stopAnimating() : self?.activityIndicator.startAnimating()
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.isInternetAvailable.subscribe(self, shouldInit: true) { [weak self] isAvailable in
            DispatchQueue.main.async {
                !isAvailable ? self?.presentNoInternetView() : self?.noInternetViewController?.dismiss(animated: true)
            }
        }
    }
    
    private func presentNoInternetView() {
        DispatchQueue.main.async { [weak self] in
            let controller = UIHostingController(rootView: NoInternetView())
            controller.modalPresentationStyle = .fullScreen
            
            self?.navigationController?.present(controller, animated: true)
            self?.noInternetViewController = controller
        }
    }
}

extension MarketPlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: cellHeight)
    }
}

// MARK: - Datasource -

extension MarketPlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? MarketplaceCell
        else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = viewModel.cellViewModels.value[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }
}

// MARK: - UITextFieldDelegate -

extension MarketPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Instantiation -

extension MarketPlaceViewController {
    static func instantiate(viewModel: MarketPlaceViewModel) -> MarketPlaceViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let viewController = storyboard.instantiateInitialViewController { coder -> UIViewController? in
            return MarketPlaceViewController(
                coder: coder,
                viewModel: viewModel
            )
        }
        
        guard let viewController = viewController as? MarketPlaceViewController
        else {
            fatalError("Error")
        }
        
        return viewController
    }
}

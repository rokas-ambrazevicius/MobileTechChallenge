import UIKit

final class MarketplaceCell: UICollectionViewCell {
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dailyChangeLabel: UILabel!
    
    private let noImageName = "noImage"
    private let cornerRadius: CGFloat = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func configure(with viewModel: MarketplaceCellViewModelProviding) {
        logoImageView.image = viewModel.image ?? UIImage(named: noImageName)
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        dailyChangeLabel.text = viewModel.dailyChange
        dailyChangeLabel.textColor = viewModel.dailyChangeLabelColor()
    }
    
    // MARK: - Private -
    
    private func setup() {
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
        logoImageView.clipsToBounds = true
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

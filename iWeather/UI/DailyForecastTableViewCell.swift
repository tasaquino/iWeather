//
//  DailyForecastTableViewCell.swift
//  iWeather
//
//  Created by Thais Aquino on 11/11/2023.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    
    static var identifier = "DailyForecastTableViewCell"
    
    lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [weekDayLabel, iconImageView, minTempLabel, maxTempLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        view.spacing = 15
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var weekDayLabel: UILabel = {
        let view =  UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.contrastColor
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return view
    }()
    
    private lazy var minTempLabel: UILabel = {
        let view =  UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.contrastColor
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return view
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let view =  UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.contrastColor
        view.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(weekDay: String?, min: String?, max: String?, iconID: String?) {
        weekDayLabel.text = weekDay
        minTempLabel.text = "min \(min ?? "")"
        maxTempLabel.text = "max \(max ?? "")"
        iconImageView.image = UIImage(named: iconID ?? "")
    }
}

extension DailyForecastTableViewCell: SetupViewProtocol {
    func setupView() {
        backgroundColor = .clear
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        stackView.setConstaintsToParent(contentView)
        
        NSLayoutConstraint.activate([
            weekDayLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50)
        ])
    }
}

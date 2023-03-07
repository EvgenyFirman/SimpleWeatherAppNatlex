//
//  WeatherMainTableViewCell.swift
//  SimpleWeatherAppNatlex
//
//  Created by Евгений Фирман on 06.03.2023.
//

import UIKit


//MARK: - WeatherMainTableViewCell
class WeatherMainTableViewCell: UITableViewCell {
    
    //MARK: - UIElements
    var cityInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Petrozavodsk, 34F"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    var timeInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "14.01.2020 16:58:48"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    var listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.bullet.clipboard"), for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WeatherMainTableViewCell {
    
    func configureViews(){
        [cityInfoLabel,
         timeInfoLabel,
         listButton
        ].forEach { contentView.addSubview($0)}
    }
    
    func configureConstraints(){
        
        cityInfoLabel.snp.makeConstraints { cityInfoLabel in
            cityInfoLabel.left.equalTo(self.contentView.snp.left).offset(15)
            cityInfoLabel.top.equalTo(self.contentView.snp.top).offset(10)
        }
        
        timeInfoLabel.snp.makeConstraints { timeInfoLabel in
            timeInfoLabel.left.equalTo(self.contentView.snp.left).offset(15)
            timeInfoLabel.top.equalTo(self.cityInfoLabel.snp.bottom).offset(10)
            timeInfoLabel.bottom.equalTo(self.contentView.snp.bottom).inset(10)
        }
        
        listButton.snp.makeConstraints { listButton in
            listButton.right.equalTo(self.contentView.snp.right).inset(10)
            listButton.centerY.equalTo(self.contentView.snp.centerY)
            listButton.width.height.equalTo(25)
        }
    }
}

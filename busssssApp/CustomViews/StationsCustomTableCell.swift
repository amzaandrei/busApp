//
//  StationsCustomTableCell.swift
//  busssssApp
//
//  Created by Andrew on 2/11/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

class StationsCustomTableCell: UITableViewCell{
    
    let cellId = "cellId"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "asd"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: cellId)
        addSubview(label)
        addConstraints()
    }
    
    func addConstraints(){
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

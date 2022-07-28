//
//  DropDown.swift
//  ReuseableDropDown
//
//  Created by Gurjinder Singh on 28/07/22.
//

import UIKit

struct Data {
    let value: String
}

protocol DropDownDelegate {
    func didTapCell(value: String)
}

class DropDown: UIButton, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var isOpen: Bool = false
    private var point: CGRect?
    private let button = UIButton()
    private let width: CGFloat = 180.0
    private let padding = 3

    var delegate:DropDownDelegate?
    
    var itemArray: [Data] = [
        Data.init(value: "Chandigarh"),
        Data.init(value: "Mohali"),
        Data.init(value: "Manali"),
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.className)
        tableView.layer.cornerRadius = 5
    }
    
    @objc func didTap() {
        if isOpen {
            removeTransparentView()
        } else {
            addTransparentView()
        }
        isOpen = !isOpen
    }
    
    func backButton() {
        if  let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            let frame = UIScreen.main.bounds
            button.frame = frame
            button.backgroundColor = .black
            button.alpha = 0.2
            window.addSubview(button)
            button.addTarget(self, action: #selector(removeTransparentView), for: .touchDown)
        }
    }
    @objc func addTransparentView() {
        backButton()
        point = convert(self.bounds, to: window)
        tableView.frame = self.frame//point!
        tableView.layer.borderColor = UIColor.darkGray.cgColor
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 2
        tableView.reloadData()
        let height: CGFloat = CGFloat(itemArray.count * 44) - 10
        window?.addSubview(tableView)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.tableView.frame = CGRect(x: ((self.window?.frame.size.width ?? 0.0) - self.width) / 2,
                                          y: (self.point!.origin.y) - height - CGFloat(self.padding),
                                          width: self.width,
                                          height: height)
            
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        isOpen = false
        button.removeFromSuperview()
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            //self.tableView.frame = self.point!
            self.tableView.removeFromSuperview()
        }, completion: { _ in
            //self.tableView.removeFromSuperview()
        } )
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.className, for: indexPath) as! DropDownCell
        cell.itemName.text = itemArray[indexPath.row].value
        cell.itemName.textColor = .black
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        removeTransparentView()
        isOpen = false
        delegate?.didTapCell(value: item.value)
    }
}

fileprivate class DropDownCell: UITableViewCell {
    let itemName = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        itemName.numberOfLines = 0
        itemName.translatesAutoresizingMaskIntoConstraints = false
        itemName.font = UIFont(name: "MuseoSans-700", size: 12)
        itemName.textAlignment = .center
        itemName.backgroundColor = .white
        contentView.addSubview(itemName)
        NSLayoutConstraint.activate([
            itemName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            itemName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 2),
            itemName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension NSObject {
    var className: String {
        return type(of: self).className
    }
    
    static var className: String {
        return stringFromClass(aClass: self)
    }
}
fileprivate func stringFromClass(aClass: AnyClass) -> String {
    return NSStringFromClass(aClass).components(separatedBy: ".").last!
}

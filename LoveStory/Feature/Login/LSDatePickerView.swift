//
//  LSDatePickerView.swift
//  LoveStory
//
//  Created by songlong on 2017/1/20.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import SnapKit

private let pickerHeight = 260

class LSDatePickerView: UIView {
    
    var cancelButton: UIButton!
    var commitButton: UIButton!
    var datePicker: UIDatePicker!
    private var finish: ((String?, String?, String?) -> Void)? = nil
    private var tempView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        let maskView = UIView(frame: frame)
        maskView.backgroundColor = .lightGray
        maskView.alpha = 0.9
        self.addSubview(maskView)
        
        tempView = UIView(frame: CGRect(x: 0, y: LSHeight, width: LSWidth, height: 260))
        tempView.backgroundColor = .white
        self.addSubview(tempView)
        
        let topView = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
        topView.adjustsImageWhenHighlighted = false
        topView.backgroundColor = .white
        tempView.addSubview(topView)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 43, width: frame.size.width, height: 1))
        lineView.backgroundColor = .lightGray
        lineView.alpha = 0.5
        topView.addSubview(lineView)
        
        cancelButton = UIButton()
        
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        cancelButton.setTitleColor(LSMainColor, for: .normal)
        topView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.left.equalTo(20)
        }
        
        commitButton = UIButton()
        commitButton.addTarget(self, action: #selector(clickCommit), for: .touchUpInside)
        commitButton.setTitle("确定", for: .normal)
        commitButton.setTitleColor(LSMainColor, for: .normal)
        topView.addSubview(commitButton)
        commitButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView)
            make.right.equalTo(-20)
        }
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 44, width: frame.size.width, height: 216))
        datePicker.datePickerMode = .date
        tempView.addSubview(datePicker)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    func clickCancel() {
        dismiss()
    }
    
    func clickCommit() {
        dismiss()
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        finish!(year, month, day)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func showInView(view: UIView, completion: ((String?, String?, String?) -> Void)?) {
        let picker = LSDatePickerView(frame: UIScreen.main.bounds)
        picker.finish = completion
        view.addSubview(picker)
        
        picker.isUserInteractionEnabled = false
        UIView.animate(withDuration:0.4, animations: {
            (void) in
            picker.tempView.frame = CGRect(x: 0, y: LSHeight / 2 - 130, width: LSWidth, height: 260)
        }, completion: { (finished) in
            picker.isUserInteractionEnabled = true
        })

    }
    
    private func dismiss() {
        isUserInteractionEnabled = false
        UIView.animate(withDuration:0.4, animations: {
            (void) in
            self.tempView.frame = CGRect(x: 0, y: LSHeight, width: LSWidth, height: 260)
        }, completion: { (finished) in
            self.isUserInteractionEnabled = true
            self.removeFromSuperview()
        })
    }
}

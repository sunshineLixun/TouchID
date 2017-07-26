//
//  ViewController.swift
//  Touch-ID Demo
//
//  Created by lixun on 2017/7/26.
//  Copyright © 2017年 sunshine. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
	

	//MARK: liftCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		displayTouchID()
	}
	
	
	//MARK: displayTouchIDAleart
	func displayTouchID(){
		let myContent = LAContext()
		let myLocalizedReasonString: String = "通过Home键验证已有手机指纹"
		var authError: NSError? = nil
		
		myContent.localizedFallbackTitle = "请输入指纹"
		myContent.localizedCancelTitle = "取消"
		
		if #available(iOS 8.0, *) {
			if myContent.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authError) {
				myContent.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString, reply: {   [unowned self] (success, evaluateError) in
					if (success){
						DispatchQueue.main.async {
							self.showAlertWith(title: "温馨提示", message: "验证成功")
						}
		
					}else{
						DispatchQueue.main.async {
							self.displayErrorMessage(error: evaluateError as! LAError)
						}
					}
				})
			}else{
				self.showAlertWith(title: "温馨提示", message: (authError?.localizedDescription)!)
			}
		}else{
			print("设备不支持TouchID")
		}
		
	}
	
	
	//MARK: ButtonAction
	@IBAction func TouchIDAction(_ sender: UIButton) {
		displayTouchID()
	}
	
	
	//MARK: setting error message
	func displayErrorMessage(error: LAError){
		var message: String = ""
		switch error.code {
		case .authenticationFailed:
			message = "验证失败"
		case .userCancel:
			message = "用户点击了取消按钮"
		case .userFallback:
			message = "用户点击了输入指纹"
		case .systemCancel:
			message = "系统终止了验证"
		case .passcodeNotSet:
			message = "未设置密码"
		case .touchIDNotAvailable:
			message = "TouchID在该设备不可用"
		case .touchIDNotEnrolled:
			message = "没有注册指纹"
		default:
			message = error.localizedDescription
		}
		
		self.showAlertWith(title: "温馨提示", message: message)
	}

}



extension UIViewController {
	func showAlertWith(title:String?, message:String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let actionButton = UIAlertAction(title: "确定", style: .default, handler: nil)
		alertController.addAction(actionButton)
		self.present(alertController, animated: true, completion: nil)
	}
}


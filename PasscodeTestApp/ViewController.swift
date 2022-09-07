//
//  ViewController.swift
//  PasscodeTestApp
//
//  Created by 住田雅隆 on 2022/09/07.
//

import Foundation
import UIKit
import LocalAuthentication

class LockViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func testPressed(_ sender: Any) {

        let context = LAContext()
        let reason = "This app uses Touch ID / Facd ID to secure your data."
        var authError: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                if success {
                    self.setMessage("Authenticated")
                    self.toSecondView()
                } else {
                    let message = error?.localizedDescription ?? "Failed to authenticate"
                    self.setMessage(message)
                }
            }
        } else {
            let message = authError?.localizedDescription ?? "canEvaluatePolicy returned false"
            setMessage(message)
        }
    }
    // クロージャばバックグラウンドスレッドで呼ばれているので、UI コンポーメントの更新ができません。このため、 ここでは setMessage という関数を作り、そこでメインスレッドに処理をディスパッチして、 ラベルを更新しています。
    func setMessage(_ message: String) {
        DispatchQueue.main.async { [unowned self] in
            self.resultLabel.text = message
        }
    }
    func toSecondView() {
        DispatchQueue.main.async { [unowned self] in
            let storyboard = UIStoryboard(name: "SecondViewController", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "secondView")as! SecondViewController
            secondVC.modalPresentationStyle = .automatic
            self.present(secondVC, animated: true, completion: nil)
        }
    }

}


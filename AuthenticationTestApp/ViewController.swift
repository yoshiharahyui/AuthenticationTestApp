//
//  ViewController.swift
//  AuthenticationTestApp
//
//  Created by 吉原飛偉 on 2024/07/16.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var currentUserEmailLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    let firststoryboard = UIStoryboard(name: "FirstView", bundle: nil)
    
    //現在ログインしているユーザーを取得するには、Auth オブジェクトでリスナーを設定することをおすすめします
    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 22
        signInButton.layer.cornerRadius = 22
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //viewWillAppearでアタッチしたこのリスナーは、ユーザーのログイン状態が変更される度に呼び出されます
        authHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let currentUser = user {
                //もし、ユーザーが匿名で利用していたら
                if currentUser.isAnonymous {
                    self.currentUserEmailLabel.text = "匿名で利用中"
                } else {
                    self.currentUserEmailLabel.text = currentUser.email
                }
            } else {
                //ログインをしていない場合
                self.currentUserEmailLabel.text = "現在ログイン中のユーザーはいません"
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        //リスナーを切り離します
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }
    
    //サインアウト
    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("サインアウトに失敗しました:", signOutError)
        }
    }
    
    //サインアップ
    @IBAction func didTapSignUp(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                //debugPrint(error as Any)
                guard let user = authResult?.user, error == nil else {
                    print("登録に失敗しました:" ,error!.localizedDescription)
                    return
                }
                print("登録に成功しました", user.email!)
                let FirstVC = self.firststoryboard.instantiateViewController(withIdentifier: "First") as! FirstViewController
                FirstVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                FirstVC.modalPresentationStyle = .fullScreen
                self.present(FirstVC, animated: true, completion: nil)
            }
        }
    }
    
    //サインイン
    @IBAction func didTapSignIn(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard let user = authResult?.user, error == nil else {
                    print("サインインに失敗しました:" ,error!.localizedDescription)
                    return
                }
                print("サインインに成功しました", user.email!)
                let FirstVC = self.firststoryboard.instantiateViewController(withIdentifier: "First") as! FirstViewController
                FirstVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                FirstVC.modalPresentationStyle = .fullScreen
                self.present(FirstVC, animated: true, completion: nil)
            }
        }
    }
    
    //匿名サインイン
    @IBAction func didTapSignInAnonymously(_ sender: UIButton) {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                print("匿名サインインに失敗しました:" ,error!.localizedDescription)
                return
            }
            print("匿名サインインに成功しました", user.uid)
            let FirstVC = self.firststoryboard.instantiateViewController(withIdentifier: "First") as! FirstViewController
            FirstVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            FirstVC.modalPresentationStyle = .fullScreen
            self.present(FirstVC, animated: true, completion: nil)
        }
    }
}

    // MARK: - TextField Delegate Methods

    extension ViewController: UITextFieldDelegate {

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }



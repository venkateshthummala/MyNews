//
//  LoginViewController.swift
//  MyNews
//
//  Created by ashish jain on 04/09/23.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var sendOtpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func onTapSendOtpButton(_ sender: Any) {
        
        guard let phoneNumber = mobileNumberTextField.text else { return }

               PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                   if let error = error {
                       print("Error sending verification code: \(error.localizedDescription)")
                       return
                   }

                   UserDefaults.standard.set(verificationID, forKey: "authVerificationID")

                   let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
                   let verificationCodeViewController = storyboard.instantiateViewController(withIdentifier: "VerificationCodeViewController") as! VerificationCodeViewController
                   self.navigationController?.pushViewController(verificationCodeViewController, animated: true)
               }
           }
        
        
    
    
}

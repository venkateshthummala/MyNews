//
//  LoginViewController.swift
//  MyNews
//
//  Created by ashish jain on 04/09/23.
//

import UIKit
import Firebase
import AuthenticationServices
import GoogleSignIn

class LoginViewController: UIViewController,ASAuthorizationControllerPresentationContextProviding{

    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var sendOtpButton: UIButton!
    let googleSignInButton = GIDSignInButton()
    
    @IBOutlet weak var orLabel: UILabel!
    
    private let AppleButton = ASAuthorizationAppleIDButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the Sign-In with Apple button
                
                
        // Do any additional setup after loading the view.
        // Initialize Google Sign-In
        AppleButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        view.addSubview(AppleButton)
                
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the button's frame and position it on the screen
        AppleButton.frame = CGRect(x: 0, y: 0, width: 250, height: 40)

        AppleButton.center =  view.center
        
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
        
      
    
    
    @objc func handleAppleSignIn() {
           let appleIDProvider = ASAuthorizationAppleIDProvider()
           let request = appleIDProvider.createRequest()
           request.requestedScopes = [.fullName, .email]

           let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
           authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
       }
    
}
extension LoginViewController:ASAuthorizationControllerDelegate{
    
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = credential.user
                let fullName = credential.fullName
                let email = credential.email

                print(userIdentifier)
                print(fullName)
                print(email)

                // Use this user information as needed.

                // Perform the segue to navigate to the home screen
               // performSegue(withIdentifier: "HomeSegue", sender: self)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewsHeadLinesViewController")as!NewsHeadLinesViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
           // Handle any errors that occur during the authorization process.
           print("Apple Sign-In Error: \(error.localizedDescription)")
       }
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Return the window or view where you want to present the authorization controller.
        return self.view.window!
    }
}

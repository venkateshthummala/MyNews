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
import GoogleUtilities
import FirebaseCore

class LoginViewController: UIViewController,ASAuthorizationControllerPresentationContextProviding{

    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var orLabel: UILabel!
    
    private let AppleButton = ASAuthorizationAppleIDButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //GIDSignIn.sharedInstance.delegate = self
        
       // GIDSignIn.sharedInstance.presentingViewController = self
    
               
        AppleButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        view.addSubview(AppleButton)
        
        self.sendOtpButton.layer.cornerRadius = 5
        self.sendOtpButton.clipsToBounds = true
                
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the button's frame and position it on the screen
//        AppleButton.frame = CGRect(x: 0, y: 0, width: 250, height: 40)
//
//        AppleButton.center =  view.center
        
        
        AppleButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            AppleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Position the AppleButton 20 points below the sign in button
            AppleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            
                
                // Set the top of the AppleButton equal to the bottom of 'aboveView'
            AppleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor),
                
            AppleButton.widthAnchor.constraint(equalTo: signInButton.widthAnchor),
                
            AppleButton.heightAnchor.constraint(equalTo: signInButton.heightAnchor)
        ])

        
    }

    @IBAction func onTapGoogleSignInButton(_ sender: Any) {
        
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            
            Auth.auth().signIn(with: credential) { result, error in
                
                // At this point, our user is signed in
                        
                        if let error = error {
                            // Handle login error
                            print("Error signing in with Firebase: \(error.localizedDescription)")
                        } else {
                            // Login successful, navigate to the home screen
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let homeViewController = storyboard.instantiateViewController(withIdentifier: "NewsHeadLinesViewController") as? NewsHeadLinesViewController {
                                self.navigationController?.pushViewController(homeViewController, animated: true)
                            }
                        }
            }
        }
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



import UIKit
import PushNotifications

class ViewController: UIViewController {
    
    let beamsClient = PushNotifications.shared
    
    // hardcoding the username and password both here and on the server
    let userId = "Mary"
    let password = "mypassword"
    
    // TODO: As long as your iOS device and development machine are on the same wifi
    // network, change the following IP to the wifi router IP address where your
    // Dart server will be running.
    let serverIP = "192.168.1.3"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the token from the server
        let serverUrl = "http://\(serverIP):8888/token"
        let tokenProvider = BeamsTokenProvider(authURL: serverUrl) { () -> AuthData in
            let headers = ["Authorization": self.authHeaderValueForMary()]
            let queryParams: [String: String] = [:]
            return AuthData(headers: headers, queryParams: queryParams)
        }
        
        // send the token to Pusher
        self.beamsClient.setUserId(userId,
                                   tokenProvider: tokenProvider,
                                   completion:{ error in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            print("Successfully authenticated with Pusher Beams")
        })
    }
    
    func authHeaderValueForMary() -> String {
        guard let data = "\(userId):\(password)".data(using: String.Encoding.utf8)
            else { return "" }
        let base64 = data.base64EncodedString()
        return "Basic \(base64)"
    }
}


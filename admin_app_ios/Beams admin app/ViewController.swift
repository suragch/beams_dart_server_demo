import UIKit

class ViewController: UIViewController {
    
    // hardcoding the username and password both here and on the Dart server
    let username = "admin"
    let password = "password123"
    
    // using localhost is ok since this app will be running on the simulator
    let host = "http://localhost:8888"

    // tell server to send a notification to device interests
    @IBAction func onInterestsButtonTapped(_ sender: UIButton) {
        
        // set up request
        guard let url  = URL(string: "\(host)/admin/interests") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authHeaderValue(), forHTTPHeaderField: "Authorization")
        
        // send request
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode
                else {return}
            guard let body = data
                else {return}
            guard let responseString = String(data: body, encoding: .utf8)
                else {return}
            
            print("POST result: \(statusCode) \(responseString)")
        }
        task.resume()
    }
    
    // Returns the Auth header value for Basic authentication with the username
    // and password encoded with Base64. In a real app these values would be obtained
    // from user input.
    func authHeaderValue() -> String {
        guard let data = "\(username):\(password)".data(using: .utf8) else {
            return ""
        }
        let base64 = data.base64EncodedString()
        return "Basic \(base64)" // "Basic YWRtaW46cGFzc3dvcmQxMjM="
    }
    
    // tell server to send notification to authenticated user
    @IBAction func onUserButtonTapped(_ sender: UIButton) {
        
        // set up request
        guard let url  = URL(string: "\(host)/admin/users") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authHeaderValue(), forHTTPHeaderField: "Authorization")
        
        // send request
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode
                else {return}
            guard let body = data
                else {return}
            guard let responseString = String(data: body, encoding: .utf8)
                else {return}
            
            print("POST result: \(statusCode) \(responseString)")
        }
        task.resume()
    }
}


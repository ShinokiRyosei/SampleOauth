//
//  OAuthSwift.swift
//  SampleOauth
//
//  Created by ShinokiRyosei on 2016/04/18.
//  Copyright © 2016年 ShinokiRyosei. All rights reserved.
//

import Foundation

class OAuthSwift {
    var dataEncoding: NSStringEncoding = NSUTF8StringEncoding
    var data: NSMutableData? = nil
    
    var consumerKey: String
    var consumerSecret: String
    var requestTokenUrl: String
    var authorizeUrl: String
    var accessTokenUrl: String
    
    init?(consumerKey: String, consumerSecret: String, requestTokenUrl: String, authorizeUrl: String, accessTokenUrl: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.requestTokenUrl = requestTokenUrl
        self.authorizeUrl = authorizeUrl
        self.accessTokenUrl = accessTokenUrl
        
    }
    
    func start() -> Void {
        // 流れとして request_token投げる -> ouath_token取得(今ここ) -> authrize_request投げる -> access_token取得 -> API使用
        let twitterURL = NSURL(string: "https://api.twitter.com/oauth/request_token")!
        
        let request = NSMutableURLRequest(URL: twitterURL)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        var param = Dictionary<String, String>()
        param["oauth_version"] = "1.0"
        param["oauth_signature_method"] = "HMAC-SHA1"
        param["oauth_consumer_key"] = self.consumerKey
        param["oauth_timestamp"] = String(Int64(NSDate().timeIntervalSince1970))
        param["oauth_nonce"] = (NSUUID().UUIDString as NSString).substringToIndex(6)
        param["oauth_callback"] = "oauth-swift://"
        param["oauth_signature"] = self.oauthSignatureForMethod("POST", url: twitterURL, parameters: param)
        
        var authrizationParameterComponents = urlEncodedQueryStringWithEncoding(param).componentsSeparatedByString("&") as [String]
        authrizationParameterComponents.sort {$0 < $1}
        var headerComponents = [String]()
        for component in authrizationParameterComponents {
            let subComponent = component.componentsSeparatedByString("=") as [String]
            if subComponent.count == 2 {
                headerComponents.append("\(subComponent[0])=\"\(subComponent[1])")
            }
        }
        
        request.setValue(headerComponents.joinWithSeparator("OAuth " + ", "), forHTTPHeaderField: "Authorization")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }
            print(NSString(data: data!, encoding: self.dataEncoding))
        }
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse) {
        self.data! = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        let html = NSString(data: self.data!, encoding: NSUTF8StringEncoding)!
        print(html)
        
    }
    
    func oauthSignatureForMethod(method: String, url: NSURL, parameters: Dictionary<String, String>) -> String {
        let signingKey = "\(self.consumerSecret)"
        let signingKeyData = signingKey.dataUsingEncoding(dataEncoding)
        
        var parameterComponents = urlEncodedQueryStringWithEncoding(parameters).componentsSeparatedByString("&") as [String]
        parameters.sort { $0 < $1}
        
        let parametersString = parameterComponents.joinWithSeparator("&")
        let encodedParameterString
        
    }
    
    func urlEncodedQueryStringWithEncoding(params: Dictionary<String, String>) -> String {
        <#function body#>
    }
    
}
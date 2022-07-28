//
//  TrickViewModel.swift
//  Tricks
//
//  Created by Armin on 3/19/22.
//

import SwiftUI

class TrickViewModel: ObservableObject {
    
    @Published var trick: Trick
    @Published var liked: Bool = false
    @Published var willDelete: Bool = false
    
    @Published var profile: MyProfileViewModel? = nil
    @AppStorage("userID") private var storageUserID = ""
    
    private var service = TricksService()
    
    init(trick: Trick) {
        self.trick = trick
        self.liked = trick.rate_state == 1
    }
    
    var isMine: Bool {
        return trick.owner.id == Int(storageUserID)
    }
    
    var trickQuoteBody: String {
        let body = (trick.quote != nil ? trick.quote?.quote ?? "" : trick.body) ?? ""
        return body
    }
    
    var trickBody: String {
        return trick.body ?? ""
    }
    
    var trickBodyAlignment: Alignment {
        if isRTL(text: trickBody) {
            return .trailing
        } else {
            return .leading
        }
    }
    
    var trickQuoteBodyAlignment: Alignment {
        if isRTL(text: trickQuoteBody) {
            return .trailing
        } else {
            return .leading
        }
    }
    
    var trickBodyTextAlignment: TextAlignment {
        if isRTL(text: trickBody) {
            return .trailing
        } else {
            return .leading
        }
    }
    
    var trickQuoteBodyTextAlignment: TextAlignment {
        if isRTL(text: trickQuoteBody) {
            return .trailing
        } else {
            return .leading
        }
    }
    
    func isRTL(text: String) -> Bool {
        let lang = CFStringTokenizerCopyBestStringLanguage(text as CFString, CFRange(location: 0, length: text.count))

        if let lang = lang {
            let direction = NSLocale.characterDirection(forLanguage: lang as String)

            if direction == .rightToLeft {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func copyCode() {
        if let code = trick.code {
            #if os(iOS)
            let pasteboard = UIPasteboard.general
            pasteboard.string = code
            HapticGenerator.shared.success()
            #elseif os(macOS)
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(code, forType: .string)
            #endif
        }
    }
    
    func shareBody() -> [Any] {
        #if os(iOS)
        return [
            trick.body ?? "",
            trick.code ?? "",
            "By \(trick.owner.fullname)",
            URL(string: trick.share_link ?? trick.previewAddress)!
        ]
        #else
        return [trick.share_link ?? trick.previewAddress]
        #endif
    }
    
    func addLike() async {
        DispatchQueue.main.async {
            self.liked = !self.liked
            self.trick.rates += self.liked ? 1 : -1
        }
        
        guard let profile = profile else {
            DispatchQueue.main.async {
                self.liked = !self.liked
                self.trick.rates -= 1
            }
            #if DEBUG
            print("Warning: No profile found!")
            #endif
            return
        }

        do {
            let result = try await service.addRate(tagID: trick.id, rate: liked ? 1 : 0, token: profile.userToken)
            
            if let trick = result.result.first {
                DispatchQueue.main.async {
                    self.trick = trick
                    self.liked = trick.rate_state == 1
                }
            } else {
                liked = !liked
                trick.rates -= 1
                print("Failed to sent the rate, try again")
            }
        } catch {
            DispatchQueue.main.async {
                self.liked = !(self.liked)
                self.trick.rates -= 1
            }
            switch error as? RequestError {
            case .decode:
                print("Failed to execute, try later")
            case .invalidURL:
                print("Invalid URL")
            case .noResponse:
                print("Network error, Try again")
            case .unauthorized(_):
                print("Unauthorized access")
            case .unexpectedStatusCode(let status):
                print("Unexpected Status Code \(status) occured")
            default:
                print("Network error, Try again")
            }
        }
    }
    
    func deleteTrick() async {
        guard let profile = profile else {
            print("Failed to authorize")
            return
        }
        
        do {
            let result = try await service.deleteTrickPost(trickID: trick.id, token: profile.userToken)
            if result.result {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.UpdateList, object: nil)
                }
            } else {
                print("Failed to delete the trick, try again")
            }
        } catch {
            switch error as? RequestError {
            case .decode:
                print("Failed to execute, try later")
            case .invalidURL:
                print("Invalid URL")
            case .noResponse:
                print("Network error, Try again")
            case .unauthorized(_):
                print("Unauthorized access")
            case .unexpectedStatusCode(let status):
                print("Unexpected Status Code \(status) occured")
            default:
                print("Network error, Try again")
            }
        }
    }
}

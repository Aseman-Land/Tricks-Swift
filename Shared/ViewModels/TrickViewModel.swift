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
            URL(string: (trick.share_link ?? trick.previewURL?.absoluteString) ?? "https://tricks.aseman.io")!
        ]
        #else
        return [trick.share_link ?? trick.previewURL as Any]
        #endif
    }
    
    func toggleLike() async {
        let currentLikeState = liked
        let currentRateCount = trick.rates
        
        /// Updating like toggle
        DispatchQueue.main.async {
            self.liked = !self.liked
            self.trick.rates += self.liked ? 1 : -1
        }
        
        guard let profile = profile else {
            /// Resetting the like toggle
            DispatchQueue.main.async {
                self.liked = currentLikeState
                self.trick.rates = currentRateCount
            }
            #if DEBUG
            print("⚠️ Warning: No profile found!")
            #endif
            return
        }

        do {
            #if DEBUG
            print("\n\n\n")
            print("🗳️ Preparing to rate")
            print("🤔 Trick was liked? : \(currentLikeState)")
            print("🆔 Trick id: \(trick.id)")
            #endif
            let result = try await service.addRate(
                tagID: trick.id,
                rate: currentLikeState ? 0 : 1,
                token: profile.userToken
            )
            
            if let updatedTrick = result.result.first {
                #if DEBUG
                print("\n")
                print("🗳️ Trick gonna update")
                print("🔢 Trick rates: \(updatedTrick.rates)")
                print("🤔 Trick is liked? : \(updatedTrick.rate_state == 1)")
                #endif
                /// Updating current rate state of trick
                DispatchQueue.main.async {
                    self.trick = updatedTrick
                    self.liked = updatedTrick.rate_state == 1
                }
            } else {
                #if DEBUG
                print("⚠️ Failed to sent the rate, try again")
                #endif
                /// Resetting the like toggle
                DispatchQueue.main.async {
                    self.liked = currentLikeState
                    self.trick.rates = currentRateCount
                }
            }
        } catch {
            /// Resetting the like toggle
            DispatchQueue.main.async {
                self.liked = currentLikeState
                self.trick.rates = currentRateCount
            }
            #if DEBUG
            switch error as? RequestError {
            case .decode:
                print("⚠️ Failed to execute, try later")
            case .invalidURL:
                print("⚠️ Invalid URL")
            case .noResponse:
                print("⚠️ Network error, Try again")
            case .unauthorized(_):
                print("⚠️ Unauthorized access")
            case .unexpectedStatusCode(let status):
                print("⚠️ Unexpected Status Code \(status) occured")
            default:
                print("⚠️ Network error, Try again")
            }
            #endif
        }
    }
    
    func deleteTrick() async {
        guard let profile = profile else {
            #if DEBUG
            print("⚠️ Failed to authorize")
            #endif
            return
        }
        
        do {
            let result = try await service.deleteTrickPost(trickID: trick.id, token: profile.userToken)
            if result.result {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.UpdateList, object: nil)
                }
            } else {
                #if DEBUG
                print("⚠️ Failed to delete the trick, try again")
                #endif
            }
        } catch {
            #if DEBUG
            switch error as? RequestError {
            case .decode:
                print("⚠️ Failed to execute, try later")
            case .invalidURL:
                print("⚠️ Invalid URL")
            case .noResponse:
                print("⚠️ Network error, Try again")
            case .unauthorized(_):
                print("⚠️ Unauthorized access")
            case .unexpectedStatusCode(let status):
                print("⚠️ Unexpected Status Code \(status) occured")
            default:
                print("⚠️ Network error, Try again")
            }
            #endif
        }
    }
}

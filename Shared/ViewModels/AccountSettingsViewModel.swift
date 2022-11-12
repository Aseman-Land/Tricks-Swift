//
//  AccountSettingsViewModel.swift
//  Tricks
//
//  Created by Armin on 5/3/22.
//

import SwiftUI

#if os(macOS)
import Quartz
#endif

class AccountSettingsViewModel: ObservableObject {
    
    @AppStorage("fullname") private var storageFullname = ""
    @AppStorage("username") private var storageUsername = ""
    @AppStorage("avatarAddress") private var storageAvatarAddress = ""
    @AppStorage("about") private var storageAbout = ""
    
    @Published var fullname: String = ""
    @Published var username: String = ""
    
    @Published var currentPass: String = ""
    @Published var newPass: String = ""
    @Published var repeatNewPass: String = ""
    
    @Published var bio: String = ""
    
    @Published var profile: MyProfileViewModel? = nil
    
    @Published var editAvatarloading: Bool = false
    @Published var editProfileloading: Bool = false
    @Published var showErrorMessage: Bool = false
    @Published var errorMessage: String = ""
    
    private var service = UsersService()
    
    #if os(macOS)
    func showImagePicker() async {
        let imageChooser: IKPictureTaker = await IKPictureTaker.pictureTaker()
        await imageChooser.runModal()
        
        let nsImage = await imageChooser.outputImage()
        /// We need to save image as NSImage(`inputImage`) in ram in order to convert and upload it
        if let nsImage = nsImage, let imageData = nsImage.jpeg {
            await updateAvatar(imageData: imageData)
        }
    }
    #endif
    
    func updateAvatar(imageData: Data) async {
        /*
        editAvatarloading = true
        
        guard let profile = profile else {
            self.setErrorMessage("Failed to authorize")
            return
        }
        
        Task(priority: .background) {
            let result = try await service.updateAvatar(avatar: imageData, token: profile.userToken)
            
            switch result {
            case .success(let userResult):
                if userResult.status {
                    DispatchQueue.main.async {
                        self.updateProfile(user: userResult)
                    }
                } else {
                    setErrorMessage("Failed to update avatar, try again")
                }
                DispatchQueue.main.async {
                    self.editAvatarloading = false
                }
            case .failure(let error):
                switch error {
                case .decode:
                    setErrorMessage("Failed to execute, try later")
                case .invalidURL:
                    setErrorMessage("Invalid URL")
                case .noResponse:
                    setErrorMessage("Network error, Try again")
                case .unauthorized(let data):
                    setErrorMessage(try await decodeErrorMessage(data))
                case .unexpectedStatusCode(let status):
                    setErrorMessage("Unexpected Status Code \(status) occured")
                case .unknown(_):
                    setErrorMessage("Network error, Try again")
                }
            }
        }
         */
    }
    
    func fillFields() {
        fullname = storageFullname
        username = storageUsername
        bio = storageAbout
    }
    
    func editProfile() async {
        editProfileloading = true
        errorMessage = ""
        
        guard let profile = profile else {
            self.setErrorMessage("Failed to authorize")
            return
        }
        
        if currentPass != "" || newPass != "" || repeatNewPass != "" {
            if currentPass == "" || newPass == "" || repeatNewPass == ""{
                self.setErrorMessage("Fill all the blank fields")
                return
            } else if newPass != repeatNewPass {
                self.setErrorMessage("There is a mismatch in your new password, check it again!")
                return
            }
        }
        
        do {
            let result = try await service.editMe(
                username: username,
                fullname: fullname,
                password: newPass,
                current_password: currentPass,
                token: profile.userToken
            )
            
            if result.status {
                DispatchQueue.main.async {
                    self.updateProfile(user: result)
                }
            } else {
                setErrorMessage("Failed to update profile, try again")
            }
            DispatchQueue.main.async {
                self.editProfileloading = false
            }
        } catch {
            switch error as? RequestError {
            case .decode:
                setErrorMessage("Failed to execute, try later")
            case .invalidURL:
                setErrorMessage("Invalid URL")
            case .noResponse:
                setErrorMessage("Network error, Try again")
            case .unauthorized(let data):
                setErrorMessage(await decodeErrorMessage(data))
            case .unexpectedStatusCode(let status):
                setErrorMessage("Unexpected Status Code \(status) occured")
            default:
                setErrorMessage("Network error, Try again")
            }
        }
    }
    
    func decodeErrorMessage(_ data: Data) async -> String {
        do {
            let message = try JSONDecoder().decode(ResponseFail.self, from: data).message
            return message ?? "Try again"
        } catch {
            return "Failed to execute, Try again"
        }
    }
    
    func setErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.editAvatarloading = false
            self.editProfileloading = false
            self.errorMessage = message
            self.showErrorMessage = true
        }
    }
    
    func updateProfile(user: User) {
        self.storageUsername = user.result.username
        self.storageFullname = user.result.fullname
        self.storageAbout = user.result.about ?? ""
        
        if let avatar = user.result.avatarAddress {
            self.storageAvatarAddress = avatar.absoluteString
        }
    }
}

//
//  ProfileStorage.swift
//  AppFollow
//
//  Created by Alexandr Gavrishev on 29/03/2018.
//  Copyright © 2018 Anodsplace. All rights reserved.
//

import Foundation

class ProfileStorage {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func retrieve() -> Profile {
        let name = self.defaults.string(forKey: "profile_name") ?? ""
        let image = self.defaults.string(forKey: "profile_image") ?? ""
        let description = self.defaults.string(forKey: "profile_description") ?? ""
        let company = self.defaults.string(forKey: "profile_company") ?? ""

        return Profile(name: name, image: image, description: description, company: company)
    }

    func persist(profile: Profile) {
        self.defaults.set(profile.name, forKey: "profile_name")
        self.defaults.set(profile.image, forKey: "profile_image")
        self.defaults.set(profile.description, forKey: "profile_description")
        self.defaults.set(profile.company, forKey: "profile_company")
    }
}

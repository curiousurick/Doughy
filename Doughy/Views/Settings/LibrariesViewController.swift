//
//  OpenSourceLibrariesRowFactory.swift
//  Doughy
//
//  Created by urickg on 4/2/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

fileprivate let personalName = "Doughy on Github"
fileprivate let personalLinkUrl = URL(string: "https://github.com/curiousurick/Doughy")!

fileprivate let eurekaName = "Eureka"
fileprivate let eurekaLink = URL(string: "https://github.com/xmartlabs/Eureka")!

class LibrariesViewController: FormViewController {
    
    private let personalLink = LibraryLink(name: personalName, link: personalLinkUrl)
    
    private let links: [LibraryLink] = [
        LibraryLink(name: eurekaName, link: eurekaLink)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("App Repository") { section in
            section <<< self.createLinkRow(link: self.personalLink)
        }
        form +++ Section("3rd Party Libraries") { section in
            for link in self.links {
                section <<< self.createLinkRow(link: link)
            }
        }
    }
    
    private func createLinkRow(link: LibraryLink) -> LabelRow {
        return LabelRow() { row in
            row.title = link.name
            row.cellStyle = .value1
        }.onCellSelection({ (cell, row) in
            UIApplication.shared.open(link.link, completionHandler: nil)
        })
    }
    
    private struct LibraryLink {
        let name: String
        let link: URL
    }

}

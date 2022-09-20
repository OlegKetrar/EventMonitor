//
//  ArchiveViewController.swift
//  
//
//  Created by Oleg Ketrar on 20.09.2022.
//

import Foundation
import UIKit

final class ArchiveViewController: UIViewController {
   var sessions: [Session] = []
   var onSelect: (Session) -> Void = { _ in }
}

private class SessionTableViewCell: UITableViewCell {

}

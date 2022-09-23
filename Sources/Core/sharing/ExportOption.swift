//
//  ExportOption.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 27.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public enum ExportOption {

/*
   case sessionOption(
      name: String,
      formatter: SessionFormatting)
*/

   case eventOption(
      name: String,
      formatter: EventFormatting)
}

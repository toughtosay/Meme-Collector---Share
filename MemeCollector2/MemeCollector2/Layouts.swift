//
//  Layouts.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-09-23.
//

import Foundation
import SwiftUI

struct ButtonOne: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .fontWeight(.heavy)
                .frame(height: 65)
                .foregroundColor(Color("BlackHex"))
        }
        .background(Color("OrangeHex"))
        .cornerRadius(20)
    }
}

struct ButtonWithLabel: View {
    
    let label: String
    let image: String
    let action: () -> Void
    
    let orange = Color("OrangeHex")
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Label(label, systemImage: image)
                .frame(maxWidth: .infinity)
                .fontWeight(.heavy)
                .frame(height: 65)
                .foregroundColor(Color("BlackHex"))
            
        })
        .background(Color("OrangeHex"))
        .cornerRadius(20)
    }
}














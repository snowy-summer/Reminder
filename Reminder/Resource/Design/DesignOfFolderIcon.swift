//
//  DesignOfFolderIcon.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import Foundation

enum DesignOfFolderIcon: Int, CaseIterable {
    case list
    case penceil
    case mappin
    case birthday
    case graduate
    case gym
    case exersice
    case forkAndNife
    case cup
    case tv
    case camping
    case music
    case game
    case home
    case airplane
    case camera
    case tennis
    case hospital
    case creditCard
    case study
    case clip
    case cloud
    case wifi
    case delivery
    case computer
    case market
    case doc
    case key
    case clock
    case heart
    
    var iconName: String {
        switch self {
        case .list:
            return "list.bullet"
        case .penceil:
            return "pencil"
        case .mappin:
            return "mappin"
        case .birthday:
            return "birthday.cake.fill"
        case .graduate:
            return "graduationcap.fill"
        case .gym:
            return "dumbbell.fill"
        case .exersice:
            return "figure.run"
        case .forkAndNife:
            return "fork.knife"
        case .cup:
            return "cup.and.saucer.fill"
        case .tv:
            return "tv"
        case .camping:
            return "tent.fill"
        case .music:
            return "music.note"
        case .game:
            return "gamecontroller.fill"
        case .home:
            return "house.fill"
        case .airplane:
            return "airplane"
        case .camera:
            return "camera.fill"
        case .tennis:
            return "tennis.racket"
        case .hospital:
            return "stethoscope"
        case .creditCard:
            return "creditcard.fill"
        case .study:
            return "pencil.and.ruler.fill"
        case .clip:
            return "paperclip"
        case .cloud:
            return "icloud.fill"
        case .wifi:
            return "wifi"
        case .delivery:
            return "truck.box.fill"
        case .computer:
            return "desktopcomputer"
        case .market:
            return "cart.fill"
        case .doc:
            return "doc.fill"
        case .key:
            return "key.fill"
        case .clock:
            return "clock.fill"
        case .heart:
            return "heart.fill"
        }
    }
}

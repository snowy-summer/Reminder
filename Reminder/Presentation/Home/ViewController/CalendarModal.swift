//
//  CalendarModal.swift
//  Reminder
//
//  Created by 최승범 on 7/5/24.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarModal: BaseViewController {
    
    private let calendarView = FSCalendar()
    var showFilteredResult: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        
        view.addSubview(calendarView)
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.isUserInteractionEnabled = true
        
        calendarView.backgroundColor = .cell
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.appearance.headerTitleColor = .baseFont
        calendarView.appearance.weekdayTextColor = .baseFont
        calendarView.appearance.titleDefaultColor = .baseFont
        calendarView.locale = Locale(identifier: "ko_KR")
        
    }
    
    override func configureLayout() {
        
        calendarView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureGestureAndButtonAction() {
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(switchScope(_:)))
        
        view.addGestureRecognizer(panGesture)
        
    }
    
    @objc private func switchScope(_ sender: UIPanGestureRecognizer) {
            let translation = sender.translation(in: self.view)
            
            if sender.state == .ended {
                if translation.y < 0 {
                    if calendarView.scope == .month {
                        calendarView.scope = .week
                    } else {
                        calendarView.scope = .month
                    }
                } else if translation.y > 0 {
                    if calendarView.scope == .month {
                        calendarView.scope = .week
                    } else {
                        calendarView.scope = .month
                    }
                }
            }
        }
}

extension CalendarModal: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // 왜 현재 날짜가 안나옴???
          dismiss(animated: true) { [weak self] in
              print(date)
              print(self?.calendarView.selectedDate)
              self?.showFilteredResult?(date)
          }
        
    }
    
}

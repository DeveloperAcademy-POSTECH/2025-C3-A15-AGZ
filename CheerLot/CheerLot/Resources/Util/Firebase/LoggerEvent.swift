//
//  LoggerEvent.swift
//  CheerLot
//
//  Created by 이현주 on 7/12/25.
//

import Foundation

public struct LoggerEvent {
    private init() { }
    
    public struct View {
        private init() { }
        
        public static let initSelectTeamV = "M1 팀 최초 선택"
        public static let mainRoasterV = "M2 메인 명단"
        public static let playCheerSongV = "M3 응원가 재생"
        public static let changePlayerV = "M4 선수 교체"
        
        public static let appInfoMainV = "A5 앱 정보 메인"
        public static let editTeamV = "A6 팀 변경"
        public static let termsV = "A7 약관"
        public static let aboutMakerV = "A8 쳐랏을 만든 사람들"
    }

    public struct CellEvent {
        private init() { }
        
        public static let teamTapped = "C1 팀 셀 선택"
        public static let cheerSongTapped = "C2 선수 응원가 셀 선택"
        public static let changePlayerTapped = "C3 교체할 선수 셀 선택"
        public static let appInfoMenuCellTapped = "C4 단순 메뉴(Text + >) 선택"
    }

    public struct ButtonEvent {
        private init() { }
        
        public static let completeBtnTapped = "B1 완료"
        public static let startingBtnTapped = "B2 선발 선수"
        public static let entireBtnTapped = "B3 전체 선수"
        public static let changePlayerBtnTapped = "B4 선수 교체"
        public static let playBtnTapped = "B5 재생/멈춤"
        public static let beforeBtnTapped = "B6 이전 응원가"
        public static let nextBtnTapped = "B7 다음 응원가"
        public static let appInfoBtnTapped = "B8 앱 정보"
        public static let editTeamBtnTapped = "B9 팀 변경"
        public static let alertAcceptBtnTapped = "B10 네트워크 얼럿 확인"
    }
}

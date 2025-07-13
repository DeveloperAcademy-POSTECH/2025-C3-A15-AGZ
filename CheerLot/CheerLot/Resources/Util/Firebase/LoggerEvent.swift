//
//  LoggerEvent.swift
//  CheerLot
//
//  Created by 이현주 on 7/12/25.
//

import Foundation

public struct LoggerEvent {
  private init() {}

  public struct View {
    private init() {}

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
    private init() {}

    public static let teamTapped = "C1 팀 셀 선택"
    public static let listTypeTapped = "C2 선수 명단 타입 셀 선택"
    public static let playerTapped = "C3 선수 명단 셀 선택"
    public static let cheerSongTapped = "C4 선수 응원가 셀 선택"
    public static let changePlayerTapped = "C5 교체할 선수 셀 선택"
    public static let appInfoMenuCellTapped = "C6 단순 메뉴(Text + >) 선택"
  }

  public struct ButtonEvent {
    private init() {}

    public static let completeBtnTapped = "B1 완료"
    public static let changePlayerBtnTapped = "B2 선수 교체"
    public static let playBtnTapped = "B3 재생/멈춤"
    public static let beforeBtnTapped = "B4 이전 응원가"
    public static let nextBtnTapped = "B5 다음 응원가"
    public static let appInfoBtnTapped = "B6 앱 정보"
    public static let editTeamBtnTapped = "B7 팀 변경"
    public static let alertAcceptBtnTapped = "B8 네트워크 얼럿 확인"
  }
}

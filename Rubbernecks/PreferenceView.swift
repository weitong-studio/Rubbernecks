//
//  PreferenceView.swift
//  Rubbernecks
//
//  Created by 吴曈 on 2024/4/20.
//

import SwiftUI


var currentUser: User = User(name: "游客", age: 1, showage: false, profile: .iconForShow, realName: "游客")

var preferenceContentList: [String] = [
    "匿名发言"
]
var preferenceStatementList: [Bool] = [
    false
]


struct PreferenceView: View {
    @State private var refreshViewId = Date().timeIntervalSince1970
    
    @State var tmpName: String = currentUser.name
    @State var tmpAge: Int = currentUser.age
    @State var tmpShowage: Bool = currentUser.showage
    @State var tmpProfile: ImageResource = currentUser.profile
    @State var tmpRealName: String = currentUser.realName
    
    var body: some View {
        Preference()
    }
    
    
    func Preference() -> some View {
        VStack {
            HStack {
                Text("设置").font(.largeTitle).bold()
                Spacer()
            }.padding(.horizontal, 20).padding(.top, 20)
            UserInput().id(refreshViewId)
            PreferenceList()
        }
    }
    
    func UserInput() -> some View {
        List {
            HStack {
                Text("用户名")
                Spacer()
                TextField("", text: $tmpName).frame(width: 100)
            }
            HStack {
                Text("年龄")
                Spacer()
                Text("\(tmpAge)")
                Stepper(value: $tmpAge, label: {
                    Text("")
                }).frame(width: 100)
            }
            HStack {
                Text("显示年龄")
                Spacer()
                Toggle(isOn: $tmpShowage, label: {})
            }
            HStack {
                Text("真名")
                Spacer()
                TextField("", text: $tmpRealName).frame(width: 100)
            }
            HStack {
                Spacer()
                Text((currentUser.name != tmpName || currentUser.age != tmpAge || currentUser.showage != tmpShowage || currentUser.realName != tmpRealName) ? "保存结果" : "未修改").padding(.vertical, 10).padding(.horizontal, 30).bold().overlay(content: {
                    RoundedRectangle(cornerRadius: 13).fill(.accent)
                    Text((currentUser.name != tmpName || currentUser.age != tmpAge || currentUser.showage != tmpShowage || currentUser.realName != tmpRealName) ? "保存结果" : "未修改").foregroundStyle(.white).bold()
                }).onTapGesture {
                    currentUser = User(name: tmpName, age: tmpAge, showage: tmpShowage, profile: tmpProfile, realName: tmpRealName)
                    refresh()
                }
            }
        }
    }
    
    func PreferenceList() -> some View {
        VStack {}
    }
    
    private func refresh() {
        refreshViewId = Date().timeIntervalSince1970
    }
}

#Preview {
    PreferenceView()
}

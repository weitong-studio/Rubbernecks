//
//  ContentView.swift
//  Rubbernecks
//
//  Created by wutong on 4/17/2024.
//

import SwiftUI



// Data
var userList: [String: User] = [
    "old_weitong": User(name: "老胃痛", age: 114, showage: true, profile: .oldWeitong, realName: "吴树"),
    "little_onion": User(name: "葱葱", age: 14, showage: true, profile: .littleOnion, realName: "吴葱"),
    "grandma_qian": User(name:"吔炫奶奶", age: 77, showage: false, profile: .grandmaQian, realName: "钱吔炫")
]
var grossipBoardView: [Board] = [
    Board(user: userList["old_weitong"]!, title: "0702的小孩竟然喜欢洗碗", content: "我昨天去他们家做客，听到孩子说：“拔拔，我要洗碗，我爱洗碗！”我惊得大彻大悟，下巴掉在了地上！\n现在的年轻人真是奇怪额……", color: .accentColor),
    Board(user: userList["little_onion"]!, title: "我画的小狗狗活了！！！", content: "我画了条小狗，没想到活了；随手拍了下来，没想到火了；不小心点到了流量加成，又一不小心画了114514元买了1145140次观看，啊哈哈哈好荒谬。", color: .mint),
    Board(user: userList["grandma_qian"]!, title: "课间操有大问题！！！", content: "课间操的动作一会向右，一会向左，容易把人绕晕！！！建议改版！！！人在做，天在看！不要胡作非为！", color: .yellow)
]
var boardCommentList: [Board: [Comment]] = [
    grossipBoardView[0]: [
        Comment(user: userList["grandma_qian"], content: "哇哦，这么神奇的吗？！"),
        Comment(user: userList["grandma_qian"], content: "好奇怪啊。。。"),
        Comment(user: userList["little_onion"], content: "好神奇，竟然不喜欢画画？"),
        Comment(user: userList["old_weitong"], content: "看不懂斯密达"),
        Comment(user: userList["old_weitong"], content: "VERY SDLANGE~")],
    grossipBoardView[1]: [],
    grossipBoardView[2]: []
]

let PROFILE_SCALE: CGFloat = 40
let BOARD_HEIGHT: CGFloat = 250


// Type Defining
struct User: Hashable {
    var name: String
    var age: Int
    var showage: Bool
    var profile: ImageResource
    
    var realName: String
}
struct Board: Hashable, Identifiable {
    let id = UUID()
    var user: User!
    var title: String
    var content: String
    
    var color = Color.pink
}
struct Comment: Hashable, Identifiable {
    let id = UUID()
    var user: User!
    var content: String
}


// Groosip View
struct GrossipView: View {
    var boardList: [Board]
    
    @State private var tmpComment: String = ""
    @FocusState private var commentInputIsFocused: Bool
    
    @State private var tmpGrossipTitle: String = ""
    @State private var tmpGrossipContent: String = ""
    // @State var is_in_comment: Bool = false
    
    // Body
    var body: some View {
        GrossipInput()
    }
    
    
    func GrossipInput() -> some View {
        VStack {
            HStack {
                TextField("标题", text: $tmpGrossipTitle)
                Image("bubble.left").imageScale(.large).padding(.vertical, 10).padding(.horizontal, 30).overlay(content: {
                    RoundedRectangle(cornerRadius: 15).fill(.accent)
                    Image("bubble.left").imageScale(.large).foregroundStyle(.white)
                })
            }
        }
    }
    
    // The main list of grossip boards.
    func GrossipList() -> some View {
        NavigationSplitView {
            HStack {
                Text("八卦区").font(.largeTitle).bold()
                Spacer()
            }.padding(.horizontal, 20).padding(.top, 20)
            SwiftUI.ScrollView {
                ForEach(boardList) { board in
                    NavigationLink {
                        GrossipDetail(board: board)
                    } label: {
                        BasicGrossipBoard(board: board).frame(height: BOARD_HEIGHT).padding(.vertical, 5)
                    }.foregroundStyle(.black)
                }
            }.padding(.horizontal, 20)
        } detail: {
            Text("去看看")
        }
    }
    
    // A grossip board with a comment view.
    func GrossipBoard(board: Board) -> some View {
        NavigationView {
            NavigationLink {
                GrossipDetail(board: board)
            } label: {
                BasicGrossipBoard(board: board).frame(height: 250)
            }.foregroundStyle(.black)
        } // .toolbar(is_in_comment ? .hidden : .visible)
    }
    
    // Detail of a single grossip
    func GrossipDetail(board: Board) -> some View {
        VStack {
            BasicGrossipDetail(board: board, profile_scale: PROFILE_SCALE).padding(.bottom, 20)
            HStack {
                Text("瓜子云").font(.title2).bold().multilineTextAlignment(.leading).padding(.leading, 20)
                Spacer()
            }
            CommentList(comments: boardCommentList[board]!, profile_scale: PROFILE_SCALE).padding(.horizontal, 20)
            CommentInput(targetBoard: board).padding([.horizontal, .bottom], 20)
        }
    }
    
    func BasicGrossipDetail(board: Board, profile_scale: CGFloat) -> some View {
        VStack {
            Text(board.title).font(.title).bold()
            HStack {
                Image(board.user.profile).resizable().frame(width: profile_scale, height: profile_scale).clipShape(Circle())
                HStack {
                    Text("@" + board.user.name).font(.title2).lineLimit(1).bold()
                    Spacer()
                }
            }.padding(.horizontal, 20)
            Text(board.content).font(.title3).padding(.leading, 40).padding(.trailing, 20)
        }
    }
    
    
    // The input of comments
    func CommentInput(targetBoard: Board) -> some View {
        HStack(alignment: .center) {
            Button(action: {
                commentInputIsFocused = false
            }, label: {
                Image(systemName: "arrowshape.down").imageScale(.medium).padding(.vertical, 15).padding(.horizontal, 20).overlay(content: {
                    RoundedRectangle(cornerRadius: 10).fill(.accent)
                    Image(systemName: "arrowshape.down").imageScale(.medium).foregroundStyle(.white).font(.title2).foregroundStyle(.white)
                })
            })
            TextField("多说点，大家爱听", text: $tmpComment).font(.title2).padding(10).overlay(content: {
                RoundedRectangle(cornerRadius: 10).fill(.clear).stroke(.accent, lineWidth: 2)
            }).focused($commentInputIsFocused)
            Button(action: {
                boardCommentList[targetBoard]!.append(Comment(user: currentUser, content: tmpComment))
                tmpComment = ""
            }, label: {
                Text("发送").font(.title2).padding(.vertical, 11.5).padding(.horizontal, 20).overlay(content: {
                    RoundedRectangle(cornerRadius: 10).fill(.accent)
                    Text("发送").font(.title2).foregroundStyle(.white)
                })
            })
        }
    }
    
    // A list of comments
    func CommentList(comments: [Comment], profile_scale: CGFloat) -> some View {
        SwiftUI.ScrollView {
            ForEach(comments.reversed()) { comment in
                SingleComment(comment: comment, profile_scale: profile_scale)
                    .padding(.bottom, 15)
            }
        }
    }
    
    // Just a single comment
    func SingleComment(comment: Comment, profile_scale: CGFloat) -> some View {
        HStack {
            Image(comment.user.profile).resizable().frame(width: profile_scale, height: profile_scale).clipShape(Circle())
            VStack {
                HStack {
                    Text("@" + comment.user.name).font(.title3).lineLimit(1).bold()
                    Spacer()
                }
                HStack {
                    Text(" " + comment.content)
                    Spacer()
                }
            }
        }
    }
    
    
    // A basic grosip board without a comment view.
    func BasicGrossipBoard(board: Board) -> some View {
        ZStack {
            Rectangle().fill(board.color)
            VStack {
                HStack {
                    Text(board.title).font(.title).multilineTextAlignment(.leading).lineLimit(1).bold()
                    Spacer()
                    Text(board.user.name).font(.title2).multilineTextAlignment(.trailing).lineLimit(1)
                }.padding([.leading, .horizontal], 10).offset(y: 13)
                ZStack {
                    RoundedRectangle(cornerRadius: 13).fill(.white.opacity(0.35))
                    Text(board.content).font(.title3).multilineTextAlignment(.leading).padding(5)
                }.padding(5)
            }
        }.clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    GrossipView(boardList: grossipBoardView)
    // GrossipView().BasicGrossipDetail(board: grossip_board_list[0], profile_scale: PROFILE_SCALE)
    // GrossipView().CommentInput(targetBoard: grossip_board_list[0])
}
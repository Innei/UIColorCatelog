//
//  ContentView.swift
//  ColorCatelog
//
//  Created by Innei on 2025/1/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            ForEach(UIColor.allSystemColors, id: \.name) { color in
                HStack {
                    Text(".\(color.name)")
                        .font(.body)
                        .monospaced()
                    Spacer()
                    ZStack(alignment: .center) {
                        Canvas { context, _ in
                            var topPath = Path()
                            topPath.move(to: .zero)
                            topPath.addLine(to: .init(x: 32, y: 0))
                            topPath.addLine(to: .init(x: 0, y: 32))
                            topPath.closeSubpath()
                            context.fill(topPath, with: .color(.white))

                            var bottomPath = Path()
                            bottomPath.move(to: .zero)
                            bottomPath.addLine(to: .init(x: 32, y: 0))
                            bottomPath.addLine(to: .init(x: 0, y: 32))
                            bottomPath.closeSubpath()
                            context.fill(bottomPath, with: .color(.black))
                            
                            context.fill(.init(ellipseIn: CGRect(x: 0, y: 0, width: 32, height: 32).insetBy(dx: 4, dy: 4)), with: .color(.init(uiColor: color.color)))
                        }
                        .frame(width: 32, height: 32)
                        .mask(
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 32, height: 32)
                        )
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(uiColor: .separator))
                            .frame(width: 32, height: 32)
                    }
//                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                    .padding(6)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

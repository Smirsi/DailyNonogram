import SwiftUI

private struct ToolItem: Identifiable {
    let tool: Tool
    let icon: String
    let label: LocalizedStringKey
    var id: String { tool.id }
}

struct ToolbarView: View {
    @Binding var currentTool: Tool
    @Namespace private var toolNamespace

    private let tools: [ToolItem] = [
        ToolItem(tool: .pen,    icon: "pencil", label: "Stift"),
        ToolItem(tool: .eraser, icon: "eraser", label: "Radierer"),
        ToolItem(tool: .marker, icon: "xmark",  label: "Markierung"),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tools) { item in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        currentTool = item.tool
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20, weight: .regular))
                        Text(item.label)
                            .font(DS.toolLabelFont())
                    }
                    .foregroundStyle(currentTool == item.tool ? DS.accent : DS.textSecondary)
                    .frame(width: 80, height: 52)
                    .background {
                        if currentTool == item.tool {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(DS.accent.opacity(0.12))
                                .matchedGeometryEffect(id: "toolSelector", in: toolNamespace)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(DS.surface, in: Capsule())
        .overlay(Capsule().stroke(DS.separator, lineWidth: 0.5))
    }
}

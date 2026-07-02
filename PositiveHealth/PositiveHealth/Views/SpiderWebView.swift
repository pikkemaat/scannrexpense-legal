import SwiftUI

/// The Positive Health spider web: a hexagonal radar chart with one axis per
/// dimension, rings at 0/2/4/6/8/10 and the personal profile drawn on top.
struct SpiderWebView: View {
    let dimensions: [Dimension]
    let values: [Double]
    var comparisonValues: [Double]? = nil
    var showLabels: Bool = true

    @Environment(AppSettings.self) private var settings
    private let maxValue: Double = 10

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 * (showLabels ? 0.62 : 0.92)

            ZStack {
                Canvas { context, _ in
                    drawGrid(context: context, center: center, radius: radius)
                    if let comparison = comparisonValues {
                        drawPolygon(context: context, center: center, radius: radius,
                                    values: comparison,
                                    fill: Color.gray.opacity(0.12),
                                    stroke: Color.gray.opacity(0.7),
                                    dashed: true)
                    }
                    drawPolygon(context: context, center: center, radius: radius,
                                values: values,
                                fill: Color.accentColor.opacity(0.22),
                                stroke: Color.accentColor,
                                dashed: false)
                    drawVertexDots(context: context, center: center, radius: radius)
                }

                if showLabels {
                    ForEach(Array(dimensions.enumerated()), id: \.element.id) { index, dimension in
                        let point = vertex(center: center, radius: radius * 1.12, index: index, value: maxValue)
                        VStack(spacing: 2) {
                            Image(systemName: dimension.symbolName)
                                .font(.caption)
                            Text(Loc.name(dimension, settings.language))
                                .font(.caption2.weight(.semibold))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(dimension.color)
                        .frame(width: size.width * 0.32)
                        .position(labelPosition(for: index, vertex: point, in: size))
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func angle(for index: Int) -> Double {
        // Start at the top, clockwise, like the printed tool.
        -Double.pi / 2 + Double(index) * 2 * .pi / Double(max(dimensions.count, 1))
    }

    private func vertex(center: CGPoint, radius: CGFloat, index: Int, value: Double) -> CGPoint {
        let a = angle(for: index)
        let r = radius * CGFloat(value / maxValue)
        return CGPoint(x: center.x + r * CGFloat(cos(a)), y: center.y + r * CGFloat(sin(a)))
    }

    private func labelPosition(for index: Int, vertex: CGPoint, in size: CGSize) -> CGPoint {
        // Nudge labels outward vertically at the top and bottom axes.
        var point = vertex
        let a = angle(for: index)
        point.y += CGFloat(sin(a)) * 14
        return point
    }

    private func drawGrid(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        let gridColor = Color.primary.opacity(0.25)

        for ring in stride(from: 2, through: 10, by: 2) {
            var path = Path()
            for index in 0..<dimensions.count {
                let point = vertex(center: center, radius: radius, index: index, value: Double(ring))
                if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
            }
            path.closeSubpath()
            context.stroke(path, with: .color(gridColor), lineWidth: 0.8)
        }

        for index in 0..<dimensions.count {
            var path = Path()
            path.move(to: center)
            path.addLine(to: vertex(center: center, radius: radius, index: index, value: maxValue))
            context.stroke(path, with: .color(gridColor), lineWidth: 0.8)
        }

        // Scale labels 0…10 along the top axis.
        for ring in stride(from: 0, through: 10, by: 2) {
            let point = CGPoint(x: center.x - 10, y: center.y - radius * CGFloat(Double(ring) / maxValue))
            let text = Text("\(ring)").font(.system(size: 8)).foregroundStyle(.secondary)
            context.draw(text, at: point, anchor: .center)
        }
    }

    private func drawPolygon(context: GraphicsContext, center: CGPoint, radius: CGFloat,
                             values: [Double], fill: Color, stroke: Color, dashed: Bool) {
        guard values.count == dimensions.count else { return }
        var path = Path()
        for index in 0..<dimensions.count {
            let point = vertex(center: center, radius: radius, index: index, value: values[index])
            if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        context.fill(path, with: .color(fill))
        let style = StrokeStyle(lineWidth: 2, lineJoin: .round, dash: dashed ? [4, 4] : [])
        context.stroke(path, with: .color(stroke), style: style)
    }

    private func drawVertexDots(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        guard values.count == dimensions.count else { return }
        for index in 0..<dimensions.count {
            let point = vertex(center: center, radius: radius, index: index, value: values[index])
            let rect = CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)
            context.fill(Path(ellipseIn: rect), with: .color(dimensions[index].color))
            context.stroke(Path(ellipseIn: rect), with: .color(.white), lineWidth: 1.5)
        }
    }
}

#Preview {
    SpiderWebView(dimensions: ToolVersion.adolescent.dimensions,
                  values: [7, 5, 6, 8, 4, 6],
                  comparisonValues: [5, 4, 5, 6, 3, 5])
        .padding()
        .environment(AppSettings())
}

import SwiftUI

/// Hand-drawn glyphs from the design boards. Stroke-based so they scale and
/// recolor through tokens.
struct PencilGlyph: View {
    var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 4, y: 18))
            p.addLine(to: CGPoint(x: 4.8, y: 14.8))
            p.addLine(to: CGPoint(x: 14.6, y: 5))
            p.addQuadCurve(to: CGPoint(x: 17, y: 7.4), control: CGPoint(x: 16.8, y: 5.2))
            p.addLine(to: CGPoint(x: 7.2, y: 17.2))
            p.closeSubpath()
            p.move(to: CGPoint(x: 13.2, y: 6.4))
            p.addLine(to: CGPoint(x: 15.6, y: 8.8))
        }
        .stroke(DS.Color.fabGlyph, style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
        .frame(width: 22, height: 22)
    }
}

struct EmptyNoteGlyph: View {
    var body: some View {
        Path { p in
            p.addRoundedRect(in: CGRect(x: 12, y: 8, width: 32, height: 40),
                             cornerSize: CGSize(width: 4, height: 4))
            p.move(to: CGPoint(x: 20, y: 20)); p.addLine(to: CGPoint(x: 36, y: 20))
            p.move(to: CGPoint(x: 20, y: 28)); p.addLine(to: CGPoint(x: 36, y: 28))
            p.move(to: CGPoint(x: 20, y: 36)); p.addLine(to: CGPoint(x: 29, y: 36))
        }
        .stroke(DS.Color.emptyGlyph, style: StrokeStyle(lineWidth: 2, lineCap: .round))
        .frame(width: DS.Metric.emptyGlyph, height: DS.Metric.emptyGlyph)
    }
}

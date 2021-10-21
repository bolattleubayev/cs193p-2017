//
//  setCardView.swift
//  setCardDrawing
//
//  Created by macbook on 10/10/19.
//  Copyright © 2019 bolattleubayev. All rights reserved.
//

import UIKit

@IBDesignable // makes you see the result in storyboard without compilation

class setCardButton: UIButton {
    var deviceOrientationIsPortrait = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var cardWidth: Int = 0
    var cardHeight: Int = 0
    
    var shape: Int = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shade: Int = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var color: Int = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var numberOfShapes: Int = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isFaceUp: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    private func drawShape(center: CGPoint, sideSize: CGFloat, cardWidth: Int, cardHeight: Int, shape: Int, shade: Int, color: Int, numberOfShapes: Int) -> UIBezierPath {
        
        var shapeColor: UIColor
        let path = UIBezierPath()
        
        // Setting the color of the shape
        if color == setCard.Color.red.rawValue {
            shapeColor = UIColor.red
        } else if color == setCard.Color.green.rawValue {
            shapeColor = UIColor.green
        } else if color == setCard.Color.purple.rawValue {
            shapeColor = UIColor.purple
        } else {
            shapeColor = UIColor.clear
        }
        
        // Drawing appropriate number of shapes
        for shapeNumber in 0...numberOfShapes{
            
            var aspectRatioHelperX = CGFloat(0.0)
            var aspectRatioHelperY = CGFloat(0.0)
            
            // Changing orientation w.r.t aspect ratio
            
            if cardHeight > cardWidth {
                aspectRatioHelperX = CGFloat(0.0)
                aspectRatioHelperY = CGFloat(shapeNumber) * sideSize + CGFloat(shapeNumber) - sideSize / 2
            } else {
                aspectRatioHelperX = CGFloat(shapeNumber) * sideSize + CGFloat(shapeNumber) - sideSize / 2
                aspectRatioHelperY = CGFloat(0.0)
            }
            
            let startX = center.x + aspectRatioHelperX
            let startY = center.y + aspectRatioHelperY
            
            // Drawing desired shape
            if shape == setCard.Shape.triangle.rawValue {
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: startX + sideSize, y: startY))
                path.addLine(to: CGPoint(x: startX + sideSize / 2, y: startY + sideSize))
                path.close()
            } else if shape == setCard.Shape.square.rawValue {
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: startX + sideSize, y: startY))
                path.addLine(to: CGPoint(x: startX + sideSize, y: startY + sideSize))
                path.addLine(to: CGPoint(x: startX, y: startY + sideSize))
                path.close()
            } else if shape == setCard.Shape.circle.rawValue{
                path.move(to: CGPoint(x: startX, y: startY))
                path.addArc(withCenter: CGPoint(x: startX + sideSize / 2, y: startY + sideSize / 2), radius: sideSize / 2, startAngle: CGFloat.pi, endAngle: 3*CGFloat.pi, clockwise: true)
            }
            
            
            // Applying shading
            if shade == setCard.Shade.filled.rawValue {
                shapeColor.setFill()
                shapeColor.setStroke()
            } else if shade == setCard.Shade.stripped.rawValue {
                shapeColor.setStroke()
                
                for lineStride in stride(from: 0.0, to: sideSize, by: sideSize / 8) {
                    path.move(to: CGPoint(x: startX + CGFloat(lineStride), y: startY))
                    path.addLine(to: CGPoint(x: startX + CGFloat(lineStride), y: startY + sideSize))
                }
            } else {
                shapeColor.setStroke()
            }
        }
        
        path.addClip()
        
        // Changing line width w.r.t shape size
        path.lineWidth = CGFloat(cardHeight) / frameWidth
        
        path.fill()
        path.stroke()
        
        return path
    }
    
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            let sideOfIndividualShape = CGFloat(cardHeight) / side
            
            _ = drawShape(center: CGPoint(x: bounds.midX - sideOfIndividualShape / 2, y: bounds.midY - sideOfIndividualShape), sideSize: sideOfIndividualShape, cardWidth: cardWidth, cardHeight: cardHeight, shape: shape, shade: shade, color: color, numberOfShapes: numberOfShapes)
        } else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
        
    }
    
}

extension setCardButton {
    private struct SizeRatio {
        static let side: CGFloat = 5.0
        static let cornerRadiusOfTheCard: CGFloat = 8
        static let shapeFrameWidth: CGFloat = 138
    }
    
    private var cornerRadius: CGFloat {
        return SizeRatio.cornerRadiusOfTheCard
    }
    
    private var side: CGFloat {
        return SizeRatio.side
    }
    
    private var frameWidth: CGFloat {
        return SizeRatio.shapeFrameWidth
    }
}


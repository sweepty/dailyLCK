//
//  CalendarCellScrollView.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 30/11/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import UIKit

class CalendarCellScrollView: UIScrollView {
    var numberOfRows = 0
    var currentRow = 0
    var tags = [UILabel]()
    
    var hashtagsOffset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 10)
    var rowHeight:CGFloat = 20 //height of rows
    var tagHorizontalPadding:CGFloat = 2.0 // padding between tags horizontally
    var tagVerticalPadding:CGFloat = 2.0 // padding between tags vertically
    var tagCombinedMargin:CGFloat = 3.0 // margin of left and right combined, text in tags are by default centered.
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        numberOfRows = Int(frame.height / rowHeight)
        self.showsVerticalScrollIndicator = true
        self.isScrollEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addTag(_ text:String,target:AnyObject,tapAction:Selector?,longPressAction:Selector?,backgroundColor:UIColor,textColor:UIColor,comesTag:Int)
    {
        
        
        
        if tags.count > 0 {
            
            for tagsec in tags {
                
                if tagsec.tag == comesTag
                {
                    removeTagWithTag(tagsec.tag)
                    
                }else{
                    
                    //instantiate label
                    //you can customize your label here! but make sure everything fit. Default row height is 30.
                    let label = UILabel()
                    label.layer.cornerRadius = 5
                    label.clipsToBounds = true
                    label.textColor = UIColor.white
                    label.backgroundColor = backgroundColor
                    label.text = text
                    label.tag = comesTag
                    label.textColor = textColor
                    label.font = UIFont.systemFont(ofSize: 12)
                    label.sizeToFit()
                    label.textAlignment = NSTextAlignment.center
                    self.tags.append(label)
                    label.layer.shouldRasterize = true
                    label.layer.rasterizationScale = UIScreen.main.scale
                    //process actions
                    if tapAction != nil
                    {
                        let tap = UITapGestureRecognizer(target: target, action: tapAction)
                        label.isUserInteractionEnabled = true
                        label.addGestureRecognizer(tap)
                    }
                    
                    if longPressAction != nil
                    {
                        let longPress = UILongPressGestureRecognizer(target: target, action: longPressAction)
                        label.addGestureRecognizer(longPress)
                    }
                    
                    //calculate frame
                    label.frame = CGRect(x: label.frame.origin.x,y: label.frame.origin.y , width: label.frame.width + tagCombinedMargin, height: rowHeight - tagVerticalPadding)
                    if self.tags.count == 0
                    {
                        label.frame = CGRect(x: hashtagsOffset.left, y: hashtagsOffset.top, width: label.frame.width, height: label.frame.height)
                        self.addSubview(label)
                        
                    }
                    else
                    {
                        label.frame = self.generateFrameAtIndex(tags.count-1, rowNumber: &currentRow)
                        self.addSubview(label)
                    }
                    
                    
                    
                }
            }
            
        }else{
            
            //instantiate label
            //you can customize your label here! but make sure everything fit. Default row height is 30.
            let label = UILabel()
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            label.textColor = UIColor.white
            label.backgroundColor = backgroundColor
            label.text = text
            label.tag = comesTag
            label.textColor = textColor
            label.font = UIFont.systemFont(ofSize: 12)
            label.sizeToFit()
            label.textAlignment = NSTextAlignment.center
            self.tags.append(label)
            label.layer.shouldRasterize = true
            label.layer.rasterizationScale = UIScreen.main.scale
            //process actions
            if tapAction != nil
            {
                let tap = UITapGestureRecognizer(target: target, action: tapAction)
                label.isUserInteractionEnabled = true
                label.addGestureRecognizer(tap)
            }
            
            if longPressAction != nil
            {
                let longPress = UILongPressGestureRecognizer(target: target, action: longPressAction)
                label.addGestureRecognizer(longPress)
            }
            
            //calculate frame
            label.frame = CGRect(x: label.frame.origin.x,y: label.frame.origin.y , width: label.frame.width + tagCombinedMargin, height: rowHeight - tagVerticalPadding)
            if self.tags.count == 0
            {
                label.frame = CGRect(x: hashtagsOffset.left, y: hashtagsOffset.top, width: label.frame.width, height: label.frame.height)
                self.addSubview(label)
                
            }
            else
            {
                label.frame = self.generateFrameAtIndex(tags.count-1, rowNumber: &currentRow)
                self.addSubview(label)
            }
            
            
        }
        
        //  tags = tags.orderedSet
        
        
    }
    
    
    
    fileprivate func isOutofBounds(_ newPoint:CGPoint,labelFrame:CGRect)
    {
        let bottomYLimit = newPoint.y + labelFrame.height
        if bottomYLimit > self.contentSize.height
        {
            self.contentSize = CGSize(width: 400, height: self.contentSize.height + rowHeight - tagVerticalPadding + 100)
        }
    }
    
    func getNextPosition() -> CGPoint
    {
        return getPositionForIndex(tags.count-1, rowNumber: self.currentRow)
    }
    
    func getPositionForIndex(_ index:Int,rowNumber:Int) -> CGPoint
    {
        if index == 0
        {
            return CGPoint(x: hashtagsOffset.left, y: hashtagsOffset.top)
        }
        let y = CGFloat(rowNumber) * self.rowHeight + hashtagsOffset.top
        let lastTagFrame = tags[index-1].frame
        let x = lastTagFrame.origin.x + lastTagFrame.width + tagHorizontalPadding
        return CGPoint(x: x, y: y)
    }
    
    func reset()
    {
        for tag in tags
        {
            tag.removeFromSuperview()
        }
        tags = []
        currentRow = 0
        numberOfRows = 0
    }
    
    
    func remove()
    {
        tags.removeAll()
    }
    
    
    func hide()
    {
        tags.removeAll()
        reset()
        
    }
    
    func removeTagWithName(_ name:String)
    {
        for (index,tag) in tags.enumerated()
        {
            if tag.text! == name
            {
                removeTagWithIndex(index)
            }
        }
    }
    
    
    func removeTagWithIndex(_ index:Int)
    {
        if index > tags.count - 1
        {
            print("ERROR: Tag Index \(index) Out of Bounds")
            return
        }
        tags[index].removeFromSuperview()
        tags.remove(at: index)
        layoutTagsFromIndex(index)
    }
    
    
    
    func removeTagWithTag(_ taggelen:Int)
    {
        for (index,tag) in tags.enumerated()
        {
            if tag.tag ==  taggelen {
                tags.remove(at: index)
                return
                
            }
            
        }
        
    }
    
    
    func varmiBak (_ gelen:Int ,onCompletion: @escaping (Bool) -> Void){
        for (_,tag) in tags.enumerated()
        {
            if tag.tag == gelen
            {
                onCompletion(true)
                
            }else{
                
                onCompletion(false)
            }
        }
        
    }
    
    
    fileprivate func getRowNumber(_ index:Int) -> Int
    {
        return Int((tags[index].frame.origin.y - hashtagsOffset.top)/rowHeight)
    }
    
    fileprivate func layoutTagsFromIndex(_ index:Int,animated:Bool = true)
    {
        if tags.count == 0
        {
            return
        }
        let animation:()->() =
        {
            var rowNumber = self.getRowNumber(index)
            for i in index...self.tags.count - 1
            {
                self.tags[i].frame = self.generateFrameAtIndex(i, rowNumber: &rowNumber)
            }
        }
        UIView.animate(withDuration: 0.3, animations: animation)
    }
    
    fileprivate func generateFrameAtIndex(_ index:Int,rowNumber: inout Int) -> CGRect
    {
        var newPoint = self.getPositionForIndex(index, rowNumber: rowNumber)
        if (newPoint.x + self.tags[index].frame.width) >= self.frame.width
        {
            rowNumber += 1
            newPoint = CGPoint(x: self.hashtagsOffset.left, y: CGFloat(rowNumber) * rowHeight + self.hashtagsOffset.top)
        }
        self.isOutofBounds(newPoint,labelFrame: self.tags[index].frame)
        return CGRect(x: newPoint.x, y: newPoint.y, width: self.tags[index].frame.width, height: self.tags[index].frame.height)
    }
    
    func removeMultipleTagsWithIndices(_ indexSet:Set<Int>)
    {
        let sortedArray = Array(indexSet).sorted()
        for index in sortedArray
        {
            if index > tags.count - 1
            {
                print("ERROR: Tag Index \(index) Out of Bounds")
                continue
            }
            tags[index].removeFromSuperview()
            tags.remove(at: index)
        }
        layoutTagsFromIndex(sortedArray.first!)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

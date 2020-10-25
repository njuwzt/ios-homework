//
//  File.swift
//  calculator
//
//  Created by Astinna on 2020/10/25.
//  Copyright © 2020 NJU. All rights reserved.
//

import Foundation
class calculator{
    var num1 : Float
    var num2 : Float
    var operation : String
    var result : String
    var eorPi : Bool
    init() {
        self.num1=0
        self.num2=0
        self.operation=""
        self.result="0"
        self.eorPi=false
    }
    func inputNum(num: String)->String{
        if  num=="AC"{
            self.num1=0
            self.num2=0
            self.operation=""
            self.result="0"
            self.eorPi=false
        }
        else if num=="+/-"{
            if (self.result as NSString).floatValue<0{
                self.result=String(self.result.dropFirst())
            }
            else{
                self.result="-"+self.result
            }
        }
        else if num=="."&&self.eorPi==false{
            let t=(self.result as NSString).floatValue
            if t==floor(t){
                self.result+="."
            }
        }
        else if num=="e"{
            self.num2=2.718281828459045
            self.result=String(2.718281828459045)
        }
        else if num=="π"{
            self.num2=3.141592653589793
            self.result=String(3.141592653589793)
        }
        else if self.eorPi==false{
            if self.result=="0"{
                self.result=num
            }
            else{
                self.result+=num
            }
            self.num2=(self.result as NSString).floatValue
        }
        return self.result
    }
    func UnaryOpera(cal:String)->Bool{
        return cal=="x^2"||cal=="x^3"||cal=="e^x"||cal=="10^x"||cal=="1/x"||cal=="2√x"||cal=="3√x"||cal=="ln"||cal=="log10"||cal=="x!"||cal=="sin"||cal=="cos"||cal=="tan"||cal=="sinh"||cal=="cosh"||cal=="tanh"||cal=="%"
    }
    func CalUnaryOpera(cal:String)->String{
        if cal=="x^2"{
            self.num2=pow(self.num2, 2)
        }
        else if cal=="x^3"{
            self.num2=pow(self.num2, 3)
        }
        else if cal=="e^x"{
            self.num2=pow(2.718281828459045, self.num2)
        }
        else if cal=="10^x"{
            self.num2 = pow(10, self.num2)
        }
        else if cal=="1/x"{
            self.num2=pow(self.num2, -1)
        }
        else if cal=="2√x"{
            self.num2=pow(self.num2, 1/2)
        }
        else if cal=="3√x"{
            self.num2=pow(self.num2, 1/3)
        }
        else if cal=="ln"{
            if self.num2>0{
                self.num2=log(self.num2)
            }
        }
        else if cal=="log10"{
            if self.num2>0{
                self.num2 = log10(self.num2)
            }
        }
        else if cal=="x!"{
            if self.num2>=0{
                var j=1
                var i=1
                while Float(j)<self.num2{
                    j+=1
                    i*=j
                }
                self.num2 = Float(i)
            }
        }
        else if cal=="sin"{
            self.num2=self.num2/180*3.14159265358979
            self.num2=sin(self.num2)
        }
        else if cal=="cos"{
            self.num2=self.num2/180*3.14159265358979
            self.num2=cos(self.num2)
        }
        else if cal=="tan"{
            self.num2=self.num2/180*3.14159265358979
            self.num2=tan(self.num2)
        }
        else if cal=="sinh"{
            self.num2=sinh(self.num2)
        }
        else if cal=="cosh"{
            self.num2=cosh(self.num2)
        }
        else if cal=="tanh"{
            self.num2=tanh(self.num2)
        }
        else if cal=="%"{
            self.num2=self.num2/100
        }
        self.result=String(self.num2)
        return self.result
    }
    func inputCal(calcu: String)->String{
        var result:String
        result="0"
        if UnaryOpera(cal: calcu)==true{
            result=CalUnaryOpera(cal: calcu)
        }
        return result
    }
        
    
    
}

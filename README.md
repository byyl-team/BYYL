# BYYL
错误识别和恢复的要求总结：
1. 二维数组的错误访问方式：a[5,3]，正确的是a[5][3]
2. 一行语句结尾没有分号 ; 
3. 错误的八进制和十六进制的识别，见P8 例1.6
4. 错误的（指数）浮点数
5. 丢失右括号（小、中、大）
首先完成错误的恢复机制，再进行这些特定错误的识别和恢复。

## 目前的解决方案：
1. 对于int和float的error在flex中识别并打印错误信息，并且在syntax.y中加入Exp-> float_error, Exp->int_error 即可
2. 对于普适的错误恢复机制：把所有能以SEMI和括号结尾的产生式，加一个 -> error SEMI/RP/RB/RC 
3. 对于丢失的分号和括号的情况，对所有形如 Expp -> XXX SEMI/RP/RB/RC 的产生式，增加一条 Expp_miss_SEMI -> XXX ，增加非终结符Expp_miss_SEMI，需要对应在定义部分做token补充。
另外，增加 Expp -> Expp_miss_SEMI ，这样Expp_miss_SEMI也可以正常归约！
在打印语法树的时候，对于非终结符Expp_miss_SEMI 输出错误信息
### 重要！
加入3之后会产生和原来正确表达式的移入、归约冲突。但是bison默认会移入，因此如果存在; 不会发生误归约成miss_SEMI的情况
另外，论证a[5,3]会被Expp_miss_SEMI -> ID LB INT 归约，而不是 Expp -> error RB 
在进行到,时，其实就可以归约到Expp_miss_RB，但是如果要用Expp -> error RB 归约，还需要pop前面的那些，默认一定会能归约就归约。因此可以正确报出错误信息
5,3会被归约成Args，然后不存在产生式 ID [ Args 所以会来到Expp -> error RB 
但是其实到, 就归约等不到5,3被归约


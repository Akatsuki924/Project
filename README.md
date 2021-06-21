# Projects
for cs61c learning

# Project 2

* 这个project在给出数据集以及weight matrix的情况下让你用RESIC-V写一个神经网络的接口函数，并写出满足要求的线性矩阵运算函数和非线性的判断函数，整个过程如下图所示，从右往左的顺序，实现自动识别手写数字的图片

![image-20210607152838912](F:\CS\picture\image-20210607152838912-1624235176374.png)

* 总流程就是将二进制格式的图片写成一维向量的形式，和weight matrix m0相乘，结果矩阵负数元素置为0，再和weight matrix m1相乘，结果矩阵取元素最大的index作为识别的结果。

* 做完这个project可以对calling conventions有很好的掌握，我写代码的时候总结的经验就是在中间有调用其他函数时，所有的中间变量均用saved register来储存，这样就避免了使用Caller save去储存t registers这样只有函数的首尾有sp指针的移动不容易出错，反正s有十多个总不会全用完
* 做这个感觉还复习了之前C里面学的文件读写操作，之前考研的时候只会死记硬背，但是这里真的用到了，像fopen fclose fread，对于他们的理解更加深刻了，先打开文件，分配内存然后读入，或者从内存中写入文件，最后释放内存空间。

* 需要熟悉相对路径和绝对路径的概念，不然命令行操作会出错，我在写read_matrix这个函数的时候就是死活无法fopen，总是返回值-1打开文件失败，后来终于发现是和命令行当前工作路径（CWD）有关，需要根据这个对题目给出的pathfile作调整的。做到这个project我才发现vscode可以copy 相对路径的，以前都是手打真是蠢到家了，因为这些问题浪费了很多无意义的时间。。。
* 一定要注意如果使用本地.jar文件进行调试运行.s文件必须保证你没有中文的注释，不然会提示出错，但是在web上用venus来调试就不会出现这个问题
* 最后将所有的函数全放在一起，建议把每个函数前面关于arguements的注释说明全部copy过来，不然很可能会写错一个register就gg了
* 最后整个程序是使用命令行运行main，需要了解argc,argv 分别是什么意思，怎么在命令行导入参数，课程网站上面都说的很明白。
* 当函数很多的时候，给程序不同的错误类型规定一个特定的exitcode对于debug非常有帮助，可以很快定位是哪个位置出问题了
* 因为register不能自己像c里面编程给变量随便取名，都是固定的字母+数字，所以一定要做好注释说明，不然看代码真的头大

# Project 3

* 这个project用一个叫logisim-evolution的java软件手动搭一个可以运行RISC-V 指令的CPU结构，前辈用了“手撕CPU”了描述这个project，我觉得十分之贴切，总共分为五个任务：
* Task1：搭建CPU中的ALU结构，我觉得比较有难度的应该mulh、mul、mulhu，mul需要区分正负，而mulhu是算超位溢出，需要在草稿纸上演算一下，把32位分割为两个16位，注意进位的可能性，mulh是建立在mulhu的基础上做出来的；除此以外，sll、srl、sra这几个可以参考lab5的ex5，移动的思路是一致的
* Task2：搭建CPU中的RegFile结构，read用MUXer就能简单地解决，而write需要用regfile部件借助clock控制写入，注意每个regfile 的writeEn信号的获取需要借助DMUXer，当时没搞懂这个部件的使用方法，鼓捣了好久，简单说明就是一个input多个output，除了选择的通路出口外，其他出口均为默认值0
* Task3：搭建一个可以满足addi instruction运行的CPU结构，刚开始先用single-path，成功了再改成2个stage的pipelined CPU，IF算一个stage，ID以及以后的部分算为第二个stage，这个比较简单，完成这个只要用到imm_gen、Regfile、ALU三个部件就能够完成了。
* Task4: 这个project的主体部分，搭建CPU使它满足大概四十个指令的运行，主要的工作量在于control_logic信号的产生以及cpu面板各部件之间的连接，可以参考discussion8中那张图，简化成2 pipelined stage即可。容易出错的主要是一下几个方面：
  * 注意lw lb lh之间的差别，读取数据长度不同的，而CPU里面的DMEM结构默认是读取一个word，你需要用spliter进行分割
  * PC和instruction进入excute stage后都要用register储存下来
  * control logic中对instrution先用spliter分割，用comparater判断类型，得到0/1信号然后借助Bit Extender以及or和and逻辑门电路转化成相应的ALUSel、ImmSel、WBSel等信号对没有学过逻辑电路的我觉得还挺难的，我当时想不出来然后看了别人的画法弄懂了，明白了这个套路就画起来得心应手了
  * 由于是pipedpined stage，对于branch和juimp类型的instruction需要利用PCSel对进入错误的instruction进行kill
* Task5：自己写.s的测试文件，然后利用project自带的creater.py生成正确的输出和相应的machine code，和自己搭建的CPU运行结果进行比对，测试文件尽量覆盖所有的regfie以及instruction，这里可以借鉴前辈写的测试文件
* 测试Debug小技巧：project给的.cric文件有明显的父子级关联关系，打开一个父类的文件同时会加载子类文件，其中最高等级的应该是run.circ，所以debug的时候应该打开这个文件，打开machine code文件去掉十六进制的前缀后可以直接复制到IMEM中然后进行调试即可，但是注意在修改的时候必须单独打开子文件修改，我觉得调试的过程就是理解CPU运行逻辑的过程，非常的直观
* 其他的注意事项：我在写这个项目的时候windows中途出现了蓝屏然后重启以后.circ文件打不开了，导致这个project做到一半的时候我戴着痛苦面具又重新做了一遍，我强烈建议用github尽量每完成一个部分git commit一下，不然真的很伤，哭哭

![image-20210619113842619](F:\CS\picture\image-20210619113842619.png)


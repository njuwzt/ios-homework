# IOS 课程大作业

## 弹球小游戏



#### 1.游戏简介

+ 采用spritkit框架完成。

+ 玩家控制一块挡板，小球碰到挡板会根据速度和撞击挡板角度决定反弹方向反弹，小球撞到左右边界会反弹并加速，未接到小球的挡板一方视为输掉一局，即对方赢一分，赢到4分者获胜。



#### 2.代码文件说明

+ GameScene.swift: 游戏场景文件，包含所有游戏运行功能的实现。游戏界面内容的展现。

+ GameViewController.swift: 游戏界面控制器。

+ StartScene.swift: 游戏开始界面功能实现。

+ Sprites.swift: 封装了挡板类和小球类。

+ Fonts文件夹: 四种字体，在info.plist中引入。

  

#### 3.遇到的问题

+ 本来采用.sks文件的方式来生成scene，但是在虚拟机上一打开.sks文件xcode就闪退，于是转向无.sks文件方式生成scene。
+ 写到一半xcode11被误删了，结果虚拟机空间太小又下不回来，所幸xcode10可以安装，功能与xcode11没什么区别，可以适配代码。
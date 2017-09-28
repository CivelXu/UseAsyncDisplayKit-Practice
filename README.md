# AsyncDisplayKit 初窥

## 了解 AsyncDisplayKit

> AsyncDisplayKit的基本单位是节点 Node。一个Asdisplaynode 是 UIView 的抽象，反过来是CALayer抽象。与只能在主线程上使用的 UIView 视图不同，节点是线程安全的：您可以在后台线程上并行地实例化和配置它们的整个层次结构。
> 为了保持它的用户界面流畅和响应，你的应用程序应该以每秒60帧的速度呈现。这意味着主线程有六十分之一秒把每帧。这是16毫秒执行所有的布局和绘图代码！而且由于系统开销，您的代码通常不到十毫秒才能运行它导致帧下降。
> AsyncDisplayKit 让你 Image 解码、文本大小和渲染，布局，和其他昂贵的UI操作关闭主线程，让主线程可以响应用户交互。

这段话翻译于 **AsyncDisplayKit** GitHub 的介绍, 我们可以 通过 `CocoaPods` or ` Carthage` 安装使用; 另外 目前  AsyncDisplayKit 已经改名为 **Texture**。

关于 AsyncDisplayKit 的更多深层的理解, 本人参考了以下 文章


  * [AsyncDisplayKit介绍之一: 原理和思路](https://zhuanlan.zhihu.com/p/25371361)
  * [AsyncDisplayKit系列之二：布局系统](https://zhuanlan.zhihu.com/p/25371361)
  * [AsyncDisplayKit系列之三：深度优化列表性能](https://zhuanlan.zhihu.com/p/29537687)
  * [AsyncDisplaykit2.0使用「复杂界面流畅性」](http://www.jianshu.com/p/afc69cd9e824)
  * [AsyncDisplayKit 系列教程 —— 集成、示例](http://www.jianshu.com/p/e5761e9a7850)
  * [AsyncDisplayKit近一年的使用体会及疑难点](http://www.cocoachina.com/ios/20170809/20182.html)

## 使用

为了更加深入理解 AsyncDisplayKit 这个框架, 我尝试 进行 AsyncDisplayKit的简单使用
基于

**AsyncDisplayKit** 2.2.1 
**Swift** 4.0

###  ASTextNode

 ASTextNode 相当于 UILabel , 不同的是 它不能设置 text 只能设置 attributedText

  
```
 // MARK:- Use ASTextNode
    func buildTextNode(textContent: String)  {
        let textLabel = ASTextNode()
        if !textContent.isEmpty {
            textLabel.attributedText = NSAttributedString(string: textContent, attributes:
                [NSAttributedStringKey.foregroundColor : UIColor.white,
                 NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),
                 NSAttributedStringKey.backgroundColor : UIColor.black]
            )
        }

        let margin:CGFloat = 15
        let width:CGFloat = XW_SCREEN_WIDTH - margin * 2
        
        textLabel.layoutThatFits(ASSizeRange.init(min: CGSize.init(width: width, height: 30), max: CGSize.init(width: width, height: 300)))
        textLabel.frame = CGRect.init(x: margin, y: 90, width: textLabel.calculatedSize.width, height: textLabel.calculatedSize.height)
        
        self.view.addSubnode(textLabel)

    }
```


我们 可以使用 **layoutThatFits** 来自行计算, 自适应 label的内容 , ASSizeRange 来限定 最小 和最大的 size
然后, 设置frame 我们可以直接获取到  **calculatedSize** , 是不是 还是蛮方便的呢 ?
最后 使用 **.addSubnode** 代替 **.addSubView** 

### ASImageNode


```
    // MARK:- Use ASImageNode
    func buildImageNode(imageURLString: String) {
        let imageView = ASNetworkImageNode()
        imageView.frame = CGRect.init(x: 80, y: 400, width: 200, height: 200)
        imageView.backgroundColor = UIColor.green
        imageView.contentMode = .scaleAspectFill
        if !imageURLString.isEmpty {
            imageView.url = URL.init(string: imageURLString)
        }
        self.view.addSubnode(imageView)
    }
```

如果 你使用本地 的image 可能你只需要 使用 **ASImageNode**
但是加载 网络图片 就需要 使用到 **ASNetworkImageNode**

ASNetworkImageNode 默认用的缓存机制和图片下载器是 PinRemoteImage，为了使用我们自己的缓存机制和图片下载器，需要实现 ASImageCacheProtocol 图片缓存协议和 ASImageDownloaderProtocol 图片下载器协议两个协议

### ASButtonNode

```
 // MARK:- Use ASButtonNode
    func buildButtonNode(buttonName: String) {
        let buttonNode = ASButtonNode()
        if !buttonName.isEmpty {
            buttonNode.setTitle(buttonName, with: UIFont.systemFont(ofSize: 14), with: UIColor.black, for: UIControlState.normal)
        }
        buttonNode.backgroundColor = UIColor.yellow
        buttonNode.frame = CGRect.init(x: 80, y: 640, width: 200, height: 30)
        buttonNode.addTarget(self, action: #selector(clickedButton(sender:)), forControlEvents: .touchUpInside)
        self.view.addSubnode(buttonNode)
    }
```

需要 注意 ASButtonNode 继承于 ASControlNode 可以设置 add target, 有属性
`ASTextNode  * titleNode;` `ASImageNode * imageNode;` ` ASImageNode * backgroundImageNode;`

### ASControlNode

ASImageNode、ASButtonNode、ASTextNode 同为 ASControlNode 子类，可以直接使用 .addTarget(self, action: "handleXXX", forControlEvents: .TouchUpInside) 为它们添加点击响应事件，而避免使用addGesture等方法。
 
### ASTableNode

我们可以使用 ASTableNode 来 着力解决 UITableView 在 ReloadData 耗时长以及滑动卡顿的性能问题

初始化 `    let tableView = ASTableNode.init(style: UITableViewStyle.plain) `
代理  `ASTableViewDataSource, ASTableViewDelegate `


ASTableDataSource

```
 //MARK:- ASTableDataSource
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = CustomCellNode()
        return cellNode
     }
     
     .....
```

ASTableDataSource

```
 //MARK:-  ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
 
    }
 
    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
    
  }
  
  ..... 
```

需要注意 ASTableNode 的高度计算以及布局都在 ASCellNode 中实现，与 ASTableNode 是完全解耦的。
ASTableNode 中所有的元素都不支持 AutoLayout、AutoResizing，也不支持StoryBoard、IB。
ASTableNode 完全可以将滑动性能提升至60FPS。
ASTableNode 实质上是一个 ScrollView ，其中添加有指定数的 ASDisplayNode，在屏幕滚动时，离屏的ASDisplayNode内容会被暂时释放，在屏或接近在屏的ASDisplayNode会被提前加载。因此，ASTableView 不存在 Cell 复用的问题，也不存在任何 Cell 复用。
 
### ASCellNode

通常我们 自定义 UITableViewCell 是继承于 ASCellNode
执行以下步骤

 *  `override init()` 创建 对应 的 node, 添加进去
 *  添加数据 function
 *  `override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize` 计算控件宽度和高度，并返回 Cell 的高度, 我们一般 需要计算的 东西 都是在这个方法里面进行 `layoutThatFits`
 *  `override func layout()` 各个控件 进行布局 , 通常 调用 `calculatedSize` 进行 自适应布局

### ASDisplayNode

对于一些 不支持 的控件,  列如 UISlider, UISwitch, UIActivityIndicatorView, 并没有对应的 ASDisplayNode 子类实现。因此，我们需要创建一个 ASDisplayNode ，使用block方法返回;

这里以一个  `UIActivityIndicatorView` 为例

```
    let activityIndicator = ASDisplayNode.init(viewBlock: { () -> UIView in
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.backgroundColor = UIColor.clear
        view.hidesWhenStopped = true
        return view
    })
```

使用同样的方法，可以添加任意类型 UIView 到 CellNode 中，这样就不需要被 AsyncDisplayKit 束缚我们的应用了。

## 使用感想

首先, 本文只是对 AsyncDisplayKit 的一些基础 控件 进行初窥使用; 通过 Node 的使用方式 和 UIView 有着 相似 的一些 代码 特性; Node 会暴露 出 view 的一些基础属性 和 UIView 使用一样, 这令我们的学习成本 有一定降低; 一些不会明显暴露的属性,也可以通过 node.view 来获取到, 让初次接触 框架的人 比较容易上手。

其次, AsyncDisplayKit 是线程 绝对 安全的, 能保证 一些复杂的界面也稳定 60fps 运行, 开发者不比去考虑 Image 解码、文本大小和渲染等 带来的线程堵塞, 有利于程序的性能优化。 同事 使用 AsyncDisplayKit 来开发, 代码的条理 变得 清晰, 通过 ASCellNode 能够完全和 ASTableNode 进行解耦来看, 各种优点会让程序变得更加容易维护。

于此同时, AsyncDisplayKit 带来的负面影响也是不容忽视的;由于ASDK的基本理念是在需要创建UIView时替换成对应的Node来获取性能提升，因此对于现有代码改动较大，侵入性较高，同时由于大量原本熟悉的操作变成了异步的，对于一个团队来说学习曲线也较为陡峭。

AsyncDisplayKit 不支持 AutoLayout、AutoResizing，也不支持StoryBoard、IB。这 似乎 与 Apple 的理念相违背; Apple 是鼓励使用 可视化进行编程的。

综合来分析, AsyncDisplayKit 是一个非常的不错框架; 考虑到AsyncDisplayKit的种种好处，非常推荐AsyncDisplayKit，当然还是仅限于用在比较复杂和动态的页面中。不需要也不可能将所有UIView都替换成其Node版本。将注意力集中在可能造成主线程阻塞的地方，如tableView/collectionView、复杂布局的View、使用连续手势的操作等等。  

## Link 

* [个人博客](http://civelxu.com/2017/09/28/AsyncDisplayKit%20%E5%88%9D%E7%AA%A5/)
* [简书](http://www.jianshu.com/p/fde96c5bc43f)
* [GitHub Code](https://github.com/CivelXu/UseAsyncDisplayKit-Practice)


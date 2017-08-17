# Snippet from stackoverflow to invoke a click() d3 will recognise
jQuery.fn.d3Click = () ->
    this.each( (i, e) ->
        evt = document.createEvent("MouseEvents")
        evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null)

        e.dispatchEvent(evt)
    )

template = "<div class='popover'>          <div class='arrow'></div>          <h3 class='popover-title'></h3>          <div class='popover-content'></div>          <nav class='popover-navigation'>            <div class='btn-group'>              <button class='btn btn-sm btn-default' data-role='prev'>&laquo; Prev</button>              <button class='btn btn-sm btn-default' data-role='next'>Next &raquo;</button>            </div>            <button class='btn btn-sm btn-default' data-role='end'>End tour</button>          </nav>        </div>"

tour_steps =
  [
    title: "<strong>Degust</strong>"
    content: "Degust的基本功能是对基因差异表达数据的可视化。你可以为显著性（可信度）设置不同的参数，然后观察MA图、平行坐标图以及热图的同步变化。你可以指定显示特定基因的数据，然后下载对应的表格。"
    orphan: true
    backdrop: true
  ,
    element: '.conditions'
    placement: 'right'
    title:"<strong>选择实验条件</strong>"
    content: "选定你需要进行比较的实验组。改变这里的选项会使服务器重新运行分析流程。"
  ,
    element: '#expression .nav'
    placement: 'bottom'
    title:"<strong>选择绘图类型</strong>"
    content: "选择'Parallel Coordinates'或者'MA plot'。MA图更适合只有两个条件的数据可视化；平行坐标图对多条件的可视化很有用。"
  ,
    element: '#heatmap'
    placement: 'top'
    title:"<strong>热图</strong>"
    content: "<p>热图区域显示上方图中每个基因的log fold-change值，每个垂直条带对应一个基因。当聚类的基因数量很多时可能会显示得比较慢。</p><p>将鼠标悬停在热图上可以在上方图中高亮对应的基因。</p>"
  ,
    element: '#grid'
    placement: 'top'
    title:"<strong>基因统计表</strong>"
    content: "表格中包含上方图中过滤后的基因。<ul><li>可以点击表头进行排序<li>右边输入关键词查找特定基因<li>双击某一行可以打开该基因的外部链接。</ul>"
    template: () -> $(template).addClass('wide')
  ,
    element: '.fdr-fld'
    placement: 'left'
    title:"<strong>FDR阈值</strong>"
    content: "修改错误发现率(False Discovery Rate)阈值。左侧的绘图以及下方的列表会随着设置改变而动态变化。"
  ,
    element: '.fc-fld'
    placement: 'left'
    title:"<strong>Log fold-change阈值</strong>"
    content: "修改变化倍率对数(log fold-change)的绝对值阈值，图表也会同步变化。比如，设为<b>1.0</b>会只显示在任意两两实验条件下该绝对值大于1.0（也即2x上调或下调）的基因。"
  ,
    element: '#csv-download'
    placement: 'left'
    backdrop: true
    title:"下载基因列表"
    content: "下载包含所有显示在列表中基因的CSV数据文件。"
  ,
    onShow: () -> $('#select-ma a').click()
    element: '#dge-ma'
    placement: 'bottom'
    title: "<strong>MA图</strong>"
    content: "<p>MA图仅显示双条件下的表达量信息（在设置中指定），图中每个点代表一个基因。X轴代表平均表达量，y轴代表该条件下的变化量数值。</p><p>你可以用鼠标框选某些基因，这样下方的热图和表格会只显示选中的部分，点击图上任意位置取消框选。</p><p>点的颜色标志FDR大小，越偏向红色越显著，反之越偏向蓝色越不显著。</p>"
    template: () -> $(template).addClass('wide')
  ,
    onShow: () -> $('#select-pc a').click()
    element: '#dge-pc'
    placement: 'bottom'
    title: "<strong>平行坐标图</strong>"
    content: "<p>每条红/蓝线代表一个基因，每个轴代表一个条件组，所以线条代表的是基因在组间的相对表达量。</p><p>你可以框选轴上的某个区域，从而过滤出FC值位于该区域的基因，点击框选区以外地方撤销过滤。每个轴都可以独立地选定区域</p><p>拖拽列的标题可以对各个条件组重新排序。</p><p>线的颜色代表FDR大小，越偏红越显著，越偏蓝越不显著。</p>"
    template: () -> $(template).addClass('wide')
  ,
    element: '.kegg-filter'
    placement: 'left'
    title: "<strong>Kegg过滤器</strong>"
    content: '<p>通过已注释的KEGG通路信息过滤基因。</p><p>每个通路旁的数字代表你的数据集中注释到该通路的基因个数，选择某一项可以过滤出这些基因，并且显示对应的通路图。图片可能被缩放，你可以把鼠标悬停在EC号上观察对应的被注释基因。</p><p>EC号颜色含义：蓝色=无改变，绿色=全部上调，红色=全部下调，黄色=上下调皆有。</p><p>这个KEGG数据来自2007年。如果你觉得这个功能很重要，建议你购买<a href="http://www.bioinformatics.jp/en/keggftp.html">KEGG subscription</a>并且在本地运行Degust服务。</p>'
    template: () -> $(template).addClass('wide')

  ]

window.setup_tour = (show_tour) ->
    tour = new Tour(steps: tour_steps)    #({debug: true})
    #window.tour = tour
    tour.init()
    $('a#tour').click(() -> tour.restart())
    tour.start() if show_tour

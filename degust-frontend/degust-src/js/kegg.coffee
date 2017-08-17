# This class handles the drawing and highlighting of kegg pathway images
# Images are just kegg gif images, with the xml definitions used for location of "box" highlighting
class Kegg
    constructor: (@opts) ->
        @ec_visible = {}

    load: (org, code, @ec_colours, ec_cb) ->
        #console.log ec_colours
        @img_x = undefined
        @kegg_data = undefined

        @img_url = "http://rest.kegg.jp/get/#{org}#{code}/image"
        # @img_url = "kegg/pathway/map/map#{code}.gif"
        $(@opts.elem).html("<div id='kegg-container'></div>")

        # Load the image to get the size
        $("<img/>") # Make in memory copy of image to avoid css issues
           .attr("src", @img_url)
            .load((e) =>
                @img_x = e.target.width
                @img_y = e.target.height
                #console.log(@img_x,@img_y)
                @draw_ec()
                )

        d3.xml("kegg/kgml/#{org}/#{code}.xml", (data) => @xml_loaded(data, ec_cb))

    xml_loaded: (xml, ec_cb) ->
        @kegg_data = @xml_to_list(xml)
        if ec_cb
            ec_codes=[]
            ec_codes = @kegg_data.map (o) -> o.id
            ec_cb(ec_codes) if ec_cb

        @draw_ec()

    draw_ec: () ->
        return if !@kegg_data || !@img_x
        #console.log "drawing"
        d3.select('div#kegg-container').html('')
        @svg = d3.select('div#kegg-container')
                 .append('svg')
                 .attr('viewBox',"1 1 #{@img_x} #{@img_y}")
                 .attr('width','100%')
                 .attr('height','100%')
        @svg.append('image').attr('xlink:href',@img_url)
                            .attr('width',@img_x)
                            .attr('height',@img_y)

        ec_boxes = @svg.selectAll('.ec').data(@kegg_data, (o) -> o.x+o.y)
        ec_boxes.enter().append('rect').attr('class','ec')
             .attr('x', (o) -> o.x - o.width/2)
             .attr('y', (o) -> o.y - o.height/2)
             .attr('width',  (o) -> o.width)
             .attr('height', (o) -> o.height)
             .attr('stroke','black')
             .attr('fill-opacity',0.6)
             .attr('fill', (o) => @colour(o.id))

        ec_boxes.exit().remove()

        ec_boxes.on('mouseover', @opts.mouseover) if @opts.mouseover
        ec_boxes.on('mouseout', @opts.mouseout) if @opts.mouseout

    rect: (o) ->
        g.append('rect')

    xml_to_list: (xml) ->
        list = []
        $('entry[type=enzyme] graphics,entry[type=gene] graphics',xml).each (i,e_) =>
            e=$(e_)
            o = {id: e.parent().attr('name') }
            t = o.id.split(/(?:^|\s)\w+:(?:Dmel_)?/)
            for h in t
                if h && h of @ec_colours
                    if c = e.attr('coords')
                        ca = c.split(',')
                        e.attr('x',ca[0]).attr('y',ca[1]).attr('width',20).attr('height',20)
                    for k in ['x','y','width','height']
                        o[k] = e.attr(k)
                    list.push o
        return list

    colour: (ec) ->
        t = ec.split(/(?:^|\s)\w+:(?:Dmel_)?/)
        n = 0
        for h in t
            if h
                switch @ec_colours[h]
                    when 'up' then n++
                    when 'down' then n--
        if n > 0 then 'red' else 'blue'

    highlight: (ec) ->
        if @svg
            @svg.selectAll('.ec').filter((o) -> o.id.indexOf(ec) >= 0).attr('stroke-width',5).attr('stroke','red')
    unhighlight: () ->
        if @svg
            @svg.selectAll('.ec').attr('stroke-width',1).attr('stroke','black')


window.Kegg = Kegg

$headings =
  year: $ "header, #main h2, footer"
  camp: $ "#main h3"

$scroller = $ "html, body"

$container = $ "#navigations"

$window = $ window

waitMouseMove = waitTransition = null


html = """<li class="year" data-year="↑">
            <div class="inneryear">TOP</div>
          </li>"""

for $h, i in $ "#main h2, #main h3"
  if $h.tagName is "H2"
    if i isnt 0
      html +="  </ul>\n</li>\n"
    t = $h.innerText
    tn = parseInt t
    html += """
    <li class="year" data-year="#{
      unless isNaN tn
        "'#{tn.toString().slice -2}"
      else
        t.slice 0, 1
      }">
      <div class="inneryear">#{t}</div>
      <ul class="outerCamp">\n
    """
  else if $h.tagName is "H3"
    html += "    <li class='camp'>#{$h.innerText}</li>\n"

html += """</ul>\n</li>
            <li class="year" data-year=" ">
              <div class="inneryear">Thanks</div>
            </li>"""

headingTops = for el, i in $headings.year
  $(el).offset().top

headingTops.shift 0

open = (index)->
  $this = if typeof index is "number"
    console.log index
    do close
    $container
    .find ".year:eq(#{index})"
    .addClass "opened"
  else
    $ this
    .data "hover", true

  unless do $this.width
    $this.css width: $this.data "autoWidth"

close = (e)->
  $this = if e?
    $ this
    .data "hover", false
  else
    $container
    .find ".year.opened"
    .removeClass "opened"

  console.log $this[0], $this.data "hover"
  unless $this.hasClass("opened") or $this.data("hover")
    $this
    .css width: 0
    .children ".outerCamp"
    .css visibility: "hidden"

$container.html html
.on "mouseenter", ".year", open
.on "mouseleave", ".year", close
.on "mouseenter", ".inneryear, .outerCamp", ->
  clearTimeout waitMouseMove
  clearTimeout waitTransition
  $outer = $(this).closest ".year"
  $outerCamp = $outer.children ".outerCamp"
  unless $outerCamp.length
    return
  $lastCamp = $outerCamp.children ":last"
  height = $lastCamp.position().top + do $lastCamp.innerHeight

  $outer.css width: do $outerCamp.innerWidth + 2
  t = $outer.css "transition-duration"
  
  waitTransition = setTimeout ->
    $outerCamp.css
      visibility: "visible"
      height: height
  , parseFloat(t) * 1000

.on "mouseleave", ".inneryear, .outerCamp", ->
  clearTimeout waitTransition
  waitMouseMove = setTimeout =>
    $outer = $(this).closest ".year"
    $outerCamp = $outer.children ".outerCamp"
    unless $outerCamp.length
      return
    
    t = $outerCamp
    .css height: 0
    .css "transition-duration"

    waitTransition = setTimeout ->
      $outerCamp.css visibility: "hidden"
      if $outer.is ":hover, .opened"
        $outer.css width: $outer.data "autoWidth"

    , parseFloat(t) * 1000
  ,100

.on "click", "li", ->
  target = if this.classList.contains "year" then "year" else "camp"
  index = $container.find "li.#{target}"
  .index this
  top = $headings[target]
    .eq index
    .offset()
    .top
  $scroller.animate scrollTop: top, 200
  no

.children ".year"
.each ->
  $this = $ this
  $this.data "autoWidth",
    do $this
    .children ".inneryear"
    .innerWidth



opened = null
$window.on "scroll", (e)->
  scrollTop = do $window.scrollTop
  console.log scrollTop
  seeing = 0
  for top, i in headingTops
    if top >= scrollTop
      seeing = i
      break

  if seeing isnt opened
    open seeing

  opened = seeing

$window.trigger "scroll"

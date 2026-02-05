// =============================================================================
// Korean Report Typst Template - Main Show File
// =============================================================================

// =============================================================================
// FontAwesome 아이콘 함수 (Quarto callout용)
// =============================================================================
#let fa-lightbulb() = [💡]
#let fa-info() = [ℹ️]
#let fa-info-circle() = [ℹ️]
#let fa-exclamation-triangle() = [⚠️]
#let fa-exclamation() = [⚠️]
#let fa-exclamation-circle() = [❗]
#let fa-times-circle() = [❌]
#let fa-times() = [❌]

// =============================================================================
// Callout 함수 정의
// =============================================================================
#let callout(
  body: [],
  title: "Callout",
  background_color: rgb("#dddddd"),
  icon: none,
  icon_color: black,
  body_background_color: white
) = {
  block(
    fill: luma(248),
    stroke: (left: 3pt + rgb("#1a5490")),
    width: 100%,
    inset: (left: 16pt, right: 14pt, top: 12pt, bottom: 12pt),
    breakable: true,
    [
      #if icon != none [
        #box(height: 1em)[
          #text(fill: rgb("#1a5490"), size: 1em)[#icon]
        ]
        #h(0.4em)
      ]
      #text(weight: "bold", size: 11pt, fill: rgb("#1a5490"))[#title]
      #v(0.6em)
      #text(size: 10.5pt)[#body]
    ]
  )
}

// =============================================================================
// 본문 기본 설정 (한국 보고서 표준)
// =============================================================================
#set text(
  size: $if(fontsize)$$fontsize$$else$11pt$endif$,
  lang: "$if(lang)$$lang$$else$ko$endif$",
  region: "KR",
  font: "$if(mainfont)$$mainfont$$else$Pretendard$endif$"
)

// 본문 단락 스타일
#set par(
  leading: 1.0em,
  spacing: 1.2em,
  justify: true,
  first-line-indent: 0pt
)

// 섹션 번호 형식
$if(number-sections)$
#set heading(numbering: "1.1.1")
$else$
#set heading(numbering: none)
$endif$

// =============================================================================
// 헤딩 스타일
// =============================================================================
#show heading.where(level: 1): it => {
  v(2em)
  text(size: 18pt, weight: "bold", fill: rgb("#1a5490"))[
    $if(number-sections)$
    #counter(heading).display()
    #h(0.5em)
    $endif$
    #it.body
  ]
  v(0.3em)
  line(length: 100%, stroke: 1.5pt + rgb("#1a5490"))
  v(1em)
}

#show heading.where(level: 2): it => {
  v(1.5em)
  text(size: 14pt, weight: "bold", fill: rgb("#2c3e50"))[
    $if(number-sections)$
    #counter(heading).display()
    #h(0.5em)
    $endif$
    #it.body
  ]
  v(0.5em)
}

#show heading.where(level: 3): it => {
  v(1.2em)
  text(size: 12pt, weight: "bold", fill: rgb("#34495e"))[
    $if(number-sections)$
    #counter(heading).display()
    #h(0.5em)
    $endif$
    #it.body
  ]
  v(0.4em)
}

#show heading.where(level: 4): it => {
  v(1em)
  text(size: 11pt, weight: "bold", fill: rgb("#555555"))[
    $if(number-sections)$
    #counter(heading).display()
    #h(0.5em)
    $endif$
    #it.body
  ]
  v(0.3em)
}

// =============================================================================
// 목록 스타일
// =============================================================================
#set list(
  spacing: 0.6em,
  tight: true,
  marker: [•],
  body-indent: 1em
)

#set enum(
  spacing: 0.6em,
  tight: true,
  body-indent: 1em
)

#show list: it => {
  v(0.1em)
  it
  v(0.4em)
}

#show enum: it => {
  v(0.1em)
  it
  v(0.4em)
}

// =============================================================================
// 테이블 스타일
// =============================================================================
#show table: it => {
  set text(size: 10pt)
  v(0.8em)
  it
  v(0.8em)
}

// =============================================================================
// 인용문 스타일
// =============================================================================
#set quote(block: true)
#show quote: it => {
  block(
    inset: (left: 1.5em, right: 1em, top: 0.5em, bottom: 0.5em),
    stroke: (left: 3pt + luma(200)),
    [
      #text(style: "italic", fill: luma(80))[#it.body]
    ]
  )
}

// =============================================================================
// 강조 텍스트
// =============================================================================
#show strong: set text(fill: rgb("#1a5490"))

// =============================================================================
// 수평선 (Horizontal Rule)
// =============================================================================
#let horizontalrule = {
  v(0.5em)
  line(length: 100%, stroke: 0.5pt + luma(180))
  v(0.5em)
}

// =============================================================================
// 코드 블록 스타일
// =============================================================================
#show raw.where(block: true): it => {
  block(
    fill: luma(245),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    [#text(size: 9pt)[#it]]
  )
}

#show raw.where(block: false): it => {
  box(
    fill: luma(240),
    inset: (x: 4pt, y: 2pt),
    radius: 2pt,
    [#text(size: 10pt)[#it]]
  )
}

// =============================================================================
// 페이지 설정
// =============================================================================
#set page(
  paper: "$if(papersize)$$papersize$$else$a4$endif$",
  margin: (
    $if(margin)$
    $if(margin.x)$x: $margin.x$,$endif$
    $if(margin.y)$y: $margin.y$,$endif$
    $if(margin.top)$top: $margin.top$,$endif$
    $if(margin.bottom)$bottom: $margin.bottom$,$endif$
    $if(margin.left)$left: $margin.left$,$endif$
    $if(margin.right)$right: $margin.right$,$endif$
    $else$
    x: 2cm,
    y: 2cm,
    $endif$
  ),
  numbering: "1",
)

// =============================================================================
// 문서 메타데이터
// =============================================================================
#set document(
  title: "$title$",
  $if(author)$author: ($for(author)$"$author$"$sep$, $endfor$),$endif$
  $if(date)$date: auto,$endif$
)

// =============================================================================
// 커버 페이지 (Tufte 스타일)
// =============================================================================
$if(title)$
#import "cover.typ": tufte_cover

#tufte_cover(
  title: "$title$",
  $if(subtitle)$subtitle: "$subtitle$",$endif$
  $if(author)$author: "$for(author)$$author$$sep$, $endfor$",$endif$
  $if(cover-date)$date: "$cover-date$",$else$date: datetime.today().display("[year]년 [month]월 [day]일"),$endif$
  logo: image("logo.svg", width: 60pt),
  accent_color: rgb("#1a5490"),
)

#set page(margin: (
  $if(margin)$
  $if(margin.x)$x: $margin.x$,$endif$
  $if(margin.y)$y: $margin.y$,$endif$
  $if(margin.top)$top: $margin.top$,$endif$
  $if(margin.bottom)$bottom: $margin.bottom$,$endif$
  $if(margin.left)$left: $margin.left$,$endif$
  $if(margin.right)$right: $margin.right$,$endif$
  $else$
  x: 2cm,
  y: 2cm,
  $endif$
))

$endif$

// =============================================================================
// 목차
// =============================================================================
$if(toc)$
#text(size: 22pt, weight: "bold", fill: rgb("#1a5490"))[목 차]
#v(8pt)
#line(length: 100%, stroke: 2.5pt + rgb("#1a5490"))
#v(20pt)
#outline(
  title: none,
  depth: $if(toc-depth)$$toc-depth$$else$3$endif$,
  indent: auto
)
#pagebreak()
$endif$

// =============================================================================
// 본문
// =============================================================================
$body$

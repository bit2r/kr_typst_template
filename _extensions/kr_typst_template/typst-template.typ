// =============================================================================
// Korean Report Typst Template
// 한국 보고서 스타일 정의 (공식 보고서 표준 준수)
// =============================================================================

// =============================================================================
// 본문 기본 설정 (한국 보고서 표준)
// =============================================================================
#set text(
  size: 11pt,
  lang: "ko",
  region: "KR"
)

// 본문 단락 스타일: 행간 170%, 양쪽 정렬
#set par(
  leading: 1.0em,        // 행간 (줄 간격)
  spacing: 1.2em,        // 문단 간격
  justify: true,         // 양쪽 정렬
  first-line-indent: 0pt // 첫줄 들여쓰기 없음 (보고서 스타일)
)

// =============================================================================
// Grayscale Callout (강조 박스)
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
// 목차 제목
// =============================================================================
#let toc_title() = [
  #align(left)[
    #text(size: 22pt, weight: "bold", fill: rgb("#1a5490"))[목 차]
    #v(8pt)
    #line(length: 100%, stroke: 2.5pt + rgb("#1a5490"))
    #v(20pt)
  ]
]

// =============================================================================
// 섹션 번호 형식 (한국식: 1. 1.1 1.1.1)
// =============================================================================
#set heading(numbering: "1.1.1")

// =============================================================================
// 헤딩 스타일 (한국 보고서 표준)
// =============================================================================
// H1: 18pt 굵게, 파란색, 상단 여백 크게
#show heading.where(level: 1): it => {
  v(2em)
  text(size: 18pt, weight: "bold", fill: rgb("#1a5490"))[#it.body]
  v(0.3em)
  line(length: 100%, stroke: 1.5pt + rgb("#1a5490"))
  v(1em)
}

// H2: 14pt 굵게, 진한 회색
#show heading.where(level: 2): it => {
  v(1.5em)
  text(size: 14pt, weight: "bold", fill: rgb("#2c3e50"))[#it.body]
  v(0.5em)
}

// H3: 12pt 굵게, 중간 회색
#show heading.where(level: 3): it => {
  v(1.2em)
  text(size: 12pt, weight: "bold", fill: rgb("#34495e"))[#it.body]
  v(0.4em)
}

// H4: 11pt 굵게 (본문과 같은 크기)
#show heading.where(level: 4): it => {
  v(1em)
  text(size: 11pt, weight: "bold", fill: rgb("#555555"))[#it.body]
  v(0.3em)
}

// =============================================================================
// 목록(리스트) 스타일
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

// 리스트 앞뒤 여백 (제목과 리스트 사이 간격)
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
// 테이블 스타일 (GT 테이블 포함)
// =============================================================================
#show table: it => {
  set text(size: 10pt, font: "Pretendard")
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
// 목차 항목 스타일
// =============================================================================
#show outline.entry.where(level: 1): it => {
  v(10pt)
  text(size: 12pt, weight: "bold", fill: rgb("#1a5490"))[#it]
}

#show outline.entry.where(level: 2): it => {
  v(6pt)
  text(size: 11pt, fill: rgb("#2c3e50"))[#it]
}

#show outline.entry.where(level: 3): it => {
  v(4pt)
  text(size: 10pt, fill: rgb("#555555"))[#it]
}

// =============================================================================
// 강조 텍스트
// =============================================================================
#show strong: set text(fill: rgb("#1a5490"))

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

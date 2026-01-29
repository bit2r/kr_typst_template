// =============================================================================
// Tufte-style Cover Page Template
// 미니멀하고 우아한 표지 디자인
// =============================================================================

#let tufte_cover(
  title: "보고서 제목",
  subtitle: none,
  author: none,
  date: none,
  logo: none,
  accent_color: rgb("#1a5490"),
) = {
  set page(
    margin: 0pt,
    background: none,
  )

  // 전체 페이지 컨테이너
  place(
    top + left,
    dx: 0pt,
    dy: 0pt,
    block(
      width: 100%,
      height: 100%,
      fill: white,
      {
        // 상단 로고 (있는 경우)
        if logo != none {
          place(
            top + right,
            dx: -40pt,
            dy: 40pt,
            logo
          )
        }

        // 좌측 얇은 수직선 (Tufte 스타일 강조)
        place(
          left + top,
          dx: 60pt,
          dy: 0pt,
          line(
            start: (0pt, 0pt),
            end: (0pt, 100%),
            stroke: 0.5pt + accent_color.lighten(30%)
          )
        )

        // 메인 컨텐츠 영역 (좌측 정렬, 여백 활용)
        place(
          left + horizon,
          dx: 80pt,
          dy: -60pt,
          {
            // 제목 (폰트 크기 조정 + 너비 제한)
            block(
              width: 90%,
              text(
                size: 36pt,
                weight: "light",
                fill: black,
                font: "Pretendard",
                hyphenate: false,
              )[#title.replace("\\_", "_")]
            )

            // 제목 하단 얇은 선
            v(16pt)
            line(
              length: 200pt,
              stroke: 1pt + accent_color
            )

            // 부제목
            if subtitle != none {
              v(24pt)
              text(
                size: 20pt,
                weight: "regular",
                fill: rgb("#555555"),
                font: "Pretendard",
                subtitle
              )
            }

            // 저자
            if author != none {
              v(48pt)
              text(
                size: 14pt,
                weight: "regular",
                fill: rgb("#666666"),
                font: "Pretendard",
                author
              )
            }
          }
        )

        // 하단 날짜 (있는 경우)
        if date != none {
          place(
            bottom + left,
            dx: 80pt,
            dy: -60pt,
            {
              text(
                size: 11pt,
                fill: rgb("#888888"),
                font: "Pretendard",
                date
              )

              // 하단 얇은 선
              v(8pt)
              line(
                length: 120pt,
                stroke: 0.5pt + rgb("#cccccc")
              )
            }
          )
        }

        // 우측 하단 여백 (Tufte 스타일)
      }
    )
  )

  pagebreak()
}

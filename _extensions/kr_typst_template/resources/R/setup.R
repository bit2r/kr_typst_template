# =============================================================================
# Korean Report Typst Extension - R Setup
# =============================================================================
# 이 스크립트는 kr-report-typst extension에서 사용하는 R 환경을 설정합니다.
#
# 사용법:
#   source("_extensions/kr-report-typst/resources/R/setup.R")
# =============================================================================

# =============================================================================
# 공통 라이브러리
# =============================================================================
library(tidyverse)
library(gt)
library(scales)
library(showtext)
library(ggrepel)
library(ggthemes)

# =============================================================================
# Extension 경로 Helper 함수
# =============================================================================
get_extension_path <- function(resource = "") {
  # Extension 기본 경로
  ext_base <- "_extensions/kr_typst_template/resources"

  # 리소스 경로 결합
  if (resource == "") {
    return(ext_base)
  } else {
    return(file.path(ext_base, resource))
  }
}

# =============================================================================
# 폰트 설정 (showtext 사용)
# =============================================================================
# Pretendard 폰트를 ggplot2에서 사용할 수 있도록 등록
# Typst PDF 출력에서는 font-paths 설정으로 폰트가 자동 적용됨

tryCatch({
  # showtext로 폰트 등록
  font_add(
    family = "Pretendard",
    regular = get_extension_path("fonts/Pretendard-Regular.ttf"),
    bold = get_extension_path("fonts/Pretendard-Bold.ttf")
  )

  # showtext 자동 활성화
  showtext_auto()

  message("✓ Pretendard font registered successfully with showtext")
}, error = function(e) {
  warning("Failed to register Pretendard font: ", e$message)
  warning("Charts may not render Korean text correctly")
})

# =============================================================================
# 커스텀 Tufte 테마 (ggthemes::theme_tufte 기반)
# =============================================================================
theme_tufte_kr <- function(base_size = 16, base_family = "Pretendard") {
  ggthemes::theme_tufte(base_size = base_size, base_family = base_family) +
    theme(
      text = element_text(family = base_family),
      plot.title = element_text(face = "bold", hjust = 0),
      axis.title = element_text(face = "plain"),
      legend.position = "bottom",
      legend.title = element_blank()
    )
}

# 기본 테마로 설정
theme_set(theme_tufte_kr())

# =============================================================================
# GT 테이블용 Tufte 스타일 테마
# =============================================================================
gt_theme_tufte <- function(gt_tbl) {
  gt_tbl %>%
    opt_table_font(font = list(google_font("Noto Sans KR"), "Pretendard", default_fonts())) %>%
    cols_align(align = "center") %>%
    tab_options(
      table.border.top.style = "hidden",
      table.border.bottom.style = "hidden",
      table_body.border.bottom.color = "#333333",
      column_labels.border.top.color = "#333333",
      column_labels.border.top.width = px(2),
      column_labels.border.bottom.color = "#333333",
      column_labels.border.bottom.width = px(1),
      column_labels.font.weight = "bold",
      row_group.border.top.style = "hidden",
      row_group.border.bottom.style = "hidden"
    )
}

# =============================================================================
# 설정 완료 메시지
# =============================================================================
message("✓ kr-report-typst extension R environment loaded")
message("  - theme_tufte_kr() set as default ggplot2 theme")
message("  - gt_theme_tufte() available for tables")

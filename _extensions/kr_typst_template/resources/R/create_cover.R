# =============================================================================
# 표지 이미지 자동 생성 함수 (kr-report-typst extension)
# =============================================================================
# 사용법:
#   source("_extensions/kr-report-typst/resources/R/create_cover.R")
#   create_cover(
#     title = "2026 연간 보고서",
#     subtitle = "주요 성과 및 전망",
#     output_path = "cover.png"
#   )
# =============================================================================

library(magick)
library(sysfonts)
library(showtext)
library(grid)

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

# showtext로 Pretendard 폰트 등록
register_pretendard_font <- function() {

  fonts_dir <- get_extension_path("fonts")

  # Pretendard 폰트 파일들 찾기
  font_files <- list.files(fonts_dir, pattern = "Pretendard.*\\.ttf$", full.names = TRUE)

  if (length(font_files) == 0) {
    warning("Pretendard 폰트 파일을 찾을 수 없습니다: ", fonts_dir)
    return(FALSE)
  }

  # Regular, Bold 파일 찾기
  regular_file <- font_files[grepl("Regular", font_files, ignore.case = TRUE)][1]
  bold_file <- font_files[grepl("Bold", font_files, ignore.case = TRUE) &
                          !grepl("SemiBold|ExtraBold", font_files, ignore.case = TRUE)][1]

  # 파일이 없으면 첫 번째 파일 사용
  if (is.na(regular_file)) regular_file <- font_files[1]
  if (is.na(bold_file)) bold_file <- regular_file

  # 이미 등록되어 있는지 확인
  if ("Pretendard" %in% font_families()) {
    showtext_auto()
    return(TRUE)
  }

  # sysfonts/showtext로 폰트 등록
  tryCatch({
    font_add(
      family = "Pretendard",
      regular = regular_file,
      bold = bold_file
    )
    showtext_auto()
    message("Pretendard 폰트 등록 완료: ", regular_file)
    return(TRUE)
  }, error = function(e) {
    warning("폰트 등록 실패: ", e$message)
    return(FALSE)
  })
}

# A4 크기 (300 DPI 기준)
A4_WIDTH_PX <- 2480   # 210mm * 300dpi / 25.4
A4_HEIGHT_PX <- 3508  # 297mm * 300dpi / 25.4

#' 표지 이미지 생성
#'
#' 배경 이미지 위에 제목, 부제목, 날짜, 로고를 추가하여 표지를 생성합니다.
#' sysfonts + showtext 방식으로 한글 폰트를 지원합니다.
#'
#' @param title 메인 제목 (큰 글씨)
#' @param subtitle 부제목 (작은 글씨)
#' @param date 작성일 (기본값: 오늘 날짜)
#' @param background_path 배경 이미지 경로 (기본값: extension defaults)
#' @param logo_path 로고 이미지 경로 (기본값: extension defaults)
#' @param output_path 출력 파일 경로
#' @param title_size 제목 폰트 크기 (기본값: 40)
#' @param subtitle_size 부제목 폰트 크기 (기본값: 24)
#' @param date_size 날짜 폰트 크기 (기본값: 16)
#' @param text_color 텍스트 색상 (기본값: "white")
#'
#' @return 생성된 이미지 경로
#' @export
create_cover <- function(
    title = "보고서 제목",
    subtitle = "부제목",
    date = format(Sys.Date(), "%Y년 %m월 %d일"),
    background_path = NULL,
    logo_path = get_extension_path("logo.svg"),
    output_path = "cover.png",
    title_size = 40,
    subtitle_size = 24,
    date_size = 16,
    text_color = "white"
) {
  # ---------------------------------------------------------------------------
  # 0. 폰트 등록
  # ---------------------------------------------------------------------------
  register_pretendard_font()

  # ---------------------------------------------------------------------------
  # 1. 배경 이미지 로드 및 A4 크기로 조정
  # ---------------------------------------------------------------------------
  if (!file.exists(background_path)) {
    stop("배경 이미지를 찾을 수 없습니다: ", background_path)
  }

  base_image <- image_read(background_path)

  # A4 비율로 크롭 후 리사이즈 (cover 방식: 꽉 채우고 넘치는 부분 자름)
  base_image <- image_resize(base_image, paste0(A4_WIDTH_PX, "x", A4_HEIGHT_PX, "^"))
  base_image <- image_crop(base_image, paste0(A4_WIDTH_PX, "x", A4_HEIGHT_PX), gravity = "center")

  img_info <- image_info(base_image)
  img_width <- img_info$width
  img_height <- img_info$height

  # ---------------------------------------------------------------------------
  # 2. 로고 추가 (우측 상단)
  # ---------------------------------------------------------------------------
  if (!is.null(logo_path) && file.exists(logo_path)) {
    logo_width <- as.integer(img_width * 0.10)
    logo_height <- as.integer(img_height * 0.05)
    logo <- load_logo(logo_path, target_width = logo_width, target_height = logo_height)

    if (!is.null(logo)) {
      logo_info <- image_info(logo)
      logo_x <- img_width - logo_info$width - 20
      logo_y <- 20
      logo_position <- paste0("+", logo_x, "+", logo_y)

      base_image <- image_composite(
        image = base_image,
        composite_image = logo,
        operator = "over",
        offset = logo_position
      )
    }
  }

  # ---------------------------------------------------------------------------
  # 3. 텍스트 오버레이 생성 (grid + showtext)
  # ---------------------------------------------------------------------------
  temp_text_file <- tempfile(fileext = ".png")

  # png 디바이스 열기
  png(
    filename = temp_text_file,
    width = A4_WIDTH_PX,
    height = A4_HEIGHT_PX,
    res = 300,
    bg = "transparent",
    type = "cairo"
  )

  # showtext 활성화 (디바이스 열린 후)
  showtext_begin()

  # grid로 텍스트 직접 그리기
  grid.newpage()

  # 제목 (굵게)
  grid.text(
    label = title,
    x = unit(0.08, "npc"),
    y = unit(0.88, "npc"),
    hjust = 0, vjust = 1,
    gp = gpar(
      fontfamily = "Pretendard",
      fontface = "bold",
      fontsize = title_size * 2.83,  # pt to pixel 변환 (300dpi 기준)
      col = text_color
    )
  )

  # 부제목
  grid.text(
    label = subtitle,
    x = unit(0.08, "npc"),
    y = unit(0.82, "npc"),
    hjust = 0, vjust = 1,
    gp = gpar(
      fontfamily = "Pretendard",
      fontface = "plain",
      fontsize = subtitle_size * 2.83,
      col = text_color
    )
  )

  # 날짜
  grid.text(
    label = paste0("작성일: ", date),
    x = unit(0.08, "npc"),
    y = unit(0.08, "npc"),
    hjust = 0, vjust = 0,
    gp = gpar(
      fontfamily = "Pretendard",
      fontface = "plain",
      fontsize = date_size * 2.83,
      col = text_color
    )
  )

  showtext_end()
  invisible(dev.off())

  # ---------------------------------------------------------------------------
  # 4. 배경 + 텍스트 합성
  # ---------------------------------------------------------------------------
  text_overlay <- image_read(temp_text_file)
  final_image <- image_composite(base_image, text_overlay, operator = "over")

  # 임시 파일 삭제
  unlink(temp_text_file)

  # ---------------------------------------------------------------------------
  # 5. 이미지 저장
  # ---------------------------------------------------------------------------
  output_dir <- dirname(output_path)
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  image_write(final_image, path = output_path, format = "png")
  message("표지 이미지 생성 완료: ", output_path)

  return(output_path)
}

#' 로고 이미지 로드 (SVG/PNG 지원)
#'
#' @param logo_path 로고 파일 경로
#' @param target_width 목표 너비 (기본값: 80)
#' @param target_height 목표 높이 (기본값: 60)
#'
#' @return magick 이미지 객체
load_logo <- function(logo_path, target_width = 80, target_height = 60) {
  if (!file.exists(logo_path)) {
    return(NULL)
  }

  file_ext <- tolower(tools::file_ext(logo_path))

  tryCatch({
    if (file_ext == "svg") {
      logo <- image_read_svg(logo_path, width = target_width)
      logo <- image_background(logo, "none")
    } else {
      logo <- image_read(logo_path)
      logo <- image_transparent(logo, "white")
      target_geometry <- sprintf("%dx%d", target_width, target_height)
      logo <- image_resize(logo, target_geometry)
    }
    return(logo)
  }, error = function(e) {
    warning("로고 로드 실패: ", e$message)
    return(NULL)
  })
}

#' YAML 파일에서 표지 설정 읽어서 생성
#'
#' @param qmd_path QMD 파일 경로
#' @param output_path 출력 파일 경로
#'
#' @return 생성된 이미지 경로
#' @export
create_cover_from_yaml <- function(qmd_path, output_path = NULL) {
  if (!file.exists(qmd_path)) {
    stop("QMD 파일을 찾을 수 없습니다: ", qmd_path)
  }

  yaml_content <- rmarkdown::yaml_front_matter(qmd_path)
  cover_config <- yaml_content$cover %||% list()

  title <- cover_config$title %||% yaml_content$title %||% "보고서"
  subtitle <- cover_config$subtitle %||% yaml_content$subtitle %||% ""
  date <- cover_config$date %||% format(Sys.Date(), "%Y년 %m월 %d일")
  background <- cover_config$background %||% NULL
  logo <- cover_config$logo %||% get_extension_path("logo.svg")

  if (is.null(output_path)) {
    base_name <- tools::file_path_sans_ext(basename(qmd_path))
    output_path <- file.path(".", paste0("cover_", base_name, ".png"))
  }

  create_cover(
    title = title,
    subtitle = subtitle,
    date = date,
    background_path = background,
    logo_path = logo,
    output_path = output_path
  )
}

# NULL 기본값 연산자
`%||%` <- function(x, y) if (is.null(x)) y else x

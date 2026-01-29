# kr_typst_template

한국어 보고서를 위한 쿼토(Quarto) + Typst 템플릿

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 특징

- **Typst 기반 Tufte 스타일 표지**
- **Pretendard 폰트 내장** (Regular, Bold)
- **한글 최적화** (ggplot2, GT 테이블)
- **유연한 워크플로우** (템플릿 우선/컨텐츠 우선)

## 설치

```bash
quarto add bit2r/kr_typst_template
```

## 빠른 시작

```bash
# 1. 익스텐션 설치
quarto add bit2r/kr_typst_template

# 2. 템플릿 파일 확인
# template.qmd 파일에 상세한 사용법과 예시가 포함되어 있습니다

# 3. 렌더링
quarto render template.qmd
```

## 사용법

설치 후 `template.qmd` 파일을 확인하세요. 이 파일에는 다음 내용이 포함되어 있습니다:

- 📚 **기본 설정 방법**
- 🎨 **표지 커스터마이징**
- 📊 **차트 및 테이블 작성**
- 📝 **여러 장 통합 방법**
- 🔧 **고급 설정 옵션**

## 요구사항

- 쿼토 ≥ 1.4.0
- R 패키지: `tidyverse`, `gt`, `scales`, `ggthemes`

## 프로젝트 구조

```
kr_typst_template/
├── template.qmd           # 🎓 사용법 및 예시 (여기서 시작!)
├── _extensions/           # 템플릿 리소스
│   └── kr_typst_template/
│       ├── typst-show.typ
│       └── resources/
│           ├── cover.typ  # Tufte 스타일 표지
│           ├── logo.svg
│           ├── fonts/
│           └── R/
├── README.md
└── LICENSE
```

## 알려진 이슈

### GT 테이블 폰트 경고

렌더링 시 다음과 같은 경고가 표시될 수 있습니다:

```
warning: unknown font family: system-ui
warning: unknown font family: segoe ui
warning: unknown font family: roboto
...
```

**이는 정상적인 현상입니다. 무시하셔도 됩니다.**

- **원인**: Quarto의 GT→Typst 변환 과정에서 발생
- **영향**: 없음 - PDF는 정상 생성됩니다
- **대응**: 경고 무시하고 사용

> 💡 자세한 내용: [Quarto #12556](https://github.com/quarto-dev/quarto-cli/issues/12556)

## 문서

- **시작하기**: `template.qmd` 파일 참고
- **이슈 리포트**: [GitHub Issues](https://github.com/bit2r/kr_typst_template/issues)
- **쿼토 공식 문서**: [quarto.org](https://quarto.org/)

## 라이선스

MIT License - Copyright (c) 2026 Korea R User Group

## 참고

- [Typst 공식 문서](https://typst.app/docs/)
- [Pretendard 폰트](https://github.com/orioncactus/pretendard)
- [Korea R User Group](https://www.r-users.kr/)

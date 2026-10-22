# 파일명(Name Rule) 지침

> 과제에서 제시된 파일명 규칙 원문과 그 해석. 3DEXPERIENCE / CATIA에서 파트·어셈블리를 저장할 때 이 규칙대로 이름을 붙인다.
> 최초 기록: 2026-09-15 (사용자 전달 원문 기준)

## 원문 (제시된 그대로)

```
📌 파일명 설정
🔸 String 설정 : String 앞에 팀 약어 추가   ex) 팀약어_00LSH(작성자String)
🔸 부품 명 설정 : 자료 조사를 통해 정확한 단어와 명칭 사용

최종 파일(Product) : 팀명약어string_00프로젝트명_Final
ex) ABCD_00Module Recovery_Final

하위레벨 파일(Product) : 팀명약어string_01프로젝트명_하위제품명/공정명_Assy
ex) ABCD_01Module Recovery_Input Line_Assy

하위 파일(Part) : 팀명약어string_00LSH(작성자String)_02하위제품명/공정명_부품명
ex) ABCD_00LSH_02Input Line_FRT Cover        (unit)
ex) ABCD_00LSH_02Input Line_FRT Cover_plate  (part)
```

## 용어 풀이 (비전공자용)

| 용어 | 뜻 |
|---|---|
| **Product** | 여러 부품을 담는 '조립품' 파일. 폴더처럼 다른 파일들을 안에 품는다. CATIA의 `.CATProduct`에 해당. |
| **Part** | 실제 형상을 그린 '부품' 파일. 더 쪼개지지 않는 최소 단위. CATIA의 `.CATPart`에 해당. |
| **Assy** | Assembly(어셈블리, 조립체)의 줄임. 하위레벨 Product 이름 끝에 붙인다. |
| **String** | 여기서는 파일명에 들어가는 '고정 문자열(꼬리표)'을 뜻한다. 팀 약어·작성자 이니셜처럼 사람이 정해 두고 계속 쓰는 토막. |
| **작성자 String** | 그 파일을 만든 사람의 이니셜. 예시의 `LSH`가 그것. |
| **unit / part** | `unit`은 몇 개의 part가 모여 기능 하나를 이루는 덩어리, `part`는 그 안의 낱개 조각. 이름 끝에 `_plate`처럼 한 단계 더 붙여 구분한다. |

## 숫자 코드(00 / 01 / 02)의 의미

파일명 중간의 숫자는 **레벨(계층 깊이)** 표시다. 트리에서 어느 층에 있는 파일인지 이름만 보고 알 수 있게 한 장치.

| 코드 | 붙는 위치 | 의미 |
|---|---|---|
| `00` | 작성자 String 앞, 최종 Product의 프로젝트명 앞 | 최상위 / 사람 식별 레벨 |
| `01` | 하위레벨 Product | 중간 조립 레벨 |
| `02` | 하위 Part | 최하위 부품 레벨 |

## 우리 팀 적용값

- **팀명 약어 = `KAFKA`** (예시의 `ABCD` 자리에 들어감)
- 프로젝트명은 **주제 확정 후** 영문 명칭으로 고정한다. → 현재 미확정 (`claude/01_주제정의_배터리모듈라인.md`, 주제 후보 3건 검토 중)

### 작성자 String 후보 (팀 합의 필요)

로마자 이니셜 3자가 예시 형식(`LSH`)이다. 아래는 팀원 이름 기준 제안값이며, **로마자 표기는 사람마다 다를 수 있으므로 본인 확인 후 확정**한다.

| 팀원 | 제안 String |
|---|---|
| 위상경 | WSK |
| 김민서 | KMS |
| 김석현 | KSH |
| 박정호 | PJH |
| 원정빈 | WJB |
| 이경준 | LKJ |

## 적용 예시 (프로젝트명을 가칭 `Actuator Cell`로 둔 경우)

```
KAFKA_00Actuator Cell_Final                          ← 최종 Product
 └ KAFKA_01Actuator Cell_Input Line_Assy             ← 하위 Product(공정 단위)
    └ KAFKA_00KSH_02Input Line_FRT Cover             ← unit
       └ KAFKA_00KSH_02Input Line_FRT Cover_plate    ← part
```

## 지킬 것

1. **부품명은 지어내지 않는다.** 자료 조사로 실제 업계에서 쓰는 정확한 명칭을 확인해 쓴다 (예: 임의로 `잡는 장치`가 아니라 `Gripper`, `Fixture`, `Jig` 중 맞는 것).
2. **구분자는 언더바(`_`)**, 단어 사이 공백은 예시대로 허용(`Module Recovery`, `FRT Cover`). 하이픈·마침표는 쓰지 않는다.
3. **팀 약어는 항상 맨 앞.** 3DEXPERIENCE는 여러 팀 데이터가 한 저장소에 섞이므로, 검색에서 우리 팀 것만 걸러내는 열쇠가 된다.
4. **작성자 String은 Part에만** 들어간다 (Product 이름에는 없음). 누가 그린 부품인지 추적하기 위한 것.
5. **프로젝트명 표기는 한 번 정하면 끝까지 동일하게.** 대소문자·띄어쓰기까지 통일한다.
6. 확정되지 않은 값(프로젝트명 등)을 임시로 넣어 저장했다면, 확정 후 **이름 변경 시 참조가 끊기지 않는지** 반드시 확인한다.
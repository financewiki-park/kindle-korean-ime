# 킨들에서 한글 키보드 쓰기: KPM으로 설치하고 홈 화면 아이콘으로 실행하기

킨들 기본 키보드에서 한글을 입력하려면 한글 자모를 글자 단위로 조합하는 입력기(IME)가 필요하다. 이 글은 탈옥된 Kindle에서 `Korean IME`를 설치하고, 재부팅 뒤에도 홈 화면의 아이콘으로 다시 실행하는 방법을 정리한 안내다.

> 이 패키지는 현재 개발·검증 단계다. Kindle 5.19.6, `kindlehf` 환경에서 확인한 결과를 바탕으로 하며, 다른 모델과 펌웨어에서는 먼저 호환성 확인이 필요하다. Kindle 탈옥 및 서드파티 패키지 사용에는 항상 기기 오작동·데이터 손실 위험이 있다.

## 준비물

- 탈옥된 터치 Kindle
- KTerm과 KPM
- SH Integration
- USB 케이블 또는 Wi-Fi 연결

SH Integration은 `.sh` 실행 파일을 Kindle 홈 라이브러리의 실행 항목으로 보여 주는 구성요소다. 이미 다른 `.sh` 실행 파일이 홈 화면에 보인다면 준비되어 있다.

KPM 저장소 주소는 다음 한 줄이다.

`https://financewiki-park.github.io/k/`

## 설치: KTerm에서 두 줄

KTerm을 열고 아래를 차례로 실행한다.

```sh
/var/local/kmc/bin/kpm update
/var/local/kmc/bin/kpm install korean-ime
```

첫 줄은 KPM이 등록된 저장소의 최신 목록을 받는다. 둘째 줄은 기존 버전이 있다면 안전한 업그레이드 절차를 거쳐 새 버전을 설치한다.

설치 중에는 Kindle을 재부팅하거나 USB를 뽑지 않는다. 설치가 끝나면 KPM이 다음 파일을 만든다.

```text
/mnt/us/documents/Korean IME Start.sh
```

이 실행 파일에는 아래와 같이 이름과 아이콘 경로가 포함돼 있다.

```text
# Name: Korean IME Start
# Icon: /mnt/us/korean-ime/icon.png
```

따라서 SH Integration이 설치된 Kindle에서는 홈 화면 라이브러리가 새로고침된 뒤 **Korean IME Start**가 한글 키보드 아이콘과 함께 나타난다.

## 재부팅 뒤 실행하기

이 입력기는 안전을 위해 부팅 때 자동으로 백그라운드 실행되지 않는다. 재부팅 뒤에는 홈 화면에서 **Korean IME Start** 아이콘을 한 번 누른다.

아이콘이 아직 보이지 않으면 USB 연결을 해제한 뒤 잠시 기다려 라이브러리 색인이 끝나도록 한다. 그래도 보이지 않으면 SH Integration이 설치되어 있는지 확인한다. 임시 대안으로는 KTerm에서 아래 한 줄을 실행할 수 있다.

```sh
sh '/mnt/us/documents/Korean IME Start.sh'
```

실행 뒤 Kindle의 검색창, 메모, 컬렉션 이름처럼 기본 키보드가 뜨는 곳에서 한글을 입력한다. 현재 빌드는 **Shift+Space**로 조합 브리지의 한글·영문 처리를 전환한다. 기기 키보드에 지구본 키가 보이면 Kindle이 제공하는 키보드 전환에도 사용할 수 있지만, 표시와 동작은 펌웨어에 따라 다를 수 있다.

## 업데이트와 삭제

새 버전이 나오면 설치 때와 같은 명령을 다시 실행하면 된다.

```sh
/var/local/kmc/bin/kpm update
/var/local/kmc/bin/kpm install korean-ime
```

삭제하려면 다음 명령을 쓴다.

```sh
/var/local/kmc/bin/kpm uninstall korean-ime
```

삭제 과정은 이 패키지가 만든 실행 파일과 아이콘을 지우고, 설치 전 백업한 키보드 설정으로 되돌리도록 설계되어 있다. 실행 중인 한글 조합 브리지도 함께 종료한다.

## 문제가 생기면

- 설치가 실패하면 먼저 `kpm update`를 실행한 뒤 다시 설치한다.
- 홈 화면에 아이콘이 없으면 SH Integration 유무와 Kindle 라이브러리 색인 상태를 확인한다.
- 한글이 자모 단위로 `ㅈㅗㅇ`처럼 보이면 예전 버전의 조합 브리지가 남아 있을 수 있다. 최신 버전으로 다시 설치한 뒤 **Korean IME Start**를 실행한다.
- 키보드를 원래대로 되돌리고 싶다면 `kpm uninstall korean-ime`를 실행한다.

## 기존 Kingul과 무엇이 다른가

Kingul은 Kindle 한글 입력을 가능하게 만든 선행 프로젝트다. 한글은 `ㅎ → 하 → 한`처럼 입력 도중 글자가 계속 바뀌므로, 단순 자판 배열만 추가해서는 제대로 입력할 수 없다. Kingul은 활성 창의 키 이벤트를 관찰하고, 이미 표시된 자모를 지운 뒤 조합된 글자를 다시 넣는 방식으로 이 문제를 해결했다. 이 프로젝트도 Kindle 기본 UI의 텍스트 입력창에서 동작한다는 목표와, X11 이벤트를 바탕으로 한 조합 처리라는 큰 방향은 Kingul과 같다.

차이는 다음과 같다.

| 구분 | Korean IME 프로젝트 | Kingul |
| --- | --- | --- |
| 설치 방식 | KPM 저장소에서 업데이트·설치·삭제 | README 기준 MRPI 패키지 설치 후 KUAL 메뉴 사용 |
| 실행 방식 | 홈 화면의 `Korean IME Start` 아이콘 또는 KTerm 실행 | KUAL의 Kingul 메뉴에서 키보드 선택 전환 |
| 배포물 | `kindlehf`와 `kindlepw2` ARM 바이너리를 하나의 KPM 패키지에 포함 | 모델·펌웨어별 설치 패키지 중심 |
| 한글 조합 | 별도 Hangul core의 호스트 단위 테스트로 초성·중성·종성·복합 모음·복합 종성·조합 중 Backspace를 검증 | Kindle 이벤트를 후처리하는 기존 조합 로직 |
| 포커스 처리 | 최신 Kindle GTK 입력기가 매 탭마다 내부 포커스 창을 바꾸는 현상을 고려해 조합 상태를 유지 | 당시 관찰한 포커스 창과 키 이벤트 흐름을 바탕으로 구현 |
| 전력 정책 | 부팅 자동실행을 하지 않으며, 실행 시에도 유휴 대기를 40ms로 제한 | 프로젝트 문서에 별도 전력 정책 설명 없음 |
| 복구 | 설치 전 키보드 설정 백업, 업그레이드 때 기존 브리지 종료, 삭제 때 복원 | 별도 uninstall MRPI 패키지 제공 |

### 가장 큰 차이: 최신 Kindle의 실행 환경

Kingul의 안내는 MRPI로 설치한 뒤 KUAL 메뉴에서 키보드를 켜고, Kindle 설정에서 Korean 키보드를 고르는 흐름이다. 반면 이 프로젝트는 KPM이 패키지 버전·업그레이드·삭제를 관리하고, SH Integration이 읽는 메타데이터를 실행 파일에 넣어 홈 화면 아이콘으로 다시 시작할 수 있게 했다.

특히 최근 `kindlehf` 계열에서는 예전 KUAL 환경이 그대로 동작하지 않을 수 있다. 그래서 이 프로젝트는 KPM 설치와 `.sh` 실행 연동을 분리했다. KPM은 설치·업데이트를 맡고, 홈 화면의 **Korean IME Start**는 재부팅 후 필요한 순간에만 조합 브리지를 다시 시작한다.

### 한글 조합과 Backspace의 차이

한글 입력에서 중요한 부분은 키보드 그림보다 조합 상태다. 예를 들어 `ㄱ + ㅗ + ㅏ`는 `과`가 되고, 받침이 붙은 뒤 모음이 들어오면 앞 글자의 받침 일부가 다음 글자의 초성이 된다. 이 프로젝트는 이 규칙을 X11 처리 코드와 분리한 Hangul core로 구현했다. 그래서 PC에서도 조합 규칙을 테스트한 다음 Kindle용 ARM 바이너리를 만든다.

또한 최신 Kindle에서 확인된 내부 입력 포커스 창의 교체를 단순히 “입력창이 바뀌었다”로 처리하지 않는다. 탭마다 창 번호가 달라져도 현재 조합 중인 글자를 유지하도록 수정했다. 이 부분이 자모가 분리되어 입력되던 문제를 해결하는 핵심이었다.

다만 Kindle 기본 입력 체계에 정식 IME API가 공개된 것은 아니다. 따라서 이 프로젝트도 기존 입력을 관찰하고 필요한 삭제·재입력을 보내는 호환 계층이라는 한계가 있다. 복잡한 편집 동작, 아직 확인하지 않은 펌웨어, 다른 모델에서는 예외가 생길 수 있다. 그런 경우에는 로그와 기기 정보를 기준으로 지원 범위를 넓히는 것이 안전하다.

## 참고

- [Korean IME 소스와 KPM 패키지](https://github.com/financewiki-park/kindle-korean-ime)
- [Kingul 원 프로젝트와 설치·동작 설명](https://github.com/hy1o/kingul)
- [KUAL Next의 SH Integration 및 실행 파일 메타데이터 설명](https://github.com/thiagokokada/kual-next)

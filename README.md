# Igmd

## mdnotify: MD 결과 휴대폰 알림

MD 시뮬레이션(GROMACS, LAMMPS, AMBER, NAMD 등)이 끝나면 휴대폰으로 푸시 알림을 보내는 스크립트임.
`bash`와 `curl`만 있으면 동작하므로 워크스테이션과 클러스터 모두에서 사용 가능함.

### 1. 설치 (MD를 돌리는 컴퓨터에서 1회)

```bash
mkdir -p ~/bin
cp bin/mdnotify ~/bin/ && chmod +x ~/bin/mdnotify
cp examples/mdnotify.conf.example ~/.mdnotify.conf && chmod 600 ~/.mdnotify.conf
# ~/.mdnotify.conf 의 NTFY_TOPIC 을 추측하기 어려운 고유 이름으로 수정
```

### 2. 휴대폰 설정

1. ntfy 앱 설치 (Android: Google Play, iOS: App Store에서 "ntfy" 검색)
2. 앱에서 `+` → 위에서 정한 `NTFY_TOPIC` 이름으로 구독
3. 컴퓨터에서 `~/bin/mdnotify test` 실행 → 휴대폰에 테스트 알림 도착 확인

> 토픽 이름은 사실상 비밀번호 역할임. 누구나 같은 이름을 구독하면 알림을 볼 수 있으므로 무작위 문자열을 포함할 것.
> Telegram을 선호하면 설정 파일의 `TELEGRAM_*` 항목을 채우면 됨 (ntfy와 동시 사용 가능).

### 3. 사용법

**새로 실행하는 MD를 감싸서 실행** (성공/실패, 소요 시간, ns/day, 로그 끝부분을 알림)

```bash
mdnotify run --name lig1_prod --log md.log -- gmx mdrun -deffnm md
mdnotify run --name lmp_run  --log log.lammps -- lmp -in in.md
```

**이미 돌고 있는 MD 감시** (파일이 생기거나 특정 문구가 나타나면 알림)

```bash
nohup mdnotify watch --pattern 'Finished mdrun' md.log &   # GROMACS
nohup mdnotify watch md.gro &                              # 최종 구조 파일 생성 시
```

**Slurm 작업 스크립트**: `examples/slurm_gromacs.sh` 참고 (시간 초과·취소 시에도 알림)

**임의 알림**

```bash
mdnotify send "분석 완료" "RMSD 계산 끝"
```

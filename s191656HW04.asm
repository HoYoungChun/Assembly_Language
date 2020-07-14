TITLE s191656HW04

;작성자 : 20191656 천호영
;기능	: 등산로의 오르막 중에서 가장 고도 차이가 큰 오르막의 높이를 구한다.
;입력	: CSE3030_PHW04.inc의 고도를 측정한 지점의 개수들과 고도들
;출력	: 각 테스트에 대하여 오르막 중 고도 차이가 가장 큰 값을 구하여 출력한다.

COMMENT @
	1. 우선 각 test를 시작할 때 최대 고도 차이를 0으로 설정하고 시작한다.
	2. 그리고 각 test에서 마지막 고도만 제외하고 고도마다 그 뒤가 오르막 길인지 체크한 뒤,
	3. 오르막길이라면 고도 차이를 구하여 그 당시의 최대 고도 차이와 비교하고,
	4. 만약 더 높다면 최대 고도 차이를 교체한다.
	5. 이런식으로 한 test를 마친뒤 최대 고도 차이를 출력하는 방식으로 진행한다.
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW04.inc

.data
	HN DWORD 0			;각 test마다의 고도 개수
	start DWORD 0		;각 test안에서 오르막일 때 오르막의 최저점
	endd DWORD 0		;각 test안에서 오르막일 때 오르막의 최고점
	endtest DWORD 0		;각 test의 끝을 확인(index로 확인한다, 38번째 줄 참조)
.code
main PROC
	mov esi, 0			;esi는 HEIGHT기준으로 하는 index역할
	mov ebx, CASE
	mov HN, ebx			;HN에는 첫 번째 test의 고도측정지점 개수를 저장
	mov ecx, TN			;L1 loop가 TN만큼 반복되도록 설정
	
	L1:							;TN만큼 반복
		push ecx				;L1의 ecx저장
		
		mov ecx,HN
		dec ecx					;L2 loop가 HN-1만큼 반복되도록 설정(마지막 고도를 제외시키는 정도까지 반복되도록)
		mov edx, 0				;edx에는 각 test마다 고도 차이가 가장 큰 값을 저장한다(test시작할 때 0으로 초기화)
		
		mov ebx,HN				;HEIGHT기준으로 index가 esi+4*(HN-1)일 때 각 test의 마지막 고도임을 이용한다.
		dec ebx	
		add ebx, ebx
		add ebx, ebx			
		add ebx, esi			;ebx <- esi+4*(HN-1) 
		mov endtest, ebx		;endtest에는 각test의 마지막 고도를 확인할 값(esi+4*(HN-1))을 저장
		
		L2:						;HN-1만큼 반복(마지막 고도를 제외시키는 정도까지 반복)
			push ecx			;L2의 ecx저장
			mov edi, 0			;edi는 한 test안에서 한 고도를 기준으로 하는 index역할(각 고도에서 시작할 때 0으로 초기화)
			mov ecx,HN			;L3 loop가 HN만큼 반복되도록 설정
			
			mov ebx, HEIGHT[esi]
			mov start,ebx		;start에는 index가 esi위치에 해당하는 고도값을 저장한다

				L3:									;HN만큼반복(loop 돌때마다 90번째 줄에서 HN=HN-1 해준다)(다음 test영역을 침범하지 않도록)
				mov ebx,esi
				add ebx,edi							;ebx <- esi + edi
				CMP ebx, endtest					;마지막 고도에 도달했는지 확인(도달했다면 마지막 고도가 오르막의 최고점)
													;(마지막 고도를 제외하고 관찰하고 있으므로 도달했다면 오르막이기 때문에)
				JNZ k_1								;마지막 고도가 아니라면 k_1(68번째 줄)로 이동
					mov ebx, HEIGHT[esi+edi]
					mov endd, ebx					;endd <- HEIGHT[esi+edi](endd에 마지막 고도의 높이를 저장)
					mov ebx, start
					sub endd,ebx					;endd에는 현재 오르막의 고도 차이가 저장된다
					CMP endd, edx					;기존 최대값보다 작은지 확인
					JBE k_2							;작다면 k_2(66번째 줄)로 이동
						mov edx,endd				;크다면 최대 고도 차이(edx) 교체
					k_2:
					jmp breaked						;esi가 가리키는 고도에 대한 점검이 끝났으므로 L3탈출(88번째 줄로 이동)			
				k_1:								;마지막 고도가 아닐 때
				mov ebx,HEIGHT[esi+edi+4]			
				cmp HEIGHT[esi+edi],ebx				;HEIGHT[esi+edi]가 HEIGHT[esi+edi+4]보다 작은지 확인(=오르막인지 check)
				JB k_3								;작다면 k_3(82번째 줄)로 이동
					mov ebx, HEIGHT[esi+edi]		
					mov endd, ebx					;endd <- HEIGHT[esi+edi](오르막의 최고점을 저장)
					mov ebx, start
					sub endd,ebx					;endd에는 현재 오르막의 고도 차이가 저장된다
					CMP endd, edx					;기존 최대값보다 작은지 확인
					JBE k_4							;작다면 k_4(79번째 줄)로 이동
						mov edx, endd				;크다면 최대 고도 차이(edx) 교체
					k_4:
					jmp breaked						;esi가 가리키는 고도에 대한 점검이 끝났으므로 L3탈출(88번째 줄로 이동)

				k_3:								;esi가 가리키는 고도의 뒷부분이 오르막일 때
				add edi,4							;index를 증가시킨뒤 뒷부분이 계속 오르막인지 확인한다
				
				
				loop L3

				breaked:		;L3를 탈출했을 때 이동되는 곳이다
			add esi, 4			;esi를 증가시켜 다음 고도에 대해 살펴본다.
			sub HN,1			;HN을 1감소시켜 L3의 loop횟수를 1줄인다.
			pop ecx				;L2의 ecx 불러오기
		loop tmp_1
		jmp tmp_2
		tmp_1:
			jmp L2
		tmp_2:

		
		mov eax,edx				;eax <- 한 test에서 고도 차이가 가장 큰 값(edx)
		call writeDec			;각 test마다 고도 차이가 가장 큰 값 출력
		call crlf				;줄바꿈

		sub endtest, 4			;다음 test의 endtest를 esi+4*(HN-1)로 확인하기 위하여 endtest-=4 시행
		add esi,4				;next test로 이동
		mov ebx, HEIGHT[esi]	;ebx <- 다음 test의 고도개수
		mov HN,ebx				;HN에는 다음 test의 고도개수 저장
		add esi, 4				;index가 esi인 곳이 가리키는 곳이 다음 test의 첫 번째 고도가 되도록 한다
		pop ecx					;L1의 ecx 불러오기

	loop tmp1
	jmp tmp2
	tmp1:
		jmp L1
	tmp2:

	exit
main ENDP
END main
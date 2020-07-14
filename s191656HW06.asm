TITLE s191656HW06

;작성자 : 20191656 천호영
;기능	: 가게와 각 집 간의 거리의 합이 최소가 되는 가게를 선택하여 그 가게와 각 집 간의 거리의 합을 출력한다
;입력	: 집의 위치를 나타내는 정수 리스트를 하나의 문자열로 입력
;출력	: 선택한 가게와 각 집들 간의 거리의 합 중에서 최솟값을 출력

COMMENT @
	HW05와 같은 방법으로 intArray에 각 집의 위치를 저장한 후, 반복문을 통해, distanceArray에
	해당되는 위치의 가게를 선택했을 때 그 가게와 각 집들 간의 거리의 합을 저장한다.
	이후에 bubble sort를 사용하여 distanceArray의 맨앞에 거리의 합의 최소값을 위치시키고,
	이 값을 출력한다
@

INCLUDE Irvine32.inc

.data
	prompt BYTE "Enter numbers(<ent> to exit) :",0
	ending BYTE "Bye!",0

	BUF_SIZE EQU 256
	inBuffer BYTE BUF_SIZE DUP(?)			; input string buffer(EOS is 0) <- 256 BYTE
	inBufferN DWORD ?						; string size(excluding EOS)  <-입력한 문자열크기만큼
	intArray SDWORD BUF_SIZE/2 DUP(?)		; integer array	<- 입력된 숫자들(집의 위치)을 저장할 배열
	distanceArray SDWORD BUF_SIZE/2 DUP(?)	; integer array <- 해당되는 위치의 가게와 각 집들 간의 거리의 합을 저장할 배열

.code
main PROC
	L1:										;아무 입력없이 enter만 누르기 전에는 무한반복
		mov edx, OFFSET prompt
		call writestring
		call crlf							;프롬프트 출력

		mov esi, 0							;esi <- flag역할 (빈칸일 때 0, 빈칸이 아닐 때 1), 함수 transf에서 이용한다(49번째 줄에서 호출)
		mov ebx, 0							;ebx <- 입력되는 숫자(집의 위치)의 개수(intArrayN역할), 초깃값 0으로 설정
		
		mov edx, OFFSET inBuffer
		mov ecx, SIZEOF inBuffer
		call Readstring						;문자열 입력받음 ( inBuffer에 문자열 저장됨 )

		mov inBufferN, eax					;inBufferN에는 입력된 개수가 저장된다(EOS 제외)
		cmp eax, 0							;엔터만 친건지 확인
		jz breaked							;엔터만 쳤을때 문자열입력받는 반복문 탈출(94번째 줄로)

		mov edi, OFFSET intArray			;edi <- 숫자(집의 위치)들을 저장할 배열의 주소
		mov ecx, inBufferN					;ecx <- 입력한 문자열 개수
		mov edx, OFFSET inBuffer			;edx <- 입력한 문자열의 주소

		call transf							;함수를 호출해 숫자(집의 위치)들을 추출한 후 edi가 가리키는 배열에 저장시킨다(137번째 줄 참조)
											;함수호출 이후 ebx <- 집의 개수, intArray에 숫자(집의 위치)들 저장됨
		
		mov edi, 0							;edi는 이제 배열안에서 '가게로 정할 집'의 위치를 참조할 index로 이용	
		mov ecx, ebx						;함수 내에서 ebx에 '입력된 집의 개수'를 저장했으므로 이를 ecx에 넣어 loop에 이용
			
		cmp ecx, 0							;숫자가 존재하지 않고 빈칸들만 있는지 확인
		jz nothing							;빈칸들만 있다면 nothing(91번째 줄)으로 이동


		cnt_distance:						;각각의 집을 참조하기 위해 ebx(집의 개수)만큼 반복
			push ecx
			mov eax, 0						;eax에 '가게로 정한 집' 기준으로 각 집과의 거리의 총합을 저장하기 위해 0으로 먼저 초기화
			mov esi, 0						;each_distance(65번째 줄)에서 각 집의 위치의 index역할을 하기위해 0으로 먼저 초기화
			mov ecx, ebx					;65번째 줄에서 집들의 개수(ebx)만큼 반복하기 위해

			each_distance:					;집들의 개수(ebx)만큼 반복
				mov edx, [intArray+edi]
				sub edx, SDWORD PTR [intArray+esi]
				cmp edx, 0					;[intArray+edi](가게) - [intArray+esi](집)가 양수인지 check
				jg plus						;양수라면 plus(71번째 줄)로 이동
				neg edx						;음수라면 부호를 바꿔준다(거리는 절댓값이므로)
				plus:
				add eax, edx				;eax에 거리를 더해준다

				add esi,4					;esi가 다음 집을 참조할 수 있도록 한다(if 가게가 자기자신을 참조해도 거리가 0이므로 따로 예외처리하지 않는다)
			loop each_distance
			mov [distancearray+edi], eax	;distance[edi]의 위치에 그 위치의 가게를 기준으로 다른 집들간의 거리의 총합을 저장시킨다

			add edi, 4						;edi가 '가게로 정할 다음 집'을 참조할 수 있도록 한다
			pop ecx
		loop cnt_distance
											;distancearray배열에는 그 위치로 가게를 정했을 때의 다른집들간의 거리의 총합이 저장됨

		mov edx, OFFSET distancearray		;edx <- 그 위치로 가게를 정했을 때의 다른집들간의 거리의 총합이 저장된 배열의 주소
		call bubble_sort					;bubble sort를 통해 [distancearray]자리에 거리합의 최솟값을 위치시킨다

		mov eax, [distancearray]
		call writedec						;가장 작은 '가게와 각 집들 간의 거리의 합'을 부호 없이 출력	
		call crlf							;줄바꿈


		nothing:
	jmp L1
		
	breaked:
	mov edx, OFFSET ending	
	call writestring						;종료 프롬프트 출력
	exit
main ENDP


bubble_sort PROC
	;기능: 배열의 숫자들을 오름차순으로 sorting한다
	;입력: edx <- 숫자들이 저장된 배열의 주소, ebx <- 저장된 숫자들의 갯수
	;출력: X	
	
	mov ecx, ebx							;big_loop(108번째 줄)를 저장된 숫자들의 개수만큼 반복시키기 위해

	big_loop:								;저장된 숫자들의 개수만큼 반복
	push ecx
	mov esi,0								;배열안에서 각 숫자들을 참조하기 위한 index로 사용, big_loop돌때마다 0으로 초기화
	
	mov ecx,ebx								
	sub ecx, 1								;small_loop(115번째 줄)를 [저장된 숫자들의 개수 - 1]만큼 반복시키기 위해
			
		small_loop:							;[저장된 숫자들의 개수 - 1]만큼 반복
			mov eax, [edx+esi]
			cmp eax, SDWORD PTR [edx+esi+4]
			jb not_change					;[edx+esi] < [edx+esi+4]인지 확인하고 맞다면 not_change(127번째 줄)로 이동

			push ebx						;ebx를 임시로 사용하기위해
			mov eax, [edx+esi]
			mov ebx, [edx+esi+4]
			mov [edx+esi], ebx
			mov [edx+esi+4], eax			;[edx+esi] >= [edx+esi+4]이라면 [edx+esi]와 [edx+esi+4]의 값을 교환한다
			pop ebx							;임시로 사용한 ebx의 값을 돌려놓는다

			not_change:
			add esi,4						;esi가 다음 숫자를 참조할 수 있도록 한다
		loop small_loop

	
	pop ecx		
	loop big_loop
	ret										;edx가 가리키는 배열에는 숫자들이 오름차순으로 정렬된다
bubble_sort ENDP

transf PROC
	;기능 : 문자열에서 숫자들을 뽑아 배열에 저장하고 저장된 숫자들의 개수를 반환
	;입력 : edi <- 숫자들을 저장할 배열의 주소, ecx <- 입력한 문자열 개수,  edx <- 입력한 문자열의 주소
	;출력 : ebx <- edi가 가리키는 배열에 저장된 숫자들의 갯수

	Lcheck:
		cmp byte ptr [edx], 20h				;edx가 가리키는 곳이 공백인지 확인
		jnz next							;공백이 아니라면 next(151번째 줄)로 이동

		cmp esi, 0							;공백일 때 esi(flag)가 0인지 확인
		jz continue							;공백일 때 esi(flag)가 0이라면 continue(162번째 줄)로 이동
		mov esi, 0							;공백일 때 esi(flag)가 0이 아니라면 esi(flag)를 0으로 만든다
		jmp continue						;공백일 때 esi(flag)를 0으로 만든 다음에는 continue(162번째 줄)로 이동
		
		next:								;공백이 아닐 때 오는 label
			cmp esi, 0						;공백이 아닐 때 esi(flag)가 0인지 확인
			jnz nott						;공백이 아닐 때 esi(flag)가 0이 아니라면 nott(161번째 줄)로 이동
			call Parseinteger32				;공백이 아닐 때 esi(flag)가 0이라면 그 부분에서 숫자가 시작되므로 Parseinteger32 호출
			
			mov DWORD PTR [edi], eax		;숫자로 추출한 값을 edi가 가리키는 곳에 넣어준다

			add edi, 4						;숫자들을 저장할 배열에서 edi가 다음 위치를 가리키도록 한다
			mov esi, 1						;esi(flag)를 1로 변경(공백이 아니므로)
			add ebx, 1						;edi가 가리키는 배열에 저장된 숫자들의 갯수(ebx)를 1증가시킨다
		nott:
		continue:
			add edx, 1						;입력한 문자열에서 다음 위치를 가리키도록 한다	
	loop Lcheck
	ret										;ebx에는 'edi가 가리키는 배열에 저장된 숫자들의 갯수'가 저장된다
transf ENDP

END main
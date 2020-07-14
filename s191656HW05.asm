TITLE s191656HW05

;작성자 : 20191656 천호영
;기능	: 문자열로부터 정수 값들을 추출하고 이들을 모두 더한 값을 출력한다
;입력	: 정수 값들을 하나의 문자열로 입력
;출력	: 정수 값들을 모두 더한 값을 출력

INCLUDE Irvine32.inc

.data
	prompt BYTE "Enter numbers(<ent> to exit) :",0
	ending BYTE "Bye!",0

	BUF_SIZE EQU 256
	inBuffer BYTE BUF_SIZE DUP(?)			; input string buffer(EOS is 0) <- 256 BYTE
	inBufferN DWORD ?						; string size(excluding EOS)  <-입력한 문자열크기만큼
	intArray SDWORD BUF_SIZE/2 DUP(?)		; integer array	<- 입력된 숫자들을 저장할 배열
	
.code
main PROC
	L1:										;아무 입력없이 enter만 누르기 전에는 무한반복
		mov edx, OFFSET prompt
		call writestring
		call crlf							;프롬프트 출력

		mov esi, 0							;esi <- flag역할 (빈칸일 때 0, 빈칸이 아닐 때 1), 함수 transf에서 이용한다(41번째 줄에서 호출)
		mov ebx, 0							;ebx <- 입력되는 숫자의 개수(intArrayN역할), 초깃값 0으로 설정
		
		mov edx, OFFSET inBuffer
		mov ecx, SIZEOF inBuffer
		call Readstring						;문자열 입력받음 ( inBuffer에 문자열 저장됨 )

		mov inBufferN, eax					;inBufferN에는 입력된 개수가 저장된다(EOS 제외)
		cmp eax, 0							;엔터만 친건지 확인
		jz breaked							;엔터만 쳤을때 문자열입력받는 반복문 탈출(65번째 줄로)

		mov edi, OFFSET intArray			;edi <- 숫자들을 저장할 배열의 주소
		mov ecx, inBufferN					;ecx <- 입력한 문자열 개수
		mov edx, OFFSET inBuffer			;edx <- 입력한 문자열의 주소

		call transf							;함수를 호출해 숫자들을 추출한 후 edi가 가리키는 배열에 저장시킨다(72번째 줄 참조)
		
		
		mov edi, 0							;edi는 이제 숫자들을 출력할 때 사용하는 index로 이용	
		mov ecx, ebx						;함수 내에서 ebx에 입력된 숫자들의 개수를 저장했으므로 이를 ecx에 넣어 loop에 이용
		mov eax, 0							;eax에 숫자들의 합을 저장하기 위해 0으로 먼저 초기화	
		cmp ecx, 0							;숫자가 존재하지 않고 빈칸들만 있는지 확인
		jz nothing							;빈칸들만 있다면 nothing(62번째 줄)으로 이동
		print:
			add eax, SDWORD PTR [intArray+edi]
			add edi, 4						;숫자들을 순차적으로 eax(초기값 0)에 더하여 총합을 eax에 저장한다
		loop print

		cmp eax, 0							;총합이 음수인지 확인(음수면 부호를 붙이고, 양수면 부호를 붙이지 않으므로)
		jl negative
			call writedec					;음수일때 부호 붙여서 출력
			jmp end_last
		negative:
			call writeint					;양수일때 부호 없이 출력
		end_last:
			call crlf						;줄바꿈
		nothing:
	jmp L1
		
	breaked:
	mov edx, OFFSET ending	
	call writestring						;종료 프롬프트 출력
	exit
main ENDP


transf PROC
	Lcheck:
		cmp byte ptr [edx], 20h				;edx가 가리키는 곳이 공백인지 확인
		jnz next							;공백이 아니라면 next(82번째 줄)로 이동

		cmp esi, 0							;공백일 때 esi(flag)가 0인지 확인
		jz continue							;공백일 때 esi(flag)가 0이라면 continue(93번째 줄)로 이동
		mov esi, 0							;공백일 때 esi(flag)가 0이 아니라면 esi(flag)를 0으로 만든다
		jmp continue						;공백일 때 esi(flag)를 0으로 만든 다음에는 continue(93번째 줄)로 이동
		
		next:								;공백이 아닐 때 오는 label
			cmp esi, 0						;공백이 아닐 때 esi(flag)가 0인지 확인
			jnz nott						;공백이 아닐 때 esi(flag)가 0이 아니라면 nott(92번째 줄)로 이동
			call Parseinteger32				;공백이 아닐 때 esi(flag)가 0이라면 그 부분에서 숫자가 시작되므로 Parseinteger32 호출
			
			mov DWORD PTR [edi], eax		;숫자로 추출한 값을 edi가 가리키는 곳에 넣어준다

			add edi, 4						;integer array에서 edi가 다음 위치를 가리키도록 한다
			mov esi, 1						;esi(flag)를 1로 변경(공백이 아니므로)
			add ebx, 1						;"number of integers stored in intArray"(ebx)를 1증가시킨다
		nott:
		continue:
			add edx, 1						;input string buffer에서 다음 위치를 가리키도록 한다	
	loop Lcheck
	ret										;ebx에는 "number of integers stored in intArray"가 저장된다
transf ENDP

END main
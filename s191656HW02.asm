TITLE s191656HW02
	
;작성자 : 20191656 천호영
;기능	: 45 * x1 + 16 * x2 + 28 * x3을 계산하여 이 값을 출력한다
;입력	: CSE3030_PHW02.inc의 x1,x2,x3의 값
;출력	: 45 * x1 + 16 * x2 + 28 * x3 계산의 결과


COMMENT @
45 * x1 + 16 * x2 + 28 * x3을 계산하기 위해 45 * x1, 16 * x2, 28 * x3을 각각 계산한 뒤 이들을 더한다
이때 각각의 계산에서 곱해지는 상수 45, 16, 28가 2의 지수승의 합으로 표현되는 점을 이용하여 쉽게 계산한다.
16은 그 자체로 2의 지수승이고, 45는 32+8+4+1, 28은 16+8+4로 표현할 수 있다.
@


INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW02.inc

.data
	result DWORD 0		;result는 32*x1, 8*x1, 4*x1, 1*x1을 더해서 총합을 구할 변수로 초깃값을 0으로 만든다 
	result3 DWORD 0		;result3는 16*x3, 8*x3, 4*x3을 더해서 총합을 구할 변수로 초깃값을 0으로 만든다

.code
main PROC
	
	;우선 45*x1을 (32+8+4+1)*x1으로 생각하여 계산하고 이 값을 eax에 저장한다.
	mov   eax, x1		;eax에 x1의 값을 할당한다
	add   result, eax	;result에 x1*1을 더한다
	add   eax, eax		;eax에 x1 * 2의 값이 할당되게 한다
	add   eax, eax		;eax에 x1 * 4의 값이 할당되게 한다
	add   result, eax	;result에 x1*4을 더한다
	add   eax, eax		;eax에 x1 * 8의 값이 할당되게 한다
	add   result, eax	;result에 x1*8을 더한다
	add   eax, eax		;eax에 x1 * 16의 값이 할당되게 한다
	add   eax, eax		;eax에 x1 * 32의 값이 할당되게 한다
	add   result, eax	;result에 x1*32을 더한다
	mov   eax, result	;45*x1의 결과가 저장된 result의 값을 eax에 할당한다


	;그 다음으로 16*x2을 계산하고 이 값을 ebx에 저장한다.
	mov   ebx, x2		;ebx에 x2의 값을 할당한다
	add   ebx, ebx		;ebx에 x2 * 2의 값이 할당되게 한다
	add   ebx, ebx		;ebx에 x2 * 4의 값이 할당되게 한다
	add   ebx, ebx		;ebx에 x2 * 8의 값이 할당되게 한다
	add   ebx, ebx		;ebx에 x2 * 16의 값이 할당되게 한다


	;마지막으로 28*x3을 (16+8+4)*x3으로 생각하여 계산하고 이 값을 ecx에 저장한다.
	mov   ecx, x3		;ecx에 x3의 값이 할당되게 한다
	add   ecx, ecx		;ecx에 x3*2의 값이 할당되게 한다
	add   ecx, ecx		;ecx에 x3*4의 값이 할당되게 한다
	add   result3, ecx	;result3에 x3*4을 더한다
	add   ecx, ecx		;ecx에 x3*8의 값이 할당되게 한다
	add   result3, ecx	;result3에 x3*8을 더한다
	add   ecx, ecx		;ecx에 x3*16의 값이 할당되게 한다
	add   result3, ecx	;result3에 x3*16을 더한다
	mov   ecx, result3	;28*x3의 결과가 저장된 result3의 값을 ecx에 할당한다


	;eax에 ebx와,ecx를 차례로 더하여 eax, ebx, ecx의 총합을 eax에 저장한다.
	add   eax, ebx
	add   eax, ecx
	

	call  Writeint		;계산결과를 출력한다
	exit
main ENDP
END main

TITLE s191656HW03

;작성자 : 20191656 천호영
;기능	: 크기가 10인 일련의 cipher 문자열들이 주어졌을 때, 이를 decipher한 문자열들을 구하여 파일에 저장
;입력	: CSE3030_PHW03.inc의 10 개의 문자로 구성된 cipher text들
;출력	: cipher text들을 decipher한 문자열들을 구하여 파일에 저장

COMMENT @
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"의 각 문자들을 decipher하면,
	"QRSTUVWXYZABCDEFGHIJKLMNOP"의 각 문자들과 순서대로 대응된다는 점을 이용한다
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW03.inc

.data
	filename BYTE "0s191656_out.txt",0
	fileHandle DWORD ?
	alphas BYTE "QRSTUVWXYZABCDEFGHIJKLMNOP"	;"ABCDEFGHIJKLMNOPQRSTUVWXYZ"와 대응	
	newbuffer BYTE 11 DUP (?)					;decipher한 문자열 저장
	nextline WORD 0a0dh							;개행할때 사용
	A_standard BYTE "A"							;기준이되는 A

.code
main PROC
	mov edx, OFFSET filename
	call CreateOutputFile
	mov fileHandle,eax
	
	mov ecx, Num_Str
	mov esi, 0
	L1:
		push ecx
		mov ecx, 11	;10개의 문자와 EOS까지 11번 반복
		mov eax, 0	;newbuffer의 index역할
		L2:
			;decipher
			mov edx, 0
			mov dl, [Cipher_Str + esi]
			sub dl, A_standard			;edx에는 alphas에서 검색할 index저장됨
			mov bl, [alphas + edx]
			mov [newbuffer+ eax], bl	;decipher된 문자 하나를 newbuffer의 해당되는 곳에 저장
			add esi, 1
			add eax, 1

		loop L2

			mov eax, fileHandle
			mov edx, OFFSET newbuffer
			mov ecx, 10					;EOS빼고 10개문자 출력
			call WriteToFile

			mov eax, fileHandle
			mov edx, OFFSET nextline
			mov ecx, 2					;개행
			call WriteToFile

			pop ecx
	loop L1

	mov eax, fileHandle
	call CloseFile

	exit
main ENDP
END main
TITLE s191656HW03

;�ۼ��� : 20191656 õȣ��
;���	: ũ�Ⱑ 10�� �Ϸ��� cipher ���ڿ����� �־����� ��, �̸� decipher�� ���ڿ����� ���Ͽ� ���Ͽ� ����
;�Է�	: CSE3030_PHW03.inc�� 10 ���� ���ڷ� ������ cipher text��
;���	: cipher text���� decipher�� ���ڿ����� ���Ͽ� ���Ͽ� ����

COMMENT @
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"�� �� ���ڵ��� decipher�ϸ�,
	"QRSTUVWXYZABCDEFGHIJKLMNOP"�� �� ���ڵ�� ������� �����ȴٴ� ���� �̿��Ѵ�
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW03.inc

.data
	filename BYTE "0s191656_out.txt",0
	fileHandle DWORD ?
	alphas BYTE "QRSTUVWXYZABCDEFGHIJKLMNOP"	;"ABCDEFGHIJKLMNOPQRSTUVWXYZ"�� ����	
	newbuffer BYTE 11 DUP (?)					;decipher�� ���ڿ� ����
	nextline WORD 0a0dh							;�����Ҷ� ���
	A_standard BYTE "A"							;�����̵Ǵ� A

.code
main PROC
	mov edx, OFFSET filename
	call CreateOutputFile
	mov fileHandle,eax
	
	mov ecx, Num_Str
	mov esi, 0
	L1:
		push ecx
		mov ecx, 11	;10���� ���ڿ� EOS���� 11�� �ݺ�
		mov eax, 0	;newbuffer�� index����
		L2:
			;decipher
			mov edx, 0
			mov dl, [Cipher_Str + esi]
			sub dl, A_standard			;edx���� alphas���� �˻��� index�����
			mov bl, [alphas + edx]
			mov [newbuffer+ eax], bl	;decipher�� ���� �ϳ��� newbuffer�� �ش�Ǵ� ���� ����
			add esi, 1
			add eax, 1

		loop L2

			mov eax, fileHandle
			mov edx, OFFSET newbuffer
			mov ecx, 10					;EOS���� 10������ ���
			call WriteToFile

			mov eax, fileHandle
			mov edx, OFFSET nextline
			mov ecx, 2					;����
			call WriteToFile

			pop ecx
	loop L1

	mov eax, fileHandle
	call CloseFile

	exit
main ENDP
END main
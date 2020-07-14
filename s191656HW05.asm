TITLE s191656HW05

;�ۼ��� : 20191656 õȣ��
;���	: ���ڿ��κ��� ���� ������ �����ϰ� �̵��� ��� ���� ���� ����Ѵ�
;�Է�	: ���� ������ �ϳ��� ���ڿ��� �Է�
;���	: ���� ������ ��� ���� ���� ���

INCLUDE Irvine32.inc

.data
	prompt BYTE "Enter numbers(<ent> to exit) :",0
	ending BYTE "Bye!",0

	BUF_SIZE EQU 256
	inBuffer BYTE BUF_SIZE DUP(?)			; input string buffer(EOS is 0) <- 256 BYTE
	inBufferN DWORD ?						; string size(excluding EOS)  <-�Է��� ���ڿ�ũ�⸸ŭ
	intArray SDWORD BUF_SIZE/2 DUP(?)		; integer array	<- �Էµ� ���ڵ��� ������ �迭
	
.code
main PROC
	L1:										;�ƹ� �Է¾��� enter�� ������ ������ ���ѹݺ�
		mov edx, OFFSET prompt
		call writestring
		call crlf							;������Ʈ ���

		mov esi, 0							;esi <- flag���� (��ĭ�� �� 0, ��ĭ�� �ƴ� �� 1), �Լ� transf���� �̿��Ѵ�(41��° �ٿ��� ȣ��)
		mov ebx, 0							;ebx <- �ԷµǴ� ������ ����(intArrayN����), �ʱ갪 0���� ����
		
		mov edx, OFFSET inBuffer
		mov ecx, SIZEOF inBuffer
		call Readstring						;���ڿ� �Է¹��� ( inBuffer�� ���ڿ� ����� )

		mov inBufferN, eax					;inBufferN���� �Էµ� ������ ����ȴ�(EOS ����)
		cmp eax, 0							;���͸� ģ���� Ȯ��
		jz breaked							;���͸� ������ ���ڿ��Է¹޴� �ݺ��� Ż��(65��° �ٷ�)

		mov edi, OFFSET intArray			;edi <- ���ڵ��� ������ �迭�� �ּ�
		mov ecx, inBufferN					;ecx <- �Է��� ���ڿ� ����
		mov edx, OFFSET inBuffer			;edx <- �Է��� ���ڿ��� �ּ�

		call transf							;�Լ��� ȣ���� ���ڵ��� ������ �� edi�� ����Ű�� �迭�� �����Ų��(72��° �� ����)
		
		
		mov edi, 0							;edi�� ���� ���ڵ��� ����� �� ����ϴ� index�� �̿�	
		mov ecx, ebx						;�Լ� ������ ebx�� �Էµ� ���ڵ��� ������ ���������Ƿ� �̸� ecx�� �־� loop�� �̿�
		mov eax, 0							;eax�� ���ڵ��� ���� �����ϱ� ���� 0���� ���� �ʱ�ȭ	
		cmp ecx, 0							;���ڰ� �������� �ʰ� ��ĭ�鸸 �ִ��� Ȯ��
		jz nothing							;��ĭ�鸸 �ִٸ� nothing(62��° ��)���� �̵�
		print:
			add eax, SDWORD PTR [intArray+edi]
			add edi, 4						;���ڵ��� ���������� eax(�ʱⰪ 0)�� ���Ͽ� ������ eax�� �����Ѵ�
		loop print

		cmp eax, 0							;������ �������� Ȯ��(������ ��ȣ�� ���̰�, ����� ��ȣ�� ������ �����Ƿ�)
		jl negative
			call writedec					;�����϶� ��ȣ �ٿ��� ���
			jmp end_last
		negative:
			call writeint					;����϶� ��ȣ ���� ���
		end_last:
			call crlf						;�ٹٲ�
		nothing:
	jmp L1
		
	breaked:
	mov edx, OFFSET ending	
	call writestring						;���� ������Ʈ ���
	exit
main ENDP


transf PROC
	Lcheck:
		cmp byte ptr [edx], 20h				;edx�� ����Ű�� ���� �������� Ȯ��
		jnz next							;������ �ƴ϶�� next(82��° ��)�� �̵�

		cmp esi, 0							;������ �� esi(flag)�� 0���� Ȯ��
		jz continue							;������ �� esi(flag)�� 0�̶�� continue(93��° ��)�� �̵�
		mov esi, 0							;������ �� esi(flag)�� 0�� �ƴ϶�� esi(flag)�� 0���� �����
		jmp continue						;������ �� esi(flag)�� 0���� ���� �������� continue(93��° ��)�� �̵�
		
		next:								;������ �ƴ� �� ���� label
			cmp esi, 0						;������ �ƴ� �� esi(flag)�� 0���� Ȯ��
			jnz nott						;������ �ƴ� �� esi(flag)�� 0�� �ƴ϶�� nott(92��° ��)�� �̵�
			call Parseinteger32				;������ �ƴ� �� esi(flag)�� 0�̶�� �� �κп��� ���ڰ� ���۵ǹǷ� Parseinteger32 ȣ��
			
			mov DWORD PTR [edi], eax		;���ڷ� ������ ���� edi�� ����Ű�� ���� �־��ش�

			add edi, 4						;integer array���� edi�� ���� ��ġ�� ����Ű���� �Ѵ�
			mov esi, 1						;esi(flag)�� 1�� ����(������ �ƴϹǷ�)
			add ebx, 1						;"number of integers stored in intArray"(ebx)�� 1������Ų��
		nott:
		continue:
			add edx, 1						;input string buffer���� ���� ��ġ�� ����Ű���� �Ѵ�	
	loop Lcheck
	ret										;ebx���� "number of integers stored in intArray"�� ����ȴ�
transf ENDP

END main
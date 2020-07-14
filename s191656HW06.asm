TITLE s191656HW06

;�ۼ��� : 20191656 õȣ��
;���	: ���Կ� �� �� ���� �Ÿ��� ���� �ּҰ� �Ǵ� ���Ը� �����Ͽ� �� ���Կ� �� �� ���� �Ÿ��� ���� ����Ѵ�
;�Է�	: ���� ��ġ�� ��Ÿ���� ���� ����Ʈ�� �ϳ��� ���ڿ��� �Է�
;���	: ������ ���Կ� �� ���� ���� �Ÿ��� �� �߿��� �ּڰ��� ���

COMMENT @
	HW05�� ���� ������� intArray�� �� ���� ��ġ�� ������ ��, �ݺ����� ����, distanceArray��
	�ش�Ǵ� ��ġ�� ���Ը� �������� �� �� ���Կ� �� ���� ���� �Ÿ��� ���� �����Ѵ�.
	���Ŀ� bubble sort�� ����Ͽ� distanceArray�� �Ǿտ� �Ÿ��� ���� �ּҰ��� ��ġ��Ű��,
	�� ���� ����Ѵ�
@

INCLUDE Irvine32.inc

.data
	prompt BYTE "Enter numbers(<ent> to exit) :",0
	ending BYTE "Bye!",0

	BUF_SIZE EQU 256
	inBuffer BYTE BUF_SIZE DUP(?)			; input string buffer(EOS is 0) <- 256 BYTE
	inBufferN DWORD ?						; string size(excluding EOS)  <-�Է��� ���ڿ�ũ�⸸ŭ
	intArray SDWORD BUF_SIZE/2 DUP(?)		; integer array	<- �Էµ� ���ڵ�(���� ��ġ)�� ������ �迭
	distanceArray SDWORD BUF_SIZE/2 DUP(?)	; integer array <- �ش�Ǵ� ��ġ�� ���Կ� �� ���� ���� �Ÿ��� ���� ������ �迭

.code
main PROC
	L1:										;�ƹ� �Է¾��� enter�� ������ ������ ���ѹݺ�
		mov edx, OFFSET prompt
		call writestring
		call crlf							;������Ʈ ���

		mov esi, 0							;esi <- flag���� (��ĭ�� �� 0, ��ĭ�� �ƴ� �� 1), �Լ� transf���� �̿��Ѵ�(49��° �ٿ��� ȣ��)
		mov ebx, 0							;ebx <- �ԷµǴ� ����(���� ��ġ)�� ����(intArrayN����), �ʱ갪 0���� ����
		
		mov edx, OFFSET inBuffer
		mov ecx, SIZEOF inBuffer
		call Readstring						;���ڿ� �Է¹��� ( inBuffer�� ���ڿ� ����� )

		mov inBufferN, eax					;inBufferN���� �Էµ� ������ ����ȴ�(EOS ����)
		cmp eax, 0							;���͸� ģ���� Ȯ��
		jz breaked							;���͸� ������ ���ڿ��Է¹޴� �ݺ��� Ż��(94��° �ٷ�)

		mov edi, OFFSET intArray			;edi <- ����(���� ��ġ)���� ������ �迭�� �ּ�
		mov ecx, inBufferN					;ecx <- �Է��� ���ڿ� ����
		mov edx, OFFSET inBuffer			;edx <- �Է��� ���ڿ��� �ּ�

		call transf							;�Լ��� ȣ���� ����(���� ��ġ)���� ������ �� edi�� ����Ű�� �迭�� �����Ų��(137��° �� ����)
											;�Լ�ȣ�� ���� ebx <- ���� ����, intArray�� ����(���� ��ġ)�� �����
		
		mov edi, 0							;edi�� ���� �迭�ȿ��� '���Է� ���� ��'�� ��ġ�� ������ index�� �̿�	
		mov ecx, ebx						;�Լ� ������ ebx�� '�Էµ� ���� ����'�� ���������Ƿ� �̸� ecx�� �־� loop�� �̿�
			
		cmp ecx, 0							;���ڰ� �������� �ʰ� ��ĭ�鸸 �ִ��� Ȯ��
		jz nothing							;��ĭ�鸸 �ִٸ� nothing(91��° ��)���� �̵�


		cnt_distance:						;������ ���� �����ϱ� ���� ebx(���� ����)��ŭ �ݺ�
			push ecx
			mov eax, 0						;eax�� '���Է� ���� ��' �������� �� ������ �Ÿ��� ������ �����ϱ� ���� 0���� ���� �ʱ�ȭ
			mov esi, 0						;each_distance(65��° ��)���� �� ���� ��ġ�� index������ �ϱ����� 0���� ���� �ʱ�ȭ
			mov ecx, ebx					;65��° �ٿ��� ������ ����(ebx)��ŭ �ݺ��ϱ� ����

			each_distance:					;������ ����(ebx)��ŭ �ݺ�
				mov edx, [intArray+edi]
				sub edx, SDWORD PTR [intArray+esi]
				cmp edx, 0					;[intArray+edi](����) - [intArray+esi](��)�� ������� check
				jg plus						;������ plus(71��° ��)�� �̵�
				neg edx						;������� ��ȣ�� �ٲ��ش�(�Ÿ��� �����̹Ƿ�)
				plus:
				add eax, edx				;eax�� �Ÿ��� �����ش�

				add esi,4					;esi�� ���� ���� ������ �� �ֵ��� �Ѵ�(if ���԰� �ڱ��ڽ��� �����ص� �Ÿ��� 0�̹Ƿ� ���� ����ó������ �ʴ´�)
			loop each_distance
			mov [distancearray+edi], eax	;distance[edi]�� ��ġ�� �� ��ġ�� ���Ը� �������� �ٸ� ���鰣�� �Ÿ��� ������ �����Ų��

			add edi, 4						;edi�� '���Է� ���� ���� ��'�� ������ �� �ֵ��� �Ѵ�
			pop ecx
		loop cnt_distance
											;distancearray�迭���� �� ��ġ�� ���Ը� ������ ���� �ٸ����鰣�� �Ÿ��� ������ �����

		mov edx, OFFSET distancearray		;edx <- �� ��ġ�� ���Ը� ������ ���� �ٸ����鰣�� �Ÿ��� ������ ����� �迭�� �ּ�
		call bubble_sort					;bubble sort�� ���� [distancearray]�ڸ��� �Ÿ����� �ּڰ��� ��ġ��Ų��

		mov eax, [distancearray]
		call writedec						;���� ���� '���Կ� �� ���� ���� �Ÿ��� ��'�� ��ȣ ���� ���	
		call crlf							;�ٹٲ�


		nothing:
	jmp L1
		
	breaked:
	mov edx, OFFSET ending	
	call writestring						;���� ������Ʈ ���
	exit
main ENDP


bubble_sort PROC
	;���: �迭�� ���ڵ��� ������������ sorting�Ѵ�
	;�Է�: edx <- ���ڵ��� ����� �迭�� �ּ�, ebx <- ����� ���ڵ��� ����
	;���: X	
	
	mov ecx, ebx							;big_loop(108��° ��)�� ����� ���ڵ��� ������ŭ �ݺ���Ű�� ����

	big_loop:								;����� ���ڵ��� ������ŭ �ݺ�
	push ecx
	mov esi,0								;�迭�ȿ��� �� ���ڵ��� �����ϱ� ���� index�� ���, big_loop�������� 0���� �ʱ�ȭ
	
	mov ecx,ebx								
	sub ecx, 1								;small_loop(115��° ��)�� [����� ���ڵ��� ���� - 1]��ŭ �ݺ���Ű�� ����
			
		small_loop:							;[����� ���ڵ��� ���� - 1]��ŭ �ݺ�
			mov eax, [edx+esi]
			cmp eax, SDWORD PTR [edx+esi+4]
			jb not_change					;[edx+esi] < [edx+esi+4]���� Ȯ���ϰ� �´ٸ� not_change(127��° ��)�� �̵�

			push ebx						;ebx�� �ӽ÷� ����ϱ�����
			mov eax, [edx+esi]
			mov ebx, [edx+esi+4]
			mov [edx+esi], ebx
			mov [edx+esi+4], eax			;[edx+esi] >= [edx+esi+4]�̶�� [edx+esi]�� [edx+esi+4]�� ���� ��ȯ�Ѵ�
			pop ebx							;�ӽ÷� ����� ebx�� ���� �������´�

			not_change:
			add esi,4						;esi�� ���� ���ڸ� ������ �� �ֵ��� �Ѵ�
		loop small_loop

	
	pop ecx		
	loop big_loop
	ret										;edx�� ����Ű�� �迭���� ���ڵ��� ������������ ���ĵȴ�
bubble_sort ENDP

transf PROC
	;��� : ���ڿ����� ���ڵ��� �̾� �迭�� �����ϰ� ����� ���ڵ��� ������ ��ȯ
	;�Է� : edi <- ���ڵ��� ������ �迭�� �ּ�, ecx <- �Է��� ���ڿ� ����,  edx <- �Է��� ���ڿ��� �ּ�
	;��� : ebx <- edi�� ����Ű�� �迭�� ����� ���ڵ��� ����

	Lcheck:
		cmp byte ptr [edx], 20h				;edx�� ����Ű�� ���� �������� Ȯ��
		jnz next							;������ �ƴ϶�� next(151��° ��)�� �̵�

		cmp esi, 0							;������ �� esi(flag)�� 0���� Ȯ��
		jz continue							;������ �� esi(flag)�� 0�̶�� continue(162��° ��)�� �̵�
		mov esi, 0							;������ �� esi(flag)�� 0�� �ƴ϶�� esi(flag)�� 0���� �����
		jmp continue						;������ �� esi(flag)�� 0���� ���� �������� continue(162��° ��)�� �̵�
		
		next:								;������ �ƴ� �� ���� label
			cmp esi, 0						;������ �ƴ� �� esi(flag)�� 0���� Ȯ��
			jnz nott						;������ �ƴ� �� esi(flag)�� 0�� �ƴ϶�� nott(161��° ��)�� �̵�
			call Parseinteger32				;������ �ƴ� �� esi(flag)�� 0�̶�� �� �κп��� ���ڰ� ���۵ǹǷ� Parseinteger32 ȣ��
			
			mov DWORD PTR [edi], eax		;���ڷ� ������ ���� edi�� ����Ű�� ���� �־��ش�

			add edi, 4						;���ڵ��� ������ �迭���� edi�� ���� ��ġ�� ����Ű���� �Ѵ�
			mov esi, 1						;esi(flag)�� 1�� ����(������ �ƴϹǷ�)
			add ebx, 1						;edi�� ����Ű�� �迭�� ����� ���ڵ��� ����(ebx)�� 1������Ų��
		nott:
		continue:
			add edx, 1						;�Է��� ���ڿ����� ���� ��ġ�� ����Ű���� �Ѵ�	
	loop Lcheck
	ret										;ebx���� 'edi�� ����Ű�� �迭�� ����� ���ڵ��� ����'�� ����ȴ�
transf ENDP

END main
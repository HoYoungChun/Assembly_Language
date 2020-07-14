TITLE s191656HW04

;�ۼ��� : 20191656 õȣ��
;���	: ������ ������ �߿��� ���� �� ���̰� ū �������� ���̸� ���Ѵ�.
;�Է�	: CSE3030_PHW04.inc�� ���� ������ ������ ������� ����
;���	: �� �׽�Ʈ�� ���Ͽ� ������ �� �� ���̰� ���� ū ���� ���Ͽ� ����Ѵ�.

COMMENT @
	1. �켱 �� test�� ������ �� �ִ� �� ���̸� 0���� �����ϰ� �����Ѵ�.
	2. �׸��� �� test���� ������ ���� �����ϰ� ������ �� �ڰ� ������ ������ üũ�� ��,
	3. ���������̶�� �� ���̸� ���Ͽ� �� ����� �ִ� �� ���̿� ���ϰ�,
	4. ���� �� ���ٸ� �ִ� �� ���̸� ��ü�Ѵ�.
	5. �̷������� �� test�� ��ģ�� �ִ� �� ���̸� ����ϴ� ������� �����Ѵ�.
@

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW04.inc

.data
	HN DWORD 0			;�� test������ �� ����
	start DWORD 0		;�� test�ȿ��� �������� �� �������� ������
	endd DWORD 0		;�� test�ȿ��� �������� �� �������� �ְ���
	endtest DWORD 0		;�� test�� ���� Ȯ��(index�� Ȯ���Ѵ�, 38��° �� ����)
.code
main PROC
	mov esi, 0			;esi�� HEIGHT�������� �ϴ� index����
	mov ebx, CASE
	mov HN, ebx			;HN���� ù ��° test�� ���������� ������ ����
	mov ecx, TN			;L1 loop�� TN��ŭ �ݺ��ǵ��� ����
	
	L1:							;TN��ŭ �ݺ�
		push ecx				;L1�� ecx����
		
		mov ecx,HN
		dec ecx					;L2 loop�� HN-1��ŭ �ݺ��ǵ��� ����(������ ���� ���ܽ�Ű�� �������� �ݺ��ǵ���)
		mov edx, 0				;edx���� �� test���� �� ���̰� ���� ū ���� �����Ѵ�(test������ �� 0���� �ʱ�ȭ)
		
		mov ebx,HN				;HEIGHT�������� index�� esi+4*(HN-1)�� �� �� test�� ������ ������ �̿��Ѵ�.
		dec ebx	
		add ebx, ebx
		add ebx, ebx			
		add ebx, esi			;ebx <- esi+4*(HN-1) 
		mov endtest, ebx		;endtest���� ��test�� ������ ���� Ȯ���� ��(esi+4*(HN-1))�� ����
		
		L2:						;HN-1��ŭ �ݺ�(������ ���� ���ܽ�Ű�� �������� �ݺ�)
			push ecx			;L2�� ecx����
			mov edi, 0			;edi�� �� test�ȿ��� �� ���� �������� �ϴ� index����(�� ������ ������ �� 0���� �ʱ�ȭ)
			mov ecx,HN			;L3 loop�� HN��ŭ �ݺ��ǵ��� ����
			
			mov ebx, HEIGHT[esi]
			mov start,ebx		;start���� index�� esi��ġ�� �ش��ϴ� ������ �����Ѵ�

				L3:									;HN��ŭ�ݺ�(loop �������� 90��° �ٿ��� HN=HN-1 ���ش�)(���� test������ ħ������ �ʵ���)
				mov ebx,esi
				add ebx,edi							;ebx <- esi + edi
				CMP ebx, endtest					;������ ���� �����ߴ��� Ȯ��(�����ߴٸ� ������ ���� �������� �ְ���)
													;(������ ���� �����ϰ� �����ϰ� �����Ƿ� �����ߴٸ� �������̱� ������)
				JNZ k_1								;������ ���� �ƴ϶�� k_1(68��° ��)�� �̵�
					mov ebx, HEIGHT[esi+edi]
					mov endd, ebx					;endd <- HEIGHT[esi+edi](endd�� ������ ���� ���̸� ����)
					mov ebx, start
					sub endd,ebx					;endd���� ���� �������� �� ���̰� ����ȴ�
					CMP endd, edx					;���� �ִ밪���� ������ Ȯ��
					JBE k_2							;�۴ٸ� k_2(66��° ��)�� �̵�
						mov edx,endd				;ũ�ٸ� �ִ� �� ����(edx) ��ü
					k_2:
					jmp breaked						;esi�� ����Ű�� ���� ���� ������ �������Ƿ� L3Ż��(88��° �ٷ� �̵�)			
				k_1:								;������ ���� �ƴ� ��
				mov ebx,HEIGHT[esi+edi+4]			
				cmp HEIGHT[esi+edi],ebx				;HEIGHT[esi+edi]�� HEIGHT[esi+edi+4]���� ������ Ȯ��(=���������� check)
				JB k_3								;�۴ٸ� k_3(82��° ��)�� �̵�
					mov ebx, HEIGHT[esi+edi]		
					mov endd, ebx					;endd <- HEIGHT[esi+edi](�������� �ְ����� ����)
					mov ebx, start
					sub endd,ebx					;endd���� ���� �������� �� ���̰� ����ȴ�
					CMP endd, edx					;���� �ִ밪���� ������ Ȯ��
					JBE k_4							;�۴ٸ� k_4(79��° ��)�� �̵�
						mov edx, endd				;ũ�ٸ� �ִ� �� ����(edx) ��ü
					k_4:
					jmp breaked						;esi�� ����Ű�� ���� ���� ������ �������Ƿ� L3Ż��(88��° �ٷ� �̵�)

				k_3:								;esi�� ����Ű�� ���� �޺κ��� �������� ��
				add edi,4							;index�� ������Ų�� �޺κ��� ��� ���������� Ȯ���Ѵ�
				
				
				loop L3

				breaked:		;L3�� Ż������ �� �̵��Ǵ� ���̴�
			add esi, 4			;esi�� �������� ���� ���� ���� ���캻��.
			sub HN,1			;HN�� 1���ҽ��� L3�� loopȽ���� 1���δ�.
			pop ecx				;L2�� ecx �ҷ�����
		loop tmp_1
		jmp tmp_2
		tmp_1:
			jmp L2
		tmp_2:

		
		mov eax,edx				;eax <- �� test���� �� ���̰� ���� ū ��(edx)
		call writeDec			;�� test���� �� ���̰� ���� ū �� ���
		call crlf				;�ٹٲ�

		sub endtest, 4			;���� test�� endtest�� esi+4*(HN-1)�� Ȯ���ϱ� ���Ͽ� endtest-=4 ����
		add esi,4				;next test�� �̵�
		mov ebx, HEIGHT[esi]	;ebx <- ���� test�� ������
		mov HN,ebx				;HN���� ���� test�� ������ ����
		add esi, 4				;index�� esi�� ���� ����Ű�� ���� ���� test�� ù ��° ���� �ǵ��� �Ѵ�
		pop ecx					;L1�� ecx �ҷ�����

	loop tmp1
	jmp tmp2
	tmp1:
		jmp L1
	tmp2:

	exit
main ENDP
END main
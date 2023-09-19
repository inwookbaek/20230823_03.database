/*
	단일행함수(Single Function)
	
	A. 문자열함수
	
	1. upper/lower : 대소문자변환함수 upper('abcde') -> ABCDE, lower('ABCDE') -> abcde 
	2. initcap : 첫 글자를 대문자로 나머지는 소문자로 변환 initcap('aBcDe') -> Abcde
	3. length  : 문자열의 길이를 리턴, length('abcde') -> 5, length('한글') -> 2
	4. lengthb : 문자열의 byte단위의 길이를 리턴, length('abcde') -> 5, length('한글') -> 6(utf-8기준)
	5. concat  : 문자열연결함수(||연산자와 동일), concat('a', 'b') -> ab
	6. substr  : 주어진 문자열에서 특정 위치의 문자를 추출, substr('aBcDe',2,2) -> Bc
	7. substrb : 주어진 문자열에서 특정 위치의 byte를 추출
							 substrb('한글', 1, 2) -> 문자셋이 euc-kr(2byte)라면 '한'
							 substrb('한글', 1, 2) -> 문자셋이 utf-8(3byte)라면 한글이 깨져서 리턴 
  8. instr   : 주어진 문자열에서 특정문자의 위치를 리턴 instr('A*B#C#D', '#') -> 4
	9. instrb  : 주어진 문자열에서 특정문자의 byte위치를 리턴 instr('안녕하세요?', '하') -> 7
 10. lpad    : 주어진 문자열에서 특정문자를 앞에서 부터 채움 lpad('love', 6, '*') -> **love
 11. rpad    : 주어진 문자열에서 특정문자를 뒤에서 부터 채움 rpad('love', 6, '#') -> love##
 12. ltrim   : 주어진 문자열에서 특정문자를 앞에서 삭제 ltrim('*love', '*') -> love
 13. rtrim   : 주어진 문자열에서 특정문자를 뒤에서 삭제 rtrim('love#', '#') -> love
 14. replace : 주어진 문자열에서 특정문자를 치환, replace('AB', 'A', 'C') -> CB
*/
select 'aBcDe', initcap('aBcDe') from dual;
select 'aBcDe', length('aBcDe'), length('한글') from dual;
select 'aBcDe', lengthb('aBcDe'), lengthb('한글') from dual;
select substr('aBcDe', 2, 2), substr('한글', 1,1) from dual
union all
select substrb('aBcDe', 2, 2), substrb('한글', 1,3) from dual;
select instr('A*B#C#D', '#') from dual;
select instrb('안녕하세요?', '하')  from dual;
select lpad('love', 6, '*'), rpad('love', 6, '#')  from dual;
select ltrim('**love', '*'), rtrim('love##', '#')  from dual;
select replace('AB', 'A', 'C')  from dual;

-- 1. lower/upper
select ename from emp;
select lower(ename) from emp;
select upper(lower(ename)), lower(ename) from emp;

-- 2. initcap
select initcap(ename) from emp;

-- 3. length/lengthb
select ename, length(ename) from emp;
select length('소향'), lengthb('소향') from dual;

-- 4. concat, ||
select name, id
     , concat(name, id)
     , concat(concat(name, ' - '), id) "name - id"
		 , concat(concat('홍길동의 직업은 ', '의적입니다!'), '주소는 한양조선입니다') as 홍길동
		 , name || ' - ' || id "name - id"
		 , '홍길동의 직업은 ' || '의적입니다!' || '주소는 한양조선입니다' as 홍길동
  from professor;

-- 5. substr(값, from, length), substrb(값, from, length)
-- from값이 음수일 경우는 뒤에서 부터 처리
select 'abcde'
  from dual;















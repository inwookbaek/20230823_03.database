/*
 단일행함수 (Single Function)
 
 A. 문자열함수
 
 1. upper / lower :대소문자변환함수 upper('abcde') -> ABCDE, lower('ABCDE') -> abcde
 2. initcap       : 첫 글자를 대문자로 나머지는 소문자로 변환 initcap('aBcDe') -> Abcde
 3. length        : 문자열의 길이를 리턴, length('abcde') -> 5, length('한글') -> 2 
 4. lengthb       : 문자열의 byte단위의 길이를 리턴, length('abcde') -> 5, length('한글') -> 6(utf-8 기준)
 5. concat        : 문자열 연결함수( ||연산자와 동일), concat('a', 'b') -> ab
 6. substr        : 주어진 문자열에서 특정 위치의 문자를 추출, substr('abcde', 2, 2) -> Bc
 7. substrb       : 주어진 문자열에서 특정 위치의 byte를 추출,
							      substrb('한글', 1, 2) -> 문자셋이 euc-kr(2byte)라면 '한'
							      substrb('한글', 1, 2) -> 문자셋이 utf- 8(2byte)라면 한글이 깨져서 리턴
 8. instr         : 주어진 문자열에서 특정문자의 위치를 리턴 instr('A*B#C#D', '#') -> 4
 9. instrb        : 주어진 문자열에서 특정문자의 byte위치를 리턴 instrb('안녕하세요?', '하') -> 7
 10. lpad         : 주어진 문자열에서 특정문자를 앞에서 부터 채움 lpad('love', 6, '*') -> **love 
 11. rpad         : 주어진 문자열에서 특정문자를 뒤에서 부터 채움 rpad('love', 6, '#') -> love## 
*/

select 'aBcDe', initcap('aBcDe') from dual;
select 'aBcDe', length('aBcDe'), length('한글') from dual;
select 'aBcDe', lengthb('aBcDe'), lengthb('한글') from dual;
select substr('aBcDe', 2, 2), substr('한글', 1, 1) from dual;
union all
select substrb('aBcDe', 2, 2), substrb('한글', 1, 3) from dual;
select instr('A*B#C#D', '#') from dual;
select instrb('안녕하세요?', '하') from dual;
select lpad('love', 6, '*') from dual;
select rpad('love', 6, '#') from dual;
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

-- 5. substr(값, from [, length]), substrb(값, from [, length])
-- from값이 음수일 경우는 뒤에서 부터 처리
select 'abcdef'
     , substr('abcdef', 3) cdef
     , substr('abcdef', 3, 2) cd
     , substr('abcdef', -3) def		
		 , substr('abcdef', -3, 2) de	
  from dual;
	
select '홍길동'
     , substr('홍길동', 1, 1) 홍
     , substrb('홍길동', 1, 1) 홍xx
     , substrb('홍길동', 1, 2) 홍xx
     , substrb('홍길동', 1, 3) 홍	 
  from dual; 

-- 실습. ssn 991118-1234567에서 성별만 추출해보기
select '991118-1234567' ssn
     , substr('991118-1234567', 8, 1) as gender
  from dual;
	
-- 실습. student 테이블에서 주민번호에서 성별 추출해보기
select * from student;
select name, jumin, substr(jumin, 7, 1) gender from student;

-- 6. instr(문자열, 검색글자, from(기본값 1), 몇 번째(기본값 1))
-- 검색글자의 위치를 리턴, 시작위치가 음수면 뒤에서 부터
select 'A*B*C*D'
     , instr('A*B*C*D', '*') "2nd"
     , instr('A*B*C*D', '*', 3) "4th"	
		 , instr('A*B*C*D', '*', 1, 2) "4th" -- 처음부터 검색해서 결과가 2번째인 *의 위치
		 , instr('A*B*C*D', '*', -5, 1) "2nd" -- 뒤에서부터 역순으로 검색해서 결과가 1번째인 *의 위치
		 , instr('A*B*C*D', '*', -1, 2) "4th" 
  from dual;

-- 실습. 문자열 'HELLO WORLD'
-- HELLO의 O의 위치, WORLD의 O의 위치를 검색
-- 정순/역순으로 
select 'HELLO WORLD'
     , instr('HELLO WORLD', 'O') "5th"
		 , instr('HELLO WORLD', 'O', -1, 2) "5th"
     , instr('HELLO WORLD', 'O', 1, 2) "8th"
		 , instr('HELLO WORLD', 'O', -1, 1) "8th"		 
  from dual;

-- 7. lpad(문자열, 자리수[, 채울문자]) / rpad(문자열, 자리수[, 채울문자])
-- 채울문자의 기본값은 공란
select name, id, length(id)
		 , lpad(id, 10) -- 기본값 공란
		 , lpad(id, 10, '*')
		 , rpad(id, 10, '*')
		 , lpad(id, 30, '*')
		 , rpad(id, 30, '*')		 
  from student
 where deptno1 = 101;
 
-- 8. ltrim/rtrim/trim(양쪽)
select '   xxx   '
     , trim('   xxx   ')  "XXX"
     , ltrim('   xxx   ') "XXX---"
     , rtrim('   xxx   ')	"---XXX"	 
  from dual;
 
select ename
     , ltrim(ename, 'C')
		 , rtrim(ename, 'R')
  from emp;

-- 9. replace(문자열, 변경전문자, 변경후문자)
select ename
     , replace(ename, 'KI', '**')
		 , replace(ename, 'I', '..............')

  from emp;
	
-- 실습. 이름 앞 2자리를 **로 치환, **NG, **ITH, **LEN
-- substr(), replace()
select ename
     , substr(ename, 1, 2)
		 , replace(ename, substr(ename, 1, 2), '**')
  from emp;

-- 연습문제
-- ex01) student 테이블의 주민등록번호 에서 성별만 추출
select name, jumin
	   , substr(jumin, 7, 1)
	from student;
	
-- ex02) student 테이블의 주민등록번호 에서 월일만 추출
select name, jumin
	   , substr(jumin, 1, 2) as 출생년도
	   , substr(jumin, 3, 2) as 출생월
	   , substr(jumin, 5, 2) as 출생일
		 , substr(jumin, 1, 2) || '년' || substr(jumin, 3, 2) || '월' || substr(jumin, 5, 2) || '일'		
	from student;

-- ex03) student 테이블에서 70년대에 태어난 사람만 추출
select name, jumin
	   , substr(jumin, 1, 2) as 출생년도	
	from student
--  where substr(jumin, 1, 2) like '7%';
--  where substr(jumin, 1, 2) between '70' and '79';
 where substr(jumin, 1, 2) >= '70' and  substr(jumin, 1, 2) < '80';

-- ex04) student 테이블에서 jumin컬럼을 사용, 1전공이 101번인 학생들의
--       이름과 태어난월일, 생일 하루 전 날짜를 출력
--       형변환함수, 자동(묵시적)형변환, 수동(명시적)형변환 
--       문자가 숫자로 자동형변환
select sysdate from dual;
select sysdate - 21 from dual;
select sysdate + 21 from dual;

select name, jumin
	   , substr(jumin, 1, 2) as 출생년도
	   , substr(jumin, 3, 2) as 출생월
	   , substr(jumin, 5, 2) as 출생일
		 , substr(jumin, 5, 2) - 1 as 출생전일
		 , substr(jumin, 5, 2) + 30
	from student;

/*
	B. 숫자함수
	
	1. round : 주어진 실수를 반올림
	2. trunc : 주어진 실수를 버림
	3. mod   : 나누기연한수 나머지값
	4. ceil  : 주어진 실수에서 가장 큰 정수값
	5. floor : 주어진 실수에서 가장 작은 정수값
	6. power : 주어진 숫자에서 주어진 승수를 리턴 power(3,3) -> 27
	7. rownum: 오라클에서만 사용되는 속성으로서 모든 객체에 제공된다.
	   ... rownum은 전체열, 즉 *와 같이 사용할 수 없다.
		 ... rownum은 행번호를 의미
*/
-- 1. round(실수, 위치)
select 976.635
		 , round(976.635)
		 , round(976.635, 0)
		 , round(976.635, 1)
		 , round(976.635, 2)
		 , round(976.635, 3)
		 , round(976.635, -1)
		 , round(976.635, -2)
  from dual;
	
-- 2. trunc(실수, 버림위치)
select 976.635
		 , trunc(976.635)
		 , trunc(976.635, 0)
		 , trunc(976.635, 1)
		 , trunc(976.635, 2)
		 , trunc(976.635, 3)
		 , trunc(976.635, -1)
		 , trunc(976.635, -2)
  from dual;	
	
-- 	3. mod, ceil, floor
select 121
     , mod(121, 10)
		 , ceil(121.9)
		 , floor(121.9)
  from dual;

-- 4. power
select '2의 3승 = ' || power(2, 3) from dual union
select '3의 3승 = ' || power(3, 3) from dual;

-- 5. rownum : query결과의 행번호
select rownum, ename from emp;
-- select rownum, * from emp; (x) rownum은 *와 같이 사용할 수 없다.
select rownum, deptno, empno, ename from emp where deptno = 20;


/*
	C. 날짜함수
	
	1. sysdate : 시스템의 현재일자, 날짜형으로 리턴
	2. MONTHS_BETWEEN(date1, date2) : 두 날짜사이의 개월수를 리턴, 숫자형으로 리턴
	3. ADD_MONTHS(date, int) : 주어진 일자에 개월수를 더하기
	4. NEXT_DAY(date, ch) : 주어진 일자를 기준으로 다음요일을 리턴, 날짜형으로 리턴
	5. LAST_DAY(date) : 주어진 일자를 기준으로 해당월의 마지말일을 리턴, 날짜형으로 리턴
	6. ROUND(date, fmt) : 주어진 날짜에서 반올림
	7. TRUNC(date, fmt) : 주어진 날짜에서 버림
*/

-- 1. sysdate
select sysdate from dual;

-- 2. months_between
select months_between(sysdate, '230101') from dual union all
select months_between(sysdate, '20230101') from dual;

-- emp테이블에서 사원의 근속월수?
select sysdate, hiredate, MONTHS_BETWEEN(SYSDATE, HIREDATE) from emp;

-- 3. ADD_MONTHS(date, int)
select sysdate
     , ADD_MONTHS(SYSDATE, 2)
		 , ADD_MONTHS(SYSDATE, -2)
  from dual;

-- 4. NEXT_DAY(date, ch)
select sysdate , NEXT_DAY(SYSDATE, 1) from dual union all -- 1~7:일~토 
select sysdate , NEXT_DAY(SYSDATE, 2) from dual union all -- 월
select sysdate , NEXT_DAY(SYSDATE, 3) from dual union all
select sysdate , NEXT_DAY(SYSDATE, 4) from dual union all
select sysdate , NEXT_DAY(SYSDATE, 5) from dual union all
select sysdate , NEXT_DAY(SYSDATE, 6) from dual union all
select sysdate , NEXT_DAY(SYSDATE, 7) from dual;

-- 5. LAST_DAY(date)
select sysdate , LAST_DAY(SYSDATE) from dual union all 
select sysdate , LAST_DAY('230901') from dual union all 
select sysdate , LAST_DAY('23-09-01') from dual union all 
select sysdate , LAST_DAY('20230901') from dual union all 
select sysdate , LAST_DAY('2023.09.01') from dual union all 
select sysdate , LAST_DAY('2023/09/01') from dual;

-- 6. round/trunc
select sysdate 
     , round(SYSDATE) 
		 , trunc(SYSDATE) 
		 , round('20230901') 
		 , trunc('20230930') 
  from dual;

/*
	D. 형변환함수 - 명시적변환
	
	1. to_char()   : 날짜 or 숫자를 문자로 변환함수
	2. to_number() : 문자형숫자를 숫자로 변환(단, 숫자형식에 맞는 문자열일 경우 변환가능)
	3. to_date()   : 문자형을 날짜로 변환(단, 날짜형식에 맞아야 변환가능)
	
*/

-- 1. 묵시적(자동)형변환
-- 결과가 수치연산으로 모두 4로 출력
select 2 + '2' from dual union all
select '2' + 2 from dual union all
select '2' + '2' from dual;

select 'A' + '2' from dual; -- (x) invalid number 에러

-- 2. 명시적(수동)형변환
-- 1) to_number
select to_number('2') + 2 from dual union all
select 2 + to_number('2') from dual;

select to_number('2a') + 2 from dual; -- (x) ORA-01722: invalid number
select 'A' + '2' from dual; -- (x) ORA-01722: invalid number

-- 2) to_char()
-- a. 날짜를 문자로
select sysdate
     , to_char(sysdate)
		 , to_char(sysdate, 'YYYY') 년도
		 , to_char(sysdate, 'RRRR') 년도
		 , to_char(sysdate, 'YY') 년도
		 , to_char(sysdate, 'RR') 년도
		 , to_char(sysdate, 'yy') 년도
		 , to_char(sysdate, 'YEAR') 년도
		 , to_char(sysdate, 'year') 년도
  from dual;
	
select sysdate
		 , to_char(sysdate, 'MM') 월
		 , to_char(sysdate, 'MON') 월
		 , to_char(sysdate, 'MONTH') 월
		 , to_char(sysdate, 'mm') 월
		 , to_char(sysdate, 'mon') 월
		 , to_char(sysdate, 'month') 월
  from dual;	
	
	
select sysdate
		 , to_char(sysdate, 'DD') 일
		 , to_char(sysdate, 'DAY') 요일
		 , to_char(sysdate, 'DDTH') n번째일
		 , to_char(sysdate, 'dd') 일
		 , to_char(sysdate, 'day') 요일
		 , to_char(sysdate, 'ddth') n번째일
  from dual;	
	
select sysdate
     , to_char(sysdate)  -- 문자열
		 , to_char(sysdate, 'YYYY.MM.DD') 년월일  -- 날짜형
     , to_char(sysdate, 'yyyy.mm.dd') 년월일  -- 날짜형
		 , to_char(sysdate, 'YYYY.MM.DD hh:mi') 년월일시분  -- 날짜형
		 , to_char(sysdate, 'YYYY.MM.DD hh:mi:ss') 년월일시분초  -- 날짜형
		 , to_char(sysdate, 'YYYY.MM.DD hh24:mi:ss') 년월일시분초24시형태  -- 날짜형
		 , to_char(sysdate, 'MM.DD.YY hh:mi:ss') 월일년시분초  -- 날짜형
		 , to_char(sysdate, 'MON.DD.YY hh:mi:ss') 월일년시분초  -- 날짜형
  from dual;
	
-- b. 숫자를 문자로
-- 12345 -> 12,345 or 12,345.00
select 1234
     , to_char(1234, '9999')
		 , to_char(1234, '999999999')
		 , to_char(1234, '099999999')
		 , to_char(1234, '$999999999')
		 , to_char(1234, '$9999.00')
		 , to_char(1234, '9,999')
		 , to_char(123456789, '9,999')
		 , to_char(123456789, '9,999,999,999')
		 , ltrim(to_char(123456789, '9,999,999,999'))
  from dual;
		

/* 연습문제 */
-- ex01) emp테이블에서 ename, hiredate, 근속년, 근속월, 근속일수 출력, deptno = 10;
-- months_between, round, turnc, 개월수계산(/12), 일수계산(/365, /12)

-- ex02) student에서 birthday중 생일 1월의 학생의 이름과 생일을 출력(YYYY-MM-DD)

-- ex03) emp에서 hiredate가 1,2,3월인 사람들의 사번, 이름, 입사일을 출력

-- ex04) emp 테이블을 조회하여 이름이 'ALLEN' 인 사원의 사번과 이름과 연봉을 
--       출력하세요. 단 연봉은 (sal * 12)+comm 로 계산하고 천 단위 구분기호로 표시하세요.
--       7499 ALLEN 1600 300 19,500     

-- ex05) professor 테이블을 조회하여 201 번 학과에 근무하는 교수들의 이름과 
--       급여, 보너스, 연봉을 아래와 같이 출력하세요. 단 연봉은 (pay*12)+bonus
--       로 계산합니다.
--       name pay bonus 6,970

-- ex06) emp 테이블을 조회하여 comm 값을 가지고 있는 사람들의 empno , ename , hiredate ,
--       총연봉,15% 인상 후 연봉을 아래 화면처럼 출력하세요. 단 총연봉은 (sal*12)+comm 으로 계산하고 
--       15% 인상한 값은 총연봉의 15% 인상 값입니다.
--      (HIREDATE 컬럼의 날짜 형식과 SAL 컬럼 , 15% UP 컬럼의 $ 표시와 , 기호 나오게 하세요)

/*
	E. 기타함수

	1. nvl()   : null값을 다른 값으로 치환변수, nvl(comm, 0)
	2. nvl2()  : null값을 다른 값으로 치환변수, nvl2(comm, false, true)
	3. decode(): 오라클에서만 사용되는 함수 if~else과 유사
	4. case    : decode대신에 일반적으로 사용되는 함수 
	
		 case 조건 when 결과1 then 출력1,
		          [when 결과n then 출력n]
	   end as 별칭
*/	
-- 1. nvl()
select name, pay, bonus
     , pay + bonus as total
		 , nvl(bonus, 0)
		 , to_char(pay + nvl(bonus, 0), '999,999') as 총급여
  from professor
 where deptno = 201;

-- 2. nvl2(값, null아니면, null이면)
select name, pay, bonus
     , pay + bonus as total
		 , nvl2(bonus, bonus, 0)
		 , to_char(pay + nvl2(bonus, bonus, 0), '999,999') as 총급여
  from professor
 where deptno = 201;
 
 select ename, sal, comm
      , sal + nvl(comm, 0) 보너스
			, sal + nvl(comm, 100) 
			, nvl2(comm, 'not null', 'null')
			, nvl2(comm, 'comm에 값이 있습니다', ename || '사원은 comm이 없습니다')
   from emp;

 /* 실습 */
-- ex01) Professor 테이블에서 201번 학과 교수들의 이름과 급여, bonus , 총 연봉을 출력하세요. 
--       단 총 연봉은 (pay*12+bonus) 로 계산하고 bonus 가 없는 교수는 0으로 계산하세요
select name, pay
		 , nvl2(bonus, bonus, 0) 보너스
		 , nvl2(bonus, pay*12+bonus, pay*12) 년봉
  from professor;
	
-- ex02) emp 테이블에서 deptno 가 30 번인 사원들을 조회하여 comm 값이 있을 경우
--       'Exist' 을 출력하고 comm 값이 null 일 경우 'NULL' 을 출력하세요 

select ename, sal, comm
     , nvl2(comm, 'Exit', 'Null')
  from emp
 where deptno = 30;

-- 3. decode함수
-- 1) 통상적으로 if~else문을 decode로 표현한 함수로 오라클에서만 사용하는 함수
-- 2) 오라클에서 자주 사용하는 중요한 함수이다.
-- 3) decode(col, ture, false) 즉, col의 결과가 true일경우 true문을 실행, false일 경우 false실행
-- 4) decode(deptno, 101, true,
--                   102, true,
--                   103, true, false) -> if ~ else if ~ else
-- 5) decode(deptno, 101, decode()....)

-- 전공이 101이면 컴퓨터공학과, 아니면 기타학과 출력
select * from department;
select * from professor;

select name, deptno
     , decode(deptno, 101, '컴퓨터공학')  
		   -- if(deptno === 101) { console.log('컴퓨터공학')}
		 , decode(deptno, 101, '컴퓨터공학', '기타학과')
		   -- if(deptno === 101) console.log('컴퓨터공학') else '기타학과'
  from professor;
	
-- 101 컴공, 102 미디융합, 103 소프트웨어공학 나머지는 기타학과
-- if(deptno === 101) console.log('컴퓨터공학')
-- else if(deptno === 102) console.log('미디융합')	
-- else if(deptno === 103) console.log('소프트웨어공학')
-- else console.log('기타학과');
select name, deptno
     , decode(deptno, 101, '컴퓨터공학',
		                  102, '미디어융합',
										  103, '소프트공학',
											'기타학과') as 담당학과 
  from professor; 

-- 중첩decode
-- decode(...., decode()) : if() { if() {} }
-- 101학과 교수중에서 Audie Murphy교수 "Best Professor" 아니면 "Good" 
-- 101학과 이외 학과교수는 N/A로 출력
select name, deptno
     , decode(deptno, 101, 'Best Professor', 'N/A') 
		 , decode(name, 'Audie Murphy', 'Best Professor', 'Good') 
		 , decode(deptno, 101, decode(name, 'Audie Murphy', 'Best Professor', 'Good'), 'N/A') 
  from professor;
	

-- 실습
-- ex01) student에서 전공이 101인 학생들중에 jumin 성별구분해서 
-- 1 or 3=남자 2 or 4=여자를 출력
--       name, jumin, gender	
-- substr, decode
select name, jumin
     , substr(jumin, 7, 1)
		 , decode(substr(jumin, 7, 1), '1', '남자', '여자') gender
		 , decode(substr(jumin, 7, 1), '1', '남자', 
		                               '2', '여자',
																	 '3', '남자', 
																	 '4', '여자') 성별
  from student;

-- ex02) Student 테이블에서 1 전공이 (deptno1) 101번인 학생의 이름과 
--       연락처와 지역을 출력하세요. 단,지역번호가 02 는 "SEOUL" , 
--       031 은 "GYEONGGI" , 051 은 "BUSAN" , 052 는 "ULSAN" , 
--       055 는 "GYEONGNAM"입니다
-- substr, instr, decode
select tel
     , substr(tel, 1, 3)
		 , instr(tel, ')', 1, 1) 우괄호위치
		 , substr(tel, 1, instr(tel, ')', 1, 1)-1)
		 , decode(substr(tel, 1, instr(tel, ')', 1, 1)-1), 
									'02',  '서울',
									'031', '경기',
									'051', '부산',
									'052', '울산',
									'055', '경남',
									'기타') 지역번호	
  from student;
	
-- 4. case문
-- 1) case 조건 when 결과 then 출력.....
select tel
     , substr(tel, 1, 3)
		 , instr(tel, ')', 1, 1) 우괄호위치
		 , substr(tel, 1, instr(tel, ')', 1, 1)-1)
		 , decode(substr(tel, 1, instr(tel, ')', 1, 1)-1), 
									'02',  '서울',
									'031', '경기',
									'051', '부산',
									'052', '울산',
									'055', '경남',
									'기타') 지역번호
		 , case	substr(tel, 1, instr(tel, ')', 1, 1)-1)
						when '02'  then '서울'
						when '031' then '경기'
						when '051' then '부산'
						when '052' then '울산'
						when '055' then '경남'
						else '기타'						
				end as 지역번호
  from student;

-- 2) case when between 값1 and 값2 then 출력....	
-- emp테이블에서 sal 1~1000 5등급, 1001~2000 2등급,... 4001보다 크면 5등급
select ename
     , sal
		 , case when sal between    1 and 1000 then '5등급'
		        when sal between 1001 and 2000 then '3등급'
		        when sal between 2001 and 3000 then '2등급'
		        when sal between 3001 and 4000 then '1등급'
		        when sal > 4001 then '1등급'
		    end 등급
  from emp;

-- 연습문제
-- ex01) student에서 jumin에 월참조해서 해당월의 분기를 출력(1Q, 2Q, 3Q, 4Q)
-- name, jumin, 분기 
select name, jumin
	   , substr(jumin, 3, 2) 월
		 , case when substr(jumin, 3, 2) between '01' and '03' then '1Q'
		        when substr(jumin, 3, 2) between '04' and '06' then '2Q'
						when substr(jumin, 3, 2) between '07' and '09' then '2Q'
						when substr(jumin, 3, 2) between '10' and '12' then '2Q'
			 end as 분기
  from student;

-- ex02) dept에서 10=회계부, 20=연구실, 30=영업부, 40=전산실
-- 1) decode
-- 2) case
-- deptno, 부서명
select deptno
     , decode(deptno, 10, '회계부',
		                  20, '연구실',
										  30, '영업부',
										  40, '전산실') 부서
		 , case deptno
				    when 10 then '회계부'
						when 20 then '연구실'
						when 30 then '영업부'
						when 40 then '전산실'
			  end as 부서
  from dept;



-- ex03) 급여인상율을 다르게 적용하기
-- emp에서 sal < 1000 0.8%인상, 1000~2000 0.5%, 2001~3000 0.3%
-- 그 이상은 0.1% 인상분 출력
-- ename, sal(인상전급여), 인상후급여 
-- 1) decode : sign() : 값이 음수 양수 결과를 -1 0 1로 리턴
-- 2) case 
select sign(20-10), sign(20-20), sign(10-30) from dual;
select sal, sign(sal - 1250) from emp;

select ename, sal
		 , decode(sign(sal-1000), 
		     -1, sal * 1.08,
		      0, sal * 1.05,
					1, decode(sign(sal-2000),
					     -1, sal * 1.05,
						    0, sal * 1.05,
						    1, decode(sign(sal-3000),
								     -1, sal * 1.03,
										  0, sal * 1.03,
											1, sal * 1.01))) as 인상후급여
		 , case when sal between    0 and  999 then sal * 1.08
					  when sal between 1000 and 1999 then sal * 1.05
						when sal between 2000 and 2999 then sal * 1.03
						when sal >= 3000 then sal *1.01
        end as 인상후급여											 
  from emp;
	






/* 이것이 MySQL이다 - data dump하기*/
-- 1. path 설정 
--    1) cmd창 
--    2) c:\>sysdm.cpl
--       ... 고급탭 >환경변수버튼클릭 > (system) path -> mysql의 bin폴더 등록
-- 2. dump파일이 저장된 경로에서 cmd창 재오픈 - path가 적용된 cmd창을 사용
-- 3. data dump
--    1) c:\dump파일이 저장된 경로>mysql -u root -p employees
--    2) source 명령실행
--       mysql> source load_departments.dump ;
--       mysql> source load_employees.dump ;
--       mysql> source load_dept_emp.dump ;
--       mysql> source load_titles.dump ;
--       mysql> source load_salaries.dump ;
--    3) mysql> exit







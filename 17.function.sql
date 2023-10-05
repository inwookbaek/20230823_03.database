/*
	Function?
	
	1. function
	
		 보통의 경우 값을 계산하고 그 결과를 반환하기 위해서 function을 사용한다.
		 대부분 procedure와 유사하지만
		 
		 1) in 파라미터만 사용할 수 있다.
		 2) 반드시 반환될 값의 데이터타입을 return문안에 선언해야 한다.
		 3) 실행문안에서 반드시 return 문이 실행되어야 한다.
	
	2. 문법
	    
		 1) pl/sql블럭안에는 적어도 한 개의 return문이 있어야 한다.
		 2) 선언방법
		    
				create or replace function 펑션이름(매개변수1 in 데이타입,....)
					return 데이터타입 is[as]
					변수1  데이터타입;....
				[pragma autonomous_transaction] -- update, delete등 문을 적용할지 여부
				begin
				end;
	
	3. 주의사항
	
	   오라클함수 즉, function에서는 기본적으로 DML(insert, update, delete)문을 사용할 수 없다.
		 만약, DML사용하고자 할 경우 begin 바로 위에 'pragma autonomous_transaction'을 선언하면
		 사용할 수 있다.
		 
	4. procedure vs function
	
	   procedure                           function
		 ----------------------------------  ---------------------------------
		 서버에서 실행(속도가 빠름)          클라이언트에서 실행
		 return값이 있어도 되고 없어도 된다. 반드시 return이 있어야 한다(필수)
		 return값이 복수(out이 복수개)       return값이 오직 한개
		 파라미터는 in, out 사용             in만 있다.
		 select절에는 사용할 수 없다         select절에서 사용할 수 있다.
			--> call, execute                   --> select 평션() frm dual;
*/

-- 1. 사원번호를 입력받아서 급여를 10%인상하는 함수 작성하기
select empno, ename, sal from emp where empno = 7369; -- sal = 924

create or replace function fn_01(p_empno in number) return number is
	v_sal  number;
pragma autonomous_transaction;	
begin
	update emp
	   set sal = sal * 1.1
	 where empno = p_empno;
	commit;
	
	select sal 
	  into v_sal
		from emp
	 where empno = p_empno;
	 
  return v_sal;
	
end fn_01; 

select sum(sal) from emp;
select fn_01(7369) from dual;
select 924*1.1 from dual;

-- procedure는 call로 호출가능하지만 function은 호출불가
call fn_01(9999); --> ORA-06576: not a valid function or procedure name

-- 실습1. 부피를 계산하는 함수 fn_02
-- 2개의 값을 전달받아서(길이 * 넓이 * 높이) 부피를 계산하는 함수 작성하기
-- p_length, p_width, p_height
create or replace function fn_02(
		p_length in number, p_width  in number, p_height in number) return number is
	v_result   number;
begin
	v_result := p_length * p_width * p_height;
	return v_result;
end fn_02;	


select fn_02(10,10,10) from dual;
select fn_02(654.52,685.99,2563.77) as 부피 from dual;

-- 실습3. 현재일을 입력받아서 해당월의 마지막일자를 구하는 함수(fn_03)
create or replace function fn_03(p_date in date) return date as
	v_result    date;
begin
	v_result := add_months(p_date, 1) - to_char(p_date, 'DD');
	return v_result;
end fn_03;

select fn_03(sysdate) from dual; -- 31
select add_months(sysdate, 1) from dual;
select to_char(sysdate, 'DD') from dual;
select add_months(sysdate, 1) - to_char(sysdate, 'DD') from dual;
select fn_03('20260203') from dual; -- 29

-- 실습4. '홍길동'문자열을 전달받아서 '길동'만 리턴하는 함수(fn_04)
create or replace function fn_04(p_name in varchar2) return varchar2 as
	v_result   varchar2(30);
begin
	v_result := substr(p_name, 2);
	return v_result;
end fn_04;

select fn_04('홍길동') from dual;
select fn_04(ename) from emp;

-- 실습5. fn_05: 현재일 입력받아서 '2023년 04월 03일'의 형태로 리턴
create or replace function fn_05(p_date in date) return varchar2 as
	v_result   varchar2(30);
begin
	v_result := to_char(p_date, 'yyyy"년" MM"월" dd"일"');
	return v_result;
end fn_05;

select fn_05(sysdate) from dual; 
select ename, fn_04(ename), fn_05(hiredate) from emp;

-- 실습06. fn_06: jumin번호를 입력받아서 남자 or 여자를 구분하는 리턴 함수
create or replace function fn_06(p_ssn in varchar2) return varchar2 as
	v_result   varchar2(10);
begin
	v_result := substr(p_ssn, 7, 1);
	
	if v_result in ('1', '3')
		then v_result := '남자';
		else v_result := '여자';
	end if;
	
	return v_result;
	
end fn_06;

-- 주민번호, 남자
select name, jumin, fn_06(jumin) from student;
select fn_06('9911183123456') from dual;
select fn_06('9911184123456') from dual;

-- 실습07 fn_07: professor에서 hiredate를 현재일기준으로 근속년월을 계산함수
-- hint) 근속년 floor(months_between()), 근속월ceil(months_between()) -> 12년 5개월
--       mod()
create or replace function fn_07(p_hiredate in date) return varchar2 is
	v_result   varchar2(20);
begin
  v_result := floor(months_between(sysdate, p_hiredate) / 12) || '년 '  
	            || ceil(mod(months_between(sysdate, p_hiredate), 12)) || '개월';
  return 	v_result;
end fn_07;

-- hint
select sysdate
     , months_between(sysdate, '20010120') / 12
		 , floor(months_between(sysdate, '20010120') / 12) 년
		 , ceil(mod(months_between(sysdate, '20010120'), 12)) 월
		 , mod(3, 2)
   from dual;
	 
-- 홍길동, 2023년 12월 25, 20년 6개월
select name, fn_05(hiredate), fn_07(hiredate) from professor;
select ename, fn_05(hiredate), fn_07(hiredate) from emp;
select ename, fn_05(hiredate), fn_07(hiredate) 
  from emp 
 where substr(fn_07(hiredate), 1, 2) between '30' and '39';


/*
	PL/SQL
	
	오라클의 Procedural Language extension to SQL의 약자이다.
	SQL문장에서 변수정의, 조건처리(if), 반복처리(for, while, loop)등을 지원하며
	절차형 언어(Procedural Language)한다.
	
	declare문을 이용하여 정의하고 선언문은 사용자 정의한다. PL/SQL문은 블럭구조로
	되어 있고 PL/SQL에서 자체 compile엔진을 가지고 있다.
	
	1. PL/SQL의 장점
	
	1) block구조로 다수의 SQL문을 한번에 Oracle DB서버로 전송해서 처리하기 때문에 처리속도가 빠르다.
	2) PL/SQL의 모든 요소는 하나 또는 두 개이상의 블럭으로 구성하여 모듈화가 가능하다.
	3) 보다 강력한 프로그램을 작성하기 위해 큰 블럭(pacakge)안에 소블럭(package body)을 위치 시킬 수가 있다.
	4) variable(변수), constant(상수), cursor(커서), exception(예외처리)등을 정의할 수 있고 SQL문장과
	   procedural문장에서 사용할 수 있다.
  5) 변수선언은 테이블의 데이터구조와 컬럼명을 이용해서 동적으로 변수선언을 할 수가 있다.
	6) exception처리를 이용하여 oracle servr error처리를 할 수 있다. (ORA-9999 에러코드)
	7) 사용자가 에러를 정의할 수도 있고 exception처리를 할 수 있다.

  2. PL/SQL의 구조
	
	1) PL/SQL은 프로그램을 논리적인 블럭으로 나눈 구조화된 언어이다.
	2) 선언부(declare, 선택사항), 실행부(begin ... end, 필수), 예외(exception, 선택)로 구성되어 있다.
	   특히, 실행부는 반드시 기술을 해야 한다.
	3) 문법
	   
		 declare
		   -- 선택부분
			 -- 변수, 상수, 커서, 사용자예외처리
		 begin
			 -- 필수부분
			 -- PL/SQL문장을 기술(select, if, for....)
		 exception
			 -- 선택부분
			 -- 예외처리로직을 기술 
		 end;
		 
		 
*/

let a = 10;
console.log(a)




















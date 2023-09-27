/*
	Sequence
	
	시퀀스란? 순차적으로 증감하는 일련번호를 자동으로 생성하는 오라클 데이터베이스의
	객체이다. 보통 PK값에 중복을 방지하기 위해서 종종 사용한다. 예를 들어 게시판에 
	글 하나가 등록이 될 때마다 글번호(PK)가 생겨야 한다면 보다 쉽게, 편리하게 PK를
	관리할 수가 있다.
	
	1. 유일한 값을 생성해 주는 오라클 객쳉중 하나이다.
	2. 시퀀스를 생성하면 기본키와 같이 순차적으로 증가하는 컬럼을 자동생성이 가능하다.
	3. 보통 PK값을 생성하기 위해 사용한다.
	4. 시퀀스는 테이블과 독립적으로 저장되고 생성된다.
	
	[Sequnce 문법]
	
	1. create sequence 시퀀스명
	   [start with n]          	-- 생략하면 기본값 1
		 [increment by n]   		-- 생략하면 기본값 1
		 [maxvalue | nomaxvalue]  -- 생략하면 기본값 nomaxvalue(9999999999999)
		 [minvalue | nominvalue]  -- 생략하면 기본값 nominvalue
		 [cycle | nocycle]        -- 생략하면 nocycle
		 [cache | nocache]        -- 생략하면 nocache
		 
		 ... start with   : 시퀀스의 시작값을 정의 n을 1000이라 지정하면 1000부턴 시작, 정의하지 않으면 기본값 1
		 ... increment by : 자동증가값을 정의 n이 10이면 10씩증가
		 ... maxvalue     : 시퀀스의 최대값 기본값 nomaxvalue
		 ... minvalue     : 시퀀스의 최소값 기본값 nominvalue
		 ... cycle        : 최대값에 도달한 경우 처음부터(start with) 다시 시작할지 여부를 정의
		 ... cache        : 원하는 숫자만큼 미리 생성해서 메모리에 저장했다가 하나씩 꺼내서 사용할지 여부, 기본값 20
		 
	2. 시퀀스변경
	
	   alter sequence 시퀀스명
			 [increment by n]   		
			 [maxvalue | nomaxvalue]  
			 [minvalue | nominvalue] 
			 [cycle | nocycle]        
			 [cache | nocache]  
				
  3. 시퀀스삭제
	   
		 drop sequence 시퀀스명			
		
	4. 시퀀스조회
	
	   select * from user_sequences;
	   select * from all_sequences;
						 
*/
-- 시퀀스조회
select * from user_sequences;
select * from all_sequences;

-- 1. 시퀀스생성하기
create sequence jno_seq
  start with 100
	increment by 1
	maxvalue 110
	minvalue 90
	cycle
	cache 2;
	
select * from user_sequences;	

-- 2. 시퀀스실습
create table s_order(
		ord_no     	number(4)
	,	ord_name 		varchar2(10)
	, p_name   		varchar2(20)
	, p_qty     	number
);
select * from s_order;

-- 시퀀스접근명령
-- 현재번호확인 : 시퀀스명.currval
-- 다음번호     : 시퀀스명.nextval

select jno_seq.currval from dual;
--> ORA-08002: sequence JNO_SEQ.CURRVAL is not yet defined in this session
-- JNO_SEQ가 사용된 적이 없기 때문에 currval에 대한 에러 발생

insert into s_order values(jno_seq.nextval, '홍길동', '아이폰', 1);
select jno_seq.currval from dual;
select * from s_order;
select * from user_sequences;	

-- minvalue, maxvalue 테스트
-- begin
-- 	for i in 1..9 loop
-- 		insert into s_order values(jno_seq.nextval, '소향', '노트북', 1);
-- 	end loop;
-- end; 

select jno_seq.currval from dual;
select * from s_order;
select * from user_sequences;	

-- cycle 테스트
insert into s_order values(jno_seq.nextval, '나얼', '자동차', 1);

select jno_seq.currval from dual;
select * from s_order;
select * from user_sequences;

-- 별도의 시퀀스 적용하기
create sequence jno_seq_01;
select * from user_sequences;

insert into s_order values(jno_seq_01.nextval, '거미', '아파트', 1);

select jno_seq_01.currval from dual;
select * from s_order;
select * from user_sequences;

-- 3. 감소하는 sequence
create sequence jno_seq_rev
	increment by -2
	maxvalue 20
	minvalue 0
	start with 20;
	
select * from user_sequences;

create table s_rev_01(no number);
select * from s_rev_01;

insert into s_rev_01 values(jno_seq_rev.nextval);
select * from s_rev_01;
select * from user_sequences;

-- 4. sequence 삭제
drop sequence jno_seq_01;

-- 보통 sequence는 PK로 사용
create sequence s_test;
create table test_table(no   number   primary key);

insert into test_table values(s_test.nextval);
insert into test_table values(s_test.nextval);
insert into test_table values(s_test.nextval);
insert into test_table values(s_test.nextval);
insert into test_table values(s_test.nextval);

select * from test_table;

insert into test_table values(6);  -- sequnce를 사용하지 않고 직접 값을 지정

select s_test.currval from dual;

insert into test_table values(s_test.nextval); -- 중복에러

select s_test.currval from dual;

insert into test_table values(s_test.nextval);


select s_test.nextval from dual;


select s_test.currval from dual;
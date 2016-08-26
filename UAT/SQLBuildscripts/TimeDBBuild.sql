use master
go

if exists (select * from sys.databases where name='restoretime')
begin
	ALTER DATABASE RESTORETIME SET single_USER with rollback immediate
	drop database restoretime
end
go


create database restoretime
go

alter database restoretime set recovery full
go

use restoretime
go

IF EXISTS (SELECT * FROM SYS.tables WHERE name='steps')
begin
	drop table steps
end
go

create table steps(
step integer,
dt datetime2
);
go

declare @i integer

set @i=0


backup database [restoretime] to disk='##replace##\restoretime.bak'

while (@i<10)
begin
insert into steps values (@i, getdate())
select @i=@i+1
waitfor delay '00:00:30'
end
backup log [restoretime] to disk='##replace##\restoretime_1.trn'

while (@i<20)
begin
insert into steps values (@i,getdate())
select @i=@i+1
waitfor delay '00:00:30'
end


backup log [restoretime] to disk='##replace##\restoretime_2.trn'

while (@i<30)
begin
insert into steps values (@i,getdate())
select @i=@i+1
waitfor delay '00:00:30'
end


backup log [restoretime] to disk='##replace##\restoretime_3.trn'




# Database Fundamental (MariaDB)

About mariaDB Query (DQL, DML, TCL)  

## SQL(Structured Query Language)

<br>
- 교차 Entity <br>
<p>
  <img src="https://user-images.githubusercontent.com/41675375/70534257-03c13d80-1b9e-11ea-96db-e64c263e0077.png">
</p>

<br> 하나의 부서에 employee 여러사람이 존재할 수도 있고, (1:N관계)
<br>한명의 employee가 과거 여러 부서의 이력이 있을 수도 있다.(1:N관계)
<br>중간에 history라는 교차 Entity를 넣어서 외래키로 다 받아서 관리. 

<br>
<br>

## JDBC

[source 참고하기](https://github.com/hanbinleejoy/Java_Fundamental/tree/master/src/java_20191210/)

## 주의사항

- DELETE 쿼리 실행시 Foreign Key가 참조하고 있는 데이터는 삭제가 불가능하다. (상당히 주의해야함)

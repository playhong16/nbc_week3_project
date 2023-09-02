# nbc_week3_project
내일배움캠프 3, 5주차 프로젝트 - TodoApp 만들기

할 일을 생성하고 관리하는 Todo App 입니다.

## 5주차 필수과제

1. MVC 디자인 패턴으로 앱을 만들었습니다.
2. UserDefaults 를 활용해서 Create, Read, Delete 기능을 구현했습니다.
3. TableView 의 Section 을 카테고리 별로 나누고, header의 Title을 통해 Section을 구분할 수 있도록 했습니다.
4. 시작 화면에서 이미지의 URL을 통해 이미지를 불러오는 기능을 구현했습니다.





## 앱의 구조
디자인 패턴은 MVC(Model-View-Controller)패턴을 적용했습니다.
Todo 데이터 모델을 만들고, Todo 데이터를 관리하기 위한 TodoDataManager를 만들었습니다. TodoDataManager는 싱글톤 패턴으로 구현해서 하나의 TodoDataManager 인스턴스에 모든 뷰컨트롤러가 접근하도록 구현했습니다.
그리고 데이터의 일관성을 유지하기 위해 TodoDataManager에서 UserDefautls에 접근해서, 데이터를 "TodoList" 라는 키값을 사용해서 저장하고 저장한 데이터를 불러오도록 구현했습니다.
각각의 Controller는 TodoDataManager에게 데이터를 전달받고, 해당 데이터를 스토리보드로 구성된 각각의 Scene에 전달해서 데이터를 세팅합니다.
![App_Layer](https://github.com/playhong16/nbc_week3_project/assets/119715960/4f472ef4-0207-4c1f-a263-65c59460ea9e)


## 주요 화면
<div markdown="1">
	<p align="center">
		<img width="200" alt="1" src="image/조회_1.png" />
		<img width="200" alt="2" src="image/생성_1.png" />
		<img width="200" alt="3" src="image/완료처리_1.png" />
		<img width="200" alt="4" src="image/완료조회_1.png" />
	</p>
</div>

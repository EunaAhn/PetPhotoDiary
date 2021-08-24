[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Pet Photo Diary for iOS Swift Project

## 앱의 주요 서비스 기능


기존의 반려동물과의 추억 보관방식인 사진과 아날로그적 감성의 추억 보관 방식인
일기 그리고 더 쉽게 반려동물과의 사진을 남길 수 있는 촬영음 설정을 통한 편의향상

1.  촬영 기능 
단순히 반려 동물을 촬영하는 기능 뿐만 아니라 촬영시 반려동물이 카메라에 집중할 수 있도록 촬영시 소리가 나도록 하였습니다. 
촬영음은 기본적으로 제공하는 사운드와 반려동물마다 반응하는 소리가 다를 수 있으므로 사용자가 직접 녹음하여 촬영음으로 만들 수 있도록 하였습니다.

2. 전용 폴더 기능
핸드폰의 기본 카메라로 찍을 경우 핸드폰에 저장된 다른 사진들과 반려동물 사진들이 혼합되어 있다는 것을 알 수 있습니다. 
이러한 불편한 점을 개선하여 이 앱에서는 사진을 찍은 후 앱 내 폴더에 따로 저장하여 반려동물 사진들만 모아둘 수 있도록 하였습니다.[CoreData](## CoreData)

3. 사진 공유 기능
사용자는 스스로 반려동물과의 추억을 보관하는 것 뿐만 아니라 다른 사람들과 이 추억을 공유하고 싶어할 수
있기 때문에 메세지, 메일, SNS 등을 통해 찍은 사진을 다른 사람들과 공유할 수 있도록 하였습니다.

4. 성장일기 기능
사용자가 찍은 반려동물 사진에 멘트를 남겨 반려동물 성장일기를 작성할 수 있도록 하였습니다.
또한 검색 창에 키워드를 입력받아 그 키워드가 포함된 일기를 보여주도록 하였습니다.[검색 기능](## 검색기능)


## CoreData

CoreData라는 iOS 플랫폼 단에서 지원하는 관계형 데이터베이스 라이브러리를 사용하였습니다. 
큰 테이블로 앨범, 다이어리, 사운드를 나누었고, 앨범의 속성에는 date, path, title, 그리고 
다이어리에는 content, date, id, image, 사운드에는 path, title을 속성으로 정하였습니다.
코어 데이터에 속성별로 데이터를 저장하기 위해 뒤에 코드에서는  NSManagedObject 클래스를 사용하였습니다.

코어 데이터에 있는 앨범 정보를 가져와 그동안 찍은 사진들이 날짜 순대로 그리드 뷰로 이미지가 나오도록 하였습니다.

사진을 선택하면 사진이 몇번째 칸에 있는 지를 확인하여 사진을 input화면에
띄우고, input화면의 텍스트 입력 칸에 일기를 입력한 후에 저장을 누르면 코어 데이터의 다이어리
속성인 content, date, id, image에 각각의 정보들이 저장되게 하였습니다.

일기장 화면의 정렬 순서는 코어 데이터에 있는 id속성의 순서대로 정렬하였고, 
현재 저장된 일기의 개수를 세어 그 개수만큼 셀을 만들어 일기들을 리스트에 보여주도록 하였습니다.

<img width="600" alt="데이터모델링" src="https://user-images.githubusercontent.com/81062538/130538204-332be06a-f939-4a2b-885e-abf154ac2884.png">


## 검색기능

키워드를 입력하여 그 키워드가 포함된 일기를 찾고자 할때 NSPredicate함수를 이용해
필터링하여 입력받은 문자들이 포함된 일기들이 보여지도록 하였습니다.

```
func searchDiary(searchText : String) -> [NSManagedObject] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
    
    if searchText != "" {
        fetchRequest.predicate = NSPredicate(format: "content CONTAINS %@", searchText)
    }
    // sort
    let sort = NSSortDescriptor(key: "id", ascending: false)
    fetchRequest.sortDescriptors = [sort]
    
    let result = try! context.fetch(fetchRequest)
    return result
}

```

## 화면 흐름도

<img width="461" alt="웹뷰전체" src="https://user-images.githubusercontent.com/81062538/130538251-cf5ac4d1-dc50-48ff-8fd4-0a8f0a7d7050.png">


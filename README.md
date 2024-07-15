# Reminder

- Realm을 이용한 데이터 저장에 익숙해지기 위해서 Apple의 기본 앱인 Reminder를 따라서 만들며 약간의 수정을 했습니다.

### 기술

- UIkit
- Combine
- MVVM
- Realm

### 구동영상
| 구현 영상 |
| --- |
| <img src="https://github.com/user-attachments/assets/add6c3de-2c1c-4534-b491-c34cfe178a57" width=300> |

### 고민되는 점

- ViewModel에서 View로 부터 Input을 받아오는 경우에 enum으로 Input의 상황을 선언하여 받아왔습니다. output도 똑같이 해주어야 하는지 고민이 되었습니다.

```swift
  enum InputType {
        case noValue
        case viewDidLoad
        case addNewCustomFolder
        case deleteCustomFolder(Int)
        case searchTodo(String?)
        case filteredDate(Date)
    }
    
    private func bindInput() {
        
        $input.sink { [weak self] inputType in
            guard let self = self else { return }
            
            switch inputType {
            case .noValue:
                return
                
            case .viewDidLoad:
                readCustomFolder()
                
            case .addNewCustomFolder:
                readCustomFolder()
                
            case .deleteCustomFolder(let index):
                deleteFolder(index: index)
                
            case .searchTodo(let keyword):
                searchTodo(keyword: keyword)
                
            case .filteredDate(let date):
                filterDate(date: date)
                
            }
        }.store(in: &cancellable)
        
    }
```

- Realm의 Results타입과 기본 배열 사이에서 고민을 했습니다.

- Results를 사용하는 경우 realm 내부에 구현이 된 sorted 메서드를 사용할 수 있습니다.
- Results는 삭제를 진행하면 자체적으로 바로 Results에 반영이 되기 때문에 DataBaseManager를 통해 삭제를 진행하면 된다는 이점이 있었습니다.

```swift

case .sortedByTitle:
todoList = todoList.sorted(byKeyPath: "title",
                           ascending: true)
reloadOutPut = ()

case .sortedByDate:
todoList = todoList.sorted(byKeyPath: "deadLine",
                           ascending: true)
reloadOutPut = ()

case .sortedByPriority:
todoList = todoList.sorted(byKeyPath: "priority",
                           ascending: true)
reloadOutPut = ()

```

- 배열의 경우  realm에서 구현이 되어있는 sorted 메서드를 사용하는 것이 불가능 하지만 상대적으로 추가 삭제에 있어서 results보다 구현이 편한 이점이 있었습니다. 그래서 현재 프로젝트에서는 results와 List를 배열로 변환하여 사용했습니다.

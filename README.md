# Structure

### Domain Layer
- 

### Data Layer
- Network
  - `DataTransferService`: Data transfer 및 Decoding 담당, 보통 Repository가 의존.
  - `NetworkService`: Data 생성 및 Session 서비스 담당, 보통 DataTransferService가 의존.
  - `EndPoint`: URL 및 urlRequest 생성, Encoding 담당
  - `NetworkConfig`: EndPoint에 필요한 URL, header, query를 초기화

### Presentation Layer
-

### Application
  - AppConfiguration
  - DIContainer

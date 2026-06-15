# my-diary-backend

Node.js API 서버와 MySQL 테이블 SQL을 포함한 Private 서버용 저장소입니다.
파일은 서버 폴더가 아니라 NCP Object Storage에 저장합니다.

## 실행 위치

NCP Private Subnet 서버

## 테이블 생성

현재 접속된 DB에서 아래 파일을 실행합니다.

```text
database/schema.sql
```

이미 기존 테이블을 만들었다면 `stored_file_name` 길이만 늘립니다.

```text
database/alter-object-storage.sql
```

## NCP Object Storage 준비

필요한 값:

```text
NCP_ACCESS_KEY
NCP_SECRET_KEY
NCP_BUCKET
NCP_REGION=kr-standard
NCP_ENDPOINT=https://kr.object.ncloudstorage.com
```

DB에는 파일 자체를 저장하지 않습니다.

```text
original_file_name : 사용자가 업로드한 원래 파일명
stored_file_name   : Object Storage object key
file_size          : 파일 크기
```

## 최초 1회 Docker 설치

```bash
chmod +x deploy/install-docker-ubuntu.sh
./deploy/install-docker-ubuntu.sh
```

## 직접 배포

```bash
chmod +x deploy/run-private-backend.sh

DB_HOST=YOUR_MYSQL_HOST \
DB_PORT=3306 \
DB_USER=YOUR_DB_USER \
DB_PASSWORD=YOUR_DB_PASSWORD \
DB_NAME=YOUR_DB_NAME \
NCP_ACCESS_KEY=YOUR_NCP_ACCESS_KEY \
NCP_SECRET_KEY=YOUR_NCP_SECRET_KEY \
NCP_BUCKET=YOUR_BUCKET_NAME \
./deploy/run-private-backend.sh
```

## 역할

- 다이어리 CRUD API 제공
- 파일을 NCP Object Storage에 업로드
- Object Storage 파일 다운로드 제공
- MySQL 연동

## API

```text
GET    /api/diaries?page=0&size=10
GET    /api/diaries/:id
POST   /api/diaries
PUT    /api/diaries/:id
DELETE /api/diaries/:id
GET    /api/diaries/:id/download
```

## ACG

Private 서버 inbound:

```text
22   : Public 서버 private IP만 허용
3000 : Public 서버 private IP만 허용
```

Private 서버 outbound:

```text
3306 : 외부 MySQL 서버 IP
443  : NCP Object Storage endpoint 접속용
80/443 : Docker 설치, 패키지 다운로드가 필요할 때
```

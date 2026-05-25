# Dokumentasi Backend API

Dokumen ini digenerate dari Swagger/OpenAPI backend live agar kontrak API lokal sesuai dengan backend yang tersedia.

- Source Swagger UI: `http://202.10.37.32/api-docs/`
- Source spec: embedded `swaggerDoc` di `swagger-ui-init.js`
- Generated at: `2026-05-23`
- OpenAPI: `3.0.0`
- API title: `Agro App API`
- API version: `1.0.0`

## Ringkasan

| Item | Jumlah |
| --- | ---: |
| Paths | 65 |
| Operations | 82 |
| Schemas | 72 |
| Tags | 19 |

## Servers

| URL | Description |
| --- | --- |
| `http://localhost:3000/api` | Development server |
| `http://202.10.37.32/api` | Production server |

## Tags

| Tag | Description |
| --- | --- |
| Auth | Authentication endpoints |
| User | User management endpoints |
| Role | Role management endpoints |
| Site Member | Site member invitation endpoints |
| Reads | Sensor reading and recap endpoints |
| Recommendations | Plant and site recommendation endpoints |
| Device Sensor | Device sensor mapping and thresholds |
| Site | Site management endpoints |
| Device | Device management endpoints |
| Sensor | Sensor management endpoints |
| Agro | Agronomy endpoints (GDD, VDP, ETC, environmental health) |
| Phase | Phase and GDD related endpoints |
| Plant | Plant management endpoints |
| Unit | Unit of measure endpoints |
| Task | User tasks and activities |
| Profile | User profile and permissions |
| Forum | Forum discussions and interactions |
| Notes | User notes for sites |
| Comments | Forum comments |

## Endpoint Index

| Method | Path | Tag | Summary |
| --- | --- | --- | --- |
| `POST` | `/auth/login` | Auth | Login user |
| `POST` | `/auth/refresh` | Auth | Refresh access token |
| `POST` | `/auth/logout` | Auth | Logout user |
| `POST` | `/sites/users/new-users` | User | Create new user |
| `GET` | `/sites/users` | User | Get all users |
| `PUT` | `/sites/users/{user_id}` | User | Update user |
| `DELETE` | `/sites/users/{user_id}` | User | Delete user |
| `GET` | `/sites/{siteId}/device-sensors` | Device Sensor | Get device sensors by site |
| `POST` | `/sites/{siteId}/device-sensors` | Device Sensor | Create device sensor mapping |
| `GET` | `/sites/{siteId}/device-sensors/values` | Device Sensor | Get device sensor threshold values |
| `PUT` | `/sites/{siteId}/device-sensors/{ds_id}/{dev_id}` | Device Sensor | Update device sensor mapping |
| `GET` | `/roles` | Role | Get all roles |
| `POST` | `/roles` | Role | Create new role |
| `PUT` | `/roles/{role_id}` | Role | Update role |
| `DELETE` | `/roles/{role_id}` | Role | Delete role |
| `POST` | `/sites/{siteId}/members/invite` | Site Member | Invite member to site |
| `GET` | `/sites/{siteId}/reads` | Reads | Get sensor reads untuk site |
| `PUT` | `/sites/{siteId}/reads/{id}` | Reads | Update data sensor read berdasarkan ID |
| `GET` | `/sites/{siteId}/reads/seven-day` | Reads | Get rekap harian 7 hari terakhir |
| `GET` | `/sites/{siteId}/reads/planting-date` | Reads | Get reads berdasarkan rentang masa tanam aktif |
| `GET` | `/sites/{siteId}/reads/mounth` | Reads | Get rekap bulanan sensor |
| `GET` | `/sites/{siteId}/reads/updates` | Reads | Get nilai sensor terkini per device |
| `GET` | `/sites/{siteId}/reads/daily` | Reads | Get semua rekap harian untuk site |
| `GET` | `/sites/{siteId}/reads/daily/today` | Reads | Get rekap harian hari ini |
| `GET` | `/sites/{siteId}/reads/daily/by-day` | Reads | Get rekap harian berdasarkan tanggal tertentu |
| `POST` | `/sites/{siteId}/reads/daily/rekap` | Reads | Trigger kalkulasi rekap harian untuk tanggal tertentu |
| `GET` | `/fase/phases-list` | Phase | Get list of all phases |
| `GET` | `/fase/phases-list/{cropType}` | Phase | Get phases filtered by crop type |
| `GET` | `/fase/phases-by-hst/{siteId}` | Phase | Get current phase by HST for a site |
| `GET` | `/sites/{siteId}/plants` | Plant | Get all plants for a site |
| `POST` | `/sites/{siteId}/plants` | Plant | Create a new plant in a site |
| `GET` | `/sites/{siteId}/plants/{plantId}` | Plant | Get plant by id |
| `POST` | `/sites/{siteId}/plants/{plantId}/harvest` | Plant | Harvest a plant |
| `GET` | `/sites/units` | Unit | Get all units |
| `POST` | `/sites/units/create-units` | Unit | Create a unit |
| `GET` | `/sites/{siteId}/tasks` | Task | Get all tasks for a site |
| `POST` | `/sites/{siteId}/tasks` | Task | Buat task baru untuk site |
| `GET` | `/sites/{siteId}/tasks/{id}` | Task | Get task by ID |
| `PUT` | `/sites/{siteId}/tasks/{id}` | Task | Update task |
| `DELETE` | `/sites/{siteId}/tasks/{id}` | Task | Hapus task |
| `GET` | `/sites/{siteId}/recommendations` | Recommendations | Get recommendation for a site |
| `POST` | `/sites/{siteId}/recommendations/plant` | Recommendations | Get plant recommendation from sensor values |
| `GET` | `/sites/{siteId}/recommendations/plant-by-site` | Recommendations | Get latest plant recommendation for a site |
| `GET` | `/sites/{siteId}/recommendations/history` | Recommendations | Get recommendation history for a site |
| `GET` | `/sites/{siteId}/recommendations/by-phase/{phaseId}` | Recommendations | Get recommendations by phase |
| `POST` | `/sites/{siteId}/recommendations/preview-dummy` | Recommendations | [TEST] Preview rekomendasi dari data dummy (NPK + Lingkungan) |
| `POST` | `/sites/{siteId}/recommendations/save-dummy` | Recommendations | [TEST] Generate dan simpan rekomendasi dari data dummy |
| `GET` | `/sites` | Site | Get all sites (or by query site_id) |
| `POST` | `/sites` | Site | Create new site |
| `PUT` | `/sites/{site_id}` | Site | Update site by site_id |
| `GET` | `/sites/{siteId}/devices` | Device | Get devices for a site |
| `POST` | `/sites/{siteId}/devices` | Device | Create new device |
| `GET` | `/sites/{siteId}/devices/coordinates` | Device | Get device coordinates for a site |
| `PUT` | `/sites/{siteId}/devices/{id}` | Device | Update device by id |
| `DELETE` | `/sites/{siteId}/devices/{id}` | Device | Delete device by id |
| `GET` | `/sites/{siteId}/sensors` | Sensor | Get sensors by site (optional filter sensor_id/unassigned) |
| `POST` | `/sites/{siteId}/sensors` | Sensor | Create sensor |
| `GET` | `/sites/{siteId}/sensors/detail/{sens_id}` | Sensor | Get sensor detail in a site by sens_id |
| `PUT` | `/sites/{siteId}/sensors/{sensor_id}` | Sensor | Update sensor by sensor_id |
| `GET` | `/sites/{siteId}/agro` | Agro | Get agro summary data for a site (VDP, GDD, ETC) |
| `GET` | `/sites/{siteId}/agro/environmental-health` | Agro | Get environmental health overview for a site |
| `GET` | `/profile/me` | Profile | Get current user profile |
| `GET` | `/profile/permissions` | Profile | Get current user permissions |
| `GET` | `/profile/debug-token` | Profile | Debug: Get decoded JWT token |
| `GET` | `/forum/posts` | Forum | Get all forum posts (paginated) |
| `POST` | `/forum/posts` | Forum | Create new forum post (dengan opsional upload gambar) |
| `GET` | `/forum/posts/my-posts` | Forum | Get posts milik user yang sedang login |
| `GET` | `/forum/posts/liked-posts` | Forum | Get posts yang di-like oleh user yang sedang login |
| `GET` | `/forum/my-comments` | Forum | Get komentar milik user yang sedang login |
| `GET` | `/forum/posts/{postId}` | Forum | Get forum post by ID |
| `PUT` | `/forum/posts/{postId}` | Forum | Update forum post (hanya pemilik) |
| `DELETE` | `/forum/posts/{postId}` | Forum | Hapus forum post beserta semua komentar dan interaksinya (hanya pemilik) |
| `POST` | `/forum/posts/{postId}/like` | Forum | Toggle like/dislike pada post. Kirim action yang sama 2x untuk membatalkan. |
| `POST` | `/forum/posts/{postId}/share` | Forum | Tambah share count post |
| `GET` | `/forum/posts/{postId}/reactions` | Forum | Get semua reaksi (like/dislike) pada post |
| `GET` | `/forum/posts/{postId}/comments` | Forum | Get komentar pada post (paginated) |
| `POST` | `/forum/posts/{postId}/comments` | Forum | Tambah komentar pada post |
| `DELETE` | `/forum/posts/{postId}/comments/{commentId}` | Forum | Hapus komentar (pemilik komentar atau pemilik post) |
| `PUT` | `/comments` | Comments | Update forum comment |
| `DELETE` | `/comments/{commentId}` | Comments | Delete forum comment |
| `GET` | `/sites/{siteId}/notes` | Notes | Get all notes for a site |
| `POST` | `/sites/{siteId}/notes` | Notes | Create new note for a site |

## Endpoint Detail

## Auth

### `POST` `/auth/login`

- Summary: Login user
- Auth: no

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/LoginRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Login successful | `application/json` `object` |
| `400` | Invalid JSON payload | `application/json` `#/components/schemas/Error` |
| `401` | Unauthorized | `application/json` `#/components/schemas/Error` |
| `404` | Username not found | `application/json` `#/components/schemas/Error` |

### `POST` `/auth/refresh`

- Summary: Refresh access token
- Auth: no

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `object` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Token refreshed successfully | `application/json` `object` |
| `400` | Invalid JSON payload | `application/json` `#/components/schemas/Error` |
| `401` | Invalid or expired refresh token | `application/json` `#/components/schemas/Error` |

### `POST` `/auth/logout`

- Summary: Logout user
- Auth: yes

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `object` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Logout successful | `application/json` `object` |
| `400` | Invalid JSON payload | `application/json` `#/components/schemas/Error` |
| `404` | Refresh token not found | `application/json` `#/components/schemas/Error` |

## User

### `POST` `/sites/users/new-users`

- Summary: Create new user
- Auth: yes

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/CreateUserRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | User created successfully | `application/json` `object` |
| `400` | Bad request | `application/json` `#/components/schemas/Error` |
| `409` | Username, email, or user ID already exists | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/users`

- Summary: Get all users
- Auth: yes

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Users retrieved successfully | `application/json` `object` |
| `204` | No users found |  |

### `PUT` `/sites/users/{user_id}`

- Summary: Update user
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `user_id` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/UpdateUserRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | User updated successfully | `application/json` `object` |
| `404` | User not found |  |

### `DELETE` `/sites/users/{user_id}`

- Summary: Delete user
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `user_id` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | User deleted successfully | `application/json` `object` |
| `404` | User not found |  |

## Role

### `GET` `/roles`

- Summary: Get all roles
- Auth: yes

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Roles retrieved successfully | `application/json` `object` |

### `POST` `/roles`

- Summary: Create new role
- Auth: yes

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/RoleCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Role created successfully | `application/json` `object` |
| `403` | Only admin can create roles | `application/json` `#/components/schemas/Error` |

### `PUT` `/roles/{role_id}`

- Summary: Update role
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `role_id` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/RoleUpdateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Role updated successfully | `application/json` `object` |
| `403` | Only admin can update roles | `application/json` `#/components/schemas/Error` |

### `DELETE` `/roles/{role_id}`

- Summary: Delete role
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `role_id` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Role deleted successfully | `application/json` `object` |
| `403` | Only admin can delete roles | `application/json` `#/components/schemas/Error` |

## Site Member

### `POST` `/sites/{siteId}/members/invite`

- Summary: Invite member to site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/SiteMemberInviteRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Member invited successfully | `application/json` `object` |
| `400` | user_id is missing in body | `application/json` `#/components/schemas/Error` |
| `403` | Requester is not a site leader | `application/json` `#/components/schemas/Error` |
| `409` | Member already exists | `application/json` `#/components/schemas/Error` |

## Reads

### `GET` `/sites/{siteId}/reads`

- Summary: Get sensor reads untuk site
- Description: Mendukung filter: tanggal spesifik (?date), hari ini (?today=true), atau rentang tanggal (?startDate&endDate). Jika tidak ada filter, mengembalikan semua data.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `today` | query | no | `string enum(true, 1)` | Filter hanya data hari ini |
| `date` | query | no | `string:date` | Filter berdasarkan tanggal spesifik |
| `startDate` | query | no | `string:date` | Awal rentang tanggal (wajib berpasangan dengan endDate) |
| `endDate` | query | no | `string:date` | Akhir rentang tanggal (wajib berpasangan dengan startDate) |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Reads berhasil diambil | `application/json` `object` |
| `400` | Query parameter tidak valid | `application/json` `#/components/schemas/Error` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `PUT` `/sites/{siteId}/reads/{id}`

- Summary: Update data sensor read berdasarkan ID
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `id` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `object` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Read berhasil diperbarui | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |
| `404` | Read tidak ditemukan | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/reads/seven-day`

- Summary: Get rekap harian 7 hari terakhir
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Data 7 hari berhasil diambil | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/reads/planting-date`

- Summary: Get reads berdasarkan rentang masa tanam aktif
- Description: Mengambil data sensor dari tanggal tanam hingga tanggal panen berdasarkan data penanaman (td_plant) yang aktif di site.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Data berhasil diambil | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/reads/mounth`

- Summary: Get rekap bulanan sensor
- Description: Mengembalikan data rekap harian yang dikelompokkan per bulan untuk semua device di site.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Rekap bulanan berhasil diambil | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/reads/updates`

- Summary: Get nilai sensor terkini per device
- Description: Mengembalikan nilai sensor terakhir yang diterima per device. Bisa difilter berdasarkan sens_id untuk jenis sensor tertentu.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `sens_id` | query | no | `string` | Filter berdasarkan ID sensor (opsional) |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Data update sensor berhasil diambil | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/reads/daily`

- Summary: Get semua rekap harian untuk site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Rekap harian berhasil diambil | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/reads/daily/today`

- Summary: Get rekap harian hari ini
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Rekap hari ini berhasil diambil | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/reads/daily/by-day`

- Summary: Get rekap harian berdasarkan tanggal tertentu
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `day` | query | yes | `string:date` | Tanggal yang ingin diambil rekapnya (format YYYY-MM-DD) |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Rekap harian berhasil diambil | `application/json` `object` |
| `400` | Query parameter 'day' wajib diisi | `application/json` `#/components/schemas/Error` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `POST` `/sites/{siteId}/reads/daily/rekap`

- Summary: Trigger kalkulasi rekap harian untuk tanggal tertentu
- Description: Menghitung dan menyimpan nilai min, max, dan avg dari semua sensor untuk hari yang ditentukan. Biasanya dipanggil oleh scheduler atau secara manual untuk backfill data.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/DailyRekapRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Rekap berhasil diproses | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

## Recommendations

### `GET` `/sites/{siteId}/recommendations`

- Summary: Get recommendation for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `refresh` | query | no | `boolean` | Set true to bypass cache |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Recommendation retrieved successfully | `application/json` `object` |
| `404` | No active planting or sensor data found | `application/json` `object` |

### `POST` `/sites/{siteId}/recommendations/plant`

- Summary: Get plant recommendation from sensor values
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/PlantRecommendationRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Plant recommendation retrieved successfully | `application/json` `object` |
| `400` | Invalid input or ML configuration | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/recommendations/plant-by-site`

- Summary: Get latest plant recommendation for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Plant recommendation by site retrieved successfully | `application/json` `object` |
| `404` | No sensor data found for plant recommendations | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/recommendations/history`

- Summary: Get recommendation history for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `limit` | query | no | `integer` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Recommendation history retrieved successfully | `application/json` `object` |

### `GET` `/sites/{siteId}/recommendations/by-phase/{phaseId}`

- Summary: Get recommendations by phase
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `phaseId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Phase recommendations retrieved successfully | `application/json` `object` |
| `404` | No recommendations found for phase | `application/json` `#/components/schemas/Error` |

### `POST` `/sites/{siteId}/recommendations/preview-dummy`

- Summary: [TEST] Preview rekomendasi dari data dummy (NPK + Lingkungan)
- Description: Endpoint untuk **testing**. Kirim data sensor manual dan lihat hasil rekomendasi NPK + lingkungan tanpa menyimpan ke database. Gunakan nama fase yang tepat sesuai enum.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/DummyRecommendationRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Rekomendasi berhasil digenerate | `application/json` `object` |
| `400` | Missing phase atau sensorData, atau nama fase tidak valid | `application/json` `#/components/schemas/Error` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `POST` `/sites/{siteId}/recommendations/save-dummy`

- Summary: [TEST] Generate dan simpan rekomendasi dari data dummy
- Description: Endpoint untuk **testing**. Sama seperti preview-dummy tapi hasilnya **disimpan ke database**. Berguna untuk mengisi data rekomendasi saat sensor belum aktif.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/DummyRecommendationSaveRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Rekomendasi berhasil digenerate dan disimpan | `application/json` `object` |
| `400` | Missing siteId, phase, atau sensorData | `application/json` `#/components/schemas/Error` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

## Device Sensor

### `GET` `/sites/{siteId}/device-sensors`

- Summary: Get device sensors by site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `sensor` | query | no | `string` | Optional filter by sensor id |
| `ds_id` | query | no | `string` | Optional filter by device sensor id |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Device sensors retrieved successfully | `application/json` `object` |
| `404` | No device sensors found | `application/json` `object` |

### `POST` `/sites/{siteId}/device-sensors`

- Summary: Create device sensor mapping
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/DeviceSensorCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Device sensor created successfully | `application/json` `object` |
| `400` | Missing or invalid fields | `application/json` `#/components/schemas/Error` |
| `404` | Device not found | `application/json` `#/components/schemas/Error` |
| `409` | Device sensor already exists | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/device-sensors/values`

- Summary: Get device sensor threshold values
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Threshold values retrieved successfully | `application/json` `object` |
| `404` | No threshold values found | `application/json` `object` |

### `PUT` `/sites/{siteId}/device-sensors/{ds_id}/{dev_id}`

- Summary: Update device sensor mapping
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `ds_id` | path | yes | `string` |  |
| `dev_id` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/DeviceSensorUpdateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Device sensor updated successfully | `application/json` `object` |
| `400` | Invalid payload | `application/json` `#/components/schemas/Error` |
| `404` | Device sensor not found | `application/json` `#/components/schemas/Error` |
| `409` | Device sensor conflict | `application/json` `#/components/schemas/Error` |

## Site

### `GET` `/sites`

- Summary: Get all sites (or by query site_id)
- Auth: no

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `site_id` | query | no | `string` | Optional filter by site_id |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Sites retrieved | `application/json` `object` |
| `401` | Unauthorized | `application/json` `#/components/schemas/Error` |

### `POST` `/sites`

- Summary: Create new site
- Auth: no

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/SiteCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Site created successfully | `application/json` `object` |
| `400` | Validation error | `application/json` `#/components/schemas/Error` |
| `409` | Site already exists | `application/json` `#/components/schemas/Error` |

### `PUT` `/sites/{site_id}`

- Summary: Update site by site_id
- Auth: no

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `site_id` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/SiteUpdateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Site updated successfully | `application/json` `object` |
| `400` | Invalid update payload | `application/json` `#/components/schemas/Error` |
| `404` | Site not found | `application/json` `#/components/schemas/Error` |

## Device

### `GET` `/sites/{siteId}/devices`

- Summary: Get devices for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `sensor` | query | no | `boolean` |  |
| `dev_id` | query | no | `string` | Optional filter by device id |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Devices retrieved successfully | `application/json` `object` |

### `POST` `/sites/{siteId}/devices`

- Summary: Create new device
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/DeviceCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Device created successfully | `application/json` `object` |
| `400` | Bad request |  |
| `409` | Device already exists |  |

### `GET` `/sites/{siteId}/devices/coordinates`

- Summary: Get device coordinates for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Coordinates retrieved successfully | `application/json` `object` |

### `PUT` `/sites/{siteId}/devices/{id}`

- Summary: Update device by id
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `id` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/DeviceUpdateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Device updated successfully | `application/json` `object` |
| `404` | Device not found |  |

### `DELETE` `/sites/{siteId}/devices/{id}`

- Summary: Delete device by id
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `id` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Device deleted successfully | `application/json` `object` |
| `404` | Device not found |  |

## Sensor

### `GET` `/sites/{siteId}/sensors`

- Summary: Get sensors by site (optional filter sensor_id/unassigned)
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `sensor_id` | query | no | `string` | Optional filter by sensor id |
| `unassigned` | query | no | `boolean` | If true, include sensors with no dev_id (unassigned) |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Sensors retrieved | `application/json` `object` |

### `POST` `/sites/{siteId}/sensors`

- Summary: Create sensor
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/SensorCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Sensor created successfully | `application/json` `object` |
| `400` | Missing/invalid fields |  |
| `404` | Device ID not found |  |
| `409` | Sensor already exists |  |

### `GET` `/sites/{siteId}/sensors/detail/{sens_id}`

- Summary: Get sensor detail in a site by sens_id
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `sens_id` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Sensor detail retrieved | `application/json` `object` |
| `404` | Sensor not found in site |  |

### `PUT` `/sites/{siteId}/sensors/{sensor_id}`

- Summary: Update sensor by sensor_id
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `sensor_id` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/SensorUpdateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Sensor updated successfully | `application/json` `object` |
| `400` | Invalid latitude/longitude/altitude |  |
| `404` | Sensor not found / Device ID not found |  |

## Agro

### `GET` `/sites/{siteId}/agro`

- Summary: Get agro summary data for a site (VDP, GDD, ETC)
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `plantType` | query | no | `string` | Optional plant type (e.g., sawah or gogo) |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Agro summary retrieved successfully | `application/json` `object` |
| `200-empty` | No data found for agro |  |

### `GET` `/sites/{siteId}/agro/environmental-health`

- Summary: Get environmental health overview for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Environmental health retrieved successfully | `application/json` `object` |
| `200-empty` | No sensor updates available |  |

## Phase

### `GET` `/fase/phases-list`

- Summary: Get list of all phases
- Auth: no

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Phases retrieved successfully | `application/json` `object` |

### `GET` `/fase/phases-list/{cropType}`

- Summary: Get phases filtered by crop type
- Auth: no

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `cropType` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Phases retrieved | `application/json` `object` |

### `GET` `/fase/phases-by-hst/{siteId}`

- Summary: Get current phase by HST for a site
- Auth: no

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Phase by HST retrieved | `application/json` `object` |

## Plant

### `GET` `/sites/{siteId}/plants`

- Summary: Get all plants for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Plants retrieved | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `POST` `/sites/{siteId}/plants`

- Summary: Create a new plant in a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/PlantCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Plant created | `application/json` `object` |
| `400` | Data tidak valid | `application/json` `#/components/schemas/Error` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |

### `GET` `/sites/{siteId}/plants/{plantId}`

- Summary: Get plant by id
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `plantId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Plant retrieved | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |
| `404` | Plant tidak ditemukan | `application/json` `#/components/schemas/Error` |

### `POST` `/sites/{siteId}/plants/{plantId}/harvest`

- Summary: Harvest a plant
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `plantId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Plant berhasil dipanen | `application/json` `object` |
| `401` | Tidak terautentikasi | `application/json` `#/components/schemas/Error` |
| `404` | Plant tidak ditemukan | `application/json` `#/components/schemas/Error` |

## Unit

### `GET` `/sites/units`

- Summary: Get all units
- Auth: no

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Units retrieved | `application/json` `object` |

### `POST` `/sites/units/create-units`

- Summary: Create a unit
- Auth: no

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/UnitCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Unit created | `application/json` `object` |

## Task

### `GET` `/sites/{siteId}/tasks`

- Summary: Get all tasks for a site
- Description: Ambil semua task milik site. Bisa difilter berdasarkan task_type, task_sts, dan task_priority.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` | ID site |
| `task_type` | query | no | `string enum(PLANTING, FERTILIZING, HARVESTING, WATERING, PESTCONTROL, MONITORING, MAINTENANCE, OTHER)` | Filter berdasarkan jenis task |
| `task_sts` | query | no | `string enum(PENDING, PROGRESS, COMPLITE, FAILED)` | Filter berdasarkan status task |
| `task_priority` | query | no | `string enum(LOW, MEDIUM, HIGH)` | Filter berdasarkan prioritas |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Tasks berhasil diambil | `application/json` `object` |
| `401` | Tidak terautentikasi |  |
| `404` | Site tidak ditemukan |  |

### `POST` `/sites/{siteId}/tasks`

- Summary: Buat task baru untuk site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` | ID site |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/TaskCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Task berhasil dibuat | `application/json` `object` |
| `400` | Validasi gagal — field tidak valid atau tidak lengkap |  |
| `401` | Tidak terautentikasi |  |

### `GET` `/sites/{siteId}/tasks/{id}`

- Summary: Get task by ID
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` | ID site |
| `id` | path | yes | `string` | ID task |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Task ditemukan | `application/json` `object` |
| `401` | Tidak terautentikasi |  |
| `404` | Task tidak ditemukan |  |

### `PUT` `/sites/{siteId}/tasks/{id}`

- Summary: Update task
- Description: Update data task. Mengubah task_sts ke COMPLITE akan otomatis mengisi task_complited_date. Mengubah ke status lain akan me-reset task_complited_date.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` | ID site |
| `id` | path | yes | `string` | ID task |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/TaskUpdateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Task berhasil diupdate | `application/json` `object` |
| `400` | Validasi gagal |  |
| `401` | Tidak terautentikasi |  |
| `404` | Task tidak ditemukan |  |

### `DELETE` `/sites/{siteId}/tasks/{id}`

- Summary: Hapus task
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` | ID site |
| `id` | path | yes | `string` | ID task |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Task berhasil dihapus | `application/json` `object` |
| `401` | Tidak terautentikasi |  |
| `404` | Task tidak ditemukan |  |

## Profile

### `GET` `/profile/me`

- Summary: Get current user profile
- Auth: yes

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | User profile retrieved | `application/json` `object` |
| `401` | Unauthorized |  |

### `GET` `/profile/permissions`

- Summary: Get current user permissions
- Auth: yes

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Permissions retrieved | `application/json` `object` |
| `401` | Unauthorized |  |

### `GET` `/profile/debug-token`

- Summary: Debug: Get decoded JWT token
- Auth: yes

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Token decoded successfully | `application/json` `object` |
| `401` | Unauthorized |  |

## Forum

### `GET` `/forum/posts`

- Summary: Get all forum posts (paginated)
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `page` | query | no | `integer` |  |
| `limit` | query | no | `integer` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Posts retrieved | `application/json` `#/components/schemas/ForumPostsResponse` |
| `401` | Unauthorized |  |

### `POST` `/forum/posts`

- Summary: Create new forum post (dengan opsional upload gambar)
- Auth: yes

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `multipart/form-data` | yes | `object` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Post created | `application/json` `object` |
| `400` | forum_title atau forum_content kosong / format gambar tidak valid |  |
| `401` | Unauthorized |  |

### `GET` `/forum/posts/my-posts`

- Summary: Get posts milik user yang sedang login
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `page` | query | no | `integer` |  |
| `limit` | query | no | `integer` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | My posts retrieved | `application/json` `#/components/schemas/ForumPostsResponse` |
| `401` | Unauthorized |  |

### `GET` `/forum/posts/liked-posts`

- Summary: Get posts yang di-like oleh user yang sedang login
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `page` | query | no | `integer` |  |
| `limit` | query | no | `integer` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Liked posts retrieved | `application/json` `#/components/schemas/ForumPostsResponse` |
| `401` | Unauthorized |  |

### `GET` `/forum/my-comments`

- Summary: Get komentar milik user yang sedang login
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `page` | query | no | `integer` |  |
| `limit` | query | no | `integer` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | My comments retrieved | `application/json` `object` |
| `401` | Unauthorized |  |

### `GET` `/forum/posts/{postId}`

- Summary: Get forum post by ID
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Post retrieved | `application/json` `object` |
| `401` | Unauthorized |  |
| `404` | Post not found |  |

### `PUT` `/forum/posts/{postId}`

- Summary: Update forum post (hanya pemilik)
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `multipart/form-data` | no | `object` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Post updated | `application/json` `object` |
| `401` | Unauthorized |  |
| `403` | Forbidden — bukan pemilik post |  |
| `404` | Post not found |  |

### `DELETE` `/forum/posts/{postId}`

- Summary: Hapus forum post beserta semua komentar dan interaksinya (hanya pemilik)
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Post deleted |  |
| `401` | Unauthorized |  |
| `403` | Forbidden — bukan pemilik post |  |
| `404` | Post not found |  |

### `POST` `/forum/posts/{postId}/like`

- Summary: Toggle like/dislike pada post. Kirim action yang sama 2x untuk membatalkan.
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `object` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Like toggled | `application/json` `object` |
| `400` | action harus LIKE atau DISLIKE |  |
| `401` | Unauthorized |  |
| `404` | Post not found |  |

### `POST` `/forum/posts/{postId}/share`

- Summary: Tambah share count post
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Share count incremented | `application/json` `object` |
| `401` | Unauthorized |  |
| `404` | Post not found |  |

### `GET` `/forum/posts/{postId}/reactions`

- Summary: Get semua reaksi (like/dislike) pada post
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Reactions retrieved | `application/json` `object` |
| `401` | Unauthorized |  |
| `404` | Post not found |  |

### `GET` `/forum/posts/{postId}/comments`

- Summary: Get komentar pada post (paginated)
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |
| `page` | query | no | `integer` |  |
| `limit` | query | no | `integer` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Comments retrieved | `application/json` `object` |
| `401` | Unauthorized |  |
| `404` | Post not found |  |

### `POST` `/forum/posts/{postId}/comments`

- Summary: Tambah komentar pada post
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/CommentCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Comment created | `application/json` `object` |
| `400` | cf_content kosong |  |
| `401` | Unauthorized |  |
| `404` | Post not found |  |

### `DELETE` `/forum/posts/{postId}/comments/{commentId}`

- Summary: Hapus komentar (pemilik komentar atau pemilik post)
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `postId` | path | yes | `string` |  |
| `commentId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Comment deleted |  |
| `401` | Unauthorized |  |
| `403` | Forbidden — bukan pemilik komentar atau post |  |
| `404` | Post or comment not found |  |

## Notes

### `GET` `/sites/{siteId}/notes`

- Summary: Get all notes for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |
| `page` | query | no | `integer` |  |
| `limit` | query | no | `integer` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Notes retrieved | `application/json` `object` |
| `401` | Unauthorized |  |

### `POST` `/sites/{siteId}/notes`

- Summary: Create new note for a site
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `siteId` | path | yes | `string` |  |

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/NoteCreateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `201` | Note created | `application/json` `object` |
| `401` | Unauthorized |  |

## Comments

### `PUT` `/comments`

- Summary: Update forum comment
- Auth: yes

Request Body:

| Content-Type | Required | Schema |
| --- | --- | --- |
| `application/json` | yes | `#/components/schemas/CommentUpdateRequest` |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Comment updated |  |
| `401` | Unauthorized |  |
| `404` | Comment not found |  |

### `DELETE` `/comments/{commentId}`

- Summary: Delete forum comment
- Auth: yes

Parameters:

| Name | In | Required | Type | Description |
| --- | --- | --- | --- | --- |
| `commentId` | path | yes | `string` |  |

Responses:

| Code | Description | Schema |
| --- | --- | --- |
| `200` | Comment deleted |  |
| `401` | Unauthorized |  |
| `404` | Comment not found |  |

## Schemas

### Error
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `message` | `string` | no | example: `Error message` |

### LoginRequest
- Type: `object`
- Required: `username`, `password`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `username` | `string` | yes | example: `john.doe` |
| `password` | `string` | yes | example: `password123` |

### CreateUserRequest
- Type: `object`
- Required: `user_id`, `user_name`, `user_email`, `user_pass`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `user_id` | `string` | yes | example: `USR_001` |
| `user_name` | `string` | yes | example: `John Doe` |
| `user_email` | `string` | yes | example: `john@example.com` |
| `user_pass` | `string` | yes | example: `password123` |
| `user_phone` | `string` | no | example: `081234567890` |
| `user_sts` | `string?` | no | example: `active` |
| `role_id` | `string` | no | example: `ROLE002` |

### UpdateUserRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `user_name` | `string` | no | example: `John Doe Updated` |
| `user_email` | `string` | no | example: `john.updated@example.com` |
| `user_phone` | `string` | no | example: `081234567890` |
| `user_sts` | `string` | no | example: `active` |

### User
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `user_id` | `string` | no | example: `USR_001` |
| `user_name` | `string` | no | example: `John Doe` |
| `user_email` | `string` | no | example: `john@example.com` |
| `user_phone` | `string` | no | example: `081234567890` |
| `user_sts` | `string` | no | example: `active` |
| `role_id` | `string` | no | example: `ROLE002` |

### Role
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `role_id` | `string` | no | example: `ROLE001` |
| `role_name` | `string?` | no | example: `Admin` |
| `role_desc` | `string?` | no | example: `Administrator role` |
| `role_sts` | `integer?` | no | example: `1` |

### RoleCreateRequest
- Type: `object`
- Required: `role_id`, `role_name`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `role_id` | `string` | yes | example: `ROLE003` |
| `role_name` | `string` | yes | example: `Supervisor` |
| `role_desc` | `string?` | no | example: `Role untuk supervisor` |
| `role_sts` | `integer?` | no | example: `1` |

### RoleUpdateRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `role_name` | `string` | no | example: `Supervisor` |
| `role_desc` | `string?` | no | example: `Role untuk supervisor` |
| `role_sts` | `integer?` | no | example: `1` |

### SiteMemberInviteRequest
- Type: `object`
- Required: `user_id`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `user_id` | `string` | yes | example: `USR_001` |

### SiteMember
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `sm_id` | `string` | no | example: `SM_001` |
| `site_id` | `string` | no | example: `SITE_001` |
| `user_id` | `string` | no | example: `USR_001` |
| `role_id` | `string?` | no | example: `ROLE_INVITE` |
| `sm_sts` | `integer?` | no | example: `1` |
| `sn_created` | `string:date-time?` | no | example: `2026-05-13T00:00:00.000Z` |

### RecommendationSensorData
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `nitrogen` | `number` | no | Nitrogen tanah (ppm); example: `80` |
| `phosphorus` | `number` | no | Fosfor tanah (ppm); example: `20` |
| `potassium` | `number` | no | Kalium tanah (ppm); example: `90` |
| `ph` | `number` | no | pH tanah; example: `6.2` |
| `env_temp` | `number?` | no | Suhu udara (°C); example: `30` |
| `env_hum` | `number?` | no | Kelembaban udara (%RH); example: `75` |
| `soil_temp` | `number?` | no | Suhu tanah (°C); example: `26` |
| `soil_hum` | `number?` | no | Kelembaban tanah (%VWC); example: `80` |

### RecommendationActionResult
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `status` | `string enum(rendah, normal, tinggi)` | no | example: `rendah` |
| `pesan` | `string` | no | example: `Rekomendasikan penambahan Urea. N sangat krusial untuk daun.` |
| `dosis_kg_ha` | `number` | no | example: `21.6` |

### EnvironmentalActionResult
Hasil rekomendasi parameter lingkungan (tanpa dosis)

- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `status` | `string enum(rendah, normal, tinggi)` | no | example: `tinggi` |
| `pesan` | `string` | no | example: `Tambah frekuensi penyiraman dan beri naungan 30–40% di siang hari.` |

### RecommendationNpkResult
- Type: oneOf(`#/components/schemas/RecommendationActionResult`, `string`, `null`)

### LingkunganBundle
Rekomendasi parameter lingkungan per sensor

- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `env_temp` | oneOf(`#/components/schemas/EnvironmentalActionResult`, `null`) | no |  |
| `env_hum` | oneOf(`#/components/schemas/EnvironmentalActionResult`, `null`) | no |  |
| `soil_temp` | oneOf(`#/components/schemas/EnvironmentalActionResult`, `null`) | no |  |
| `soil_hum` | oneOf(`#/components/schemas/EnvironmentalActionResult`, `null`) | no |  |

### RecommendationBundle
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `npk` | `#/components/schemas/RecommendationNpkResult` | no |  |
| `ph` | `#/components/schemas/RecommendationNpkResult` | no |  |
| `lingkungan` | `#/components/schemas/LingkunganBundle` | no |  |

### RecommendationLiveData
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `sensor_data` | `#/components/schemas/RecommendationSensorData` | no |  |
| `recommendations` | `#/components/schemas/RecommendationBundle` | no |  |
| `cached` | `boolean` | no | example: `False` |

### RecommendationCachedData
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `sensor_data` | `#/components/schemas/RecommendationSensorData` | no |  |
| `recommendations` | `#/components/schemas/RecommendationBundle` | no |  |
| `cached` | `boolean` | no | example: `True` |
| `cached_at` | `string:date-time` | no | example: `2026-05-23T00:00:00.000Z` |

### PlantRecommendationRequest
- Type: `object`
- Required: `soil_nitro`, `soil_phos`, `soil_pot`, `env_temp`, `env_hum`, `soil_ph`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `soil_nitro` | `number` | yes | example: `12.4` |
| `soil_phos` | `number` | yes | example: `8.2` |
| `soil_pot` | `number` | yes | example: `10.5` |
| `env_temp` | `number` | yes | example: `30.2` |
| `env_hum` | `number` | yes | example: `75.1` |
| `soil_ph` | `number` | yes | example: `6.4` |

### DummyRecommendationSensorData
Data sensor dummy. NPK & pH wajib; env & soil opsional untuk rekomendasi lingkungan.

- Type: `object`
- Required: `soil_nitro`, `soil_phos`, `soil_pot`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `soil_nitro` | `number` | yes | Nitrogen tanah (ppm) — normal Fase Bibit: 90–120; example: `50` |
| `soil_phos` | `number` | yes | Fosfor tanah (ppm) — normal Fase Bibit: 15–25; example: `10` |
| `soil_pot` | `number` | yes | Kalium tanah (ppm) — normal Fase Bibit: 80–110; example: `95` |
| `soil_ph` | `number` | no | pH tanah — normal: 5.5–7.0; example: `5` |
| `env_temp` | `number?` | no | Suhu udara (°C) — normal Fase Bibit: 22–32; example: `35` |
| `env_hum` | `number?` | no | Kelembaban udara (%RH) — normal Fase Bibit: 70–90; example: `50` |
| `soil_temp` | `number?` | no | Suhu tanah (°C) — normal Fase Bibit: 22–30; example: `18` |
| `soil_hum` | `number?` | no | Kelembaban tanah (%VWC) — normal Fase Bibit: 75–95; example: `97` |

### DummyRecommendationRequest
- Type: `object`
- Required: `phase`, `sensorData`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `phase` | `string enum(Perkecambahan, Fase Bibit, Fase Anakan (Tillering), Perpanjangan Batang, Bunting (Booting), Berbunga (Heading), Pengisian Biji, Pemasakan)` | yes | example: `Fase Bibit` |
| `sensorData` | `#/components/schemas/DummyRecommendationSensorData` | yes |  |

### DummyRecommendationSaveRequest
- Type: `object`
- Required: `siteId`, `phase`, `sensorData`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `siteId` | `string` | yes | example: `SITE_001` |
| `phase` | `string enum(Perkecambahan, Fase Bibit, Fase Anakan (Tillering), Perpanjangan Batang, Bunting (Booting), Berbunga (Heading), Pengisian Biji, Pemasakan)` | yes | example: `Fase Bibit` |
| `sensorData` | `#/components/schemas/DummyRecommendationSensorData` | yes |  |

### RecommendationPhaseItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `rec_id` | `string` | no | example: `REC_001` |
| `phase_id` | `string` | no | example: `PHASE_001` |
| `title` | `string` | no | example: `Tambah nitrogen` |
| `description` | `string` | no | example: `Rekomendasi untuk fase vegetatif` |
| `priority` | `string` | no | example: `high` |
| `category` | `string` | no | example: `NPK` |

### RecommendationHistoryItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `date` | `string:date-time` | no | example: `2026-05-13T00:00:00.000Z` |
| `sensor_data` | `#/components/schemas/RecommendationSensorData` | no |  |
| `recommendations` | `object` | no |  |
| `created_at` | `string:date-time` | no | example: `2026-05-13T00:00:00.000Z` |

### DeviceSensor
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `ds_id` | `string` | no | example: `DS_001` |
| `dev_id` | `string` | no | example: `DEV_001` |
| `unit_id` | `string` | no | example: `UNIT_001` |
| `sens_id` | `string` | no | example: `SENS_001` |
| `dc_normal_value` | `number` | no | example: `25` |
| `ds_min_norm_value` | `number?` | no | example: `20` |
| `ds_max_norm_value` | `number?` | no | example: `30` |
| `ds_min_value` | `number` | no | example: `10` |
| `ds_max_value` | `number` | no | example: `40` |
| `ds_min_val_warn` | `number` | no | example: `12` |
| `ds_max_val_warn` | `number` | no | example: `38` |
| `ds_name` | `string?` | no | example: `Temperature Device Sensor` |
| `ds_address` | `string?` | no | example: `A1` |
| `ds_sts` | `integer?` | no | example: `1` |

### DeviceSensorCreateRequest
- Type: `object`
- Required: `ds_id`, `dev_id`, `unit_id`, `sens_id`, `dc_normal_value`, `ds_min_value`, `ds_max_value`, `ds_min_val_warn`, `ds_max_val_warn`, `ds_min_norm_value`, `ds_max_norm_value`, `ds_name`, `ds_address`, `ds_sequence`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `ds_id` | `string` | yes | example: `DS_001` |
| `dev_id` | `string` | yes | example: `DEV_001` |
| `unit_id` | `string` | yes | example: `UNIT_001` |
| `sens_id` | `string` | yes | example: `SENS_001` |
| `dc_normal_value` | `number` | yes | example: `25` |
| `ds_min_value` | `number` | yes | example: `10` |
| `ds_max_value` | `number` | yes | example: `40` |
| `ds_min_val_warn` | `number` | yes | example: `12` |
| `ds_max_val_warn` | `number` | yes | example: `38` |
| `ds_min_norm_value` | `number` | yes | example: `20` |
| `ds_max_norm_value` | `number` | yes | example: `30` |
| `ds_name` | `string` | yes | example: `Temperature Device Sensor` |
| `ds_address` | `string` | yes | example: `A1` |
| `ds_sequence` | `integer` | yes | example: `1` |
| `ds_sts` | `integer enum(0, 1)` | no | example: `1` |

### DeviceSensorUpdateRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `ds_id` | `string` | no | example: `DS_001` |
| `dev_id` | `string` | no | example: `DEV_001` |
| `unit_id` | `string` | no | example: `UNIT_001` |
| `sens_id` | `string` | no | example: `SENS_001` |
| `dc_normal_value` | `number` | no | example: `25` |
| `ds_min_value` | `number` | no | example: `10` |
| `ds_max_value` | `number` | no | example: `40` |
| `ds_min_val_warn` | `number` | no | example: `12` |
| `ds_max_val_warn` | `number` | no | example: `38` |
| `ds_min_norm_value` | `number` | no | example: `20` |
| `ds_max_norm_value` | `number` | no | example: `30` |
| `ds_name` | `string` | no | example: `Temperature Device Sensor` |
| `ds_address` | `string` | no | example: `A1` |
| `ds_sequence` | `integer` | no | example: `1` |
| `ds_sts` | `integer enum(0, 1)` | no | example: `1` |

### DeviceSensorRange
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `dev_id` | `string` | no | example: `DEV_001` |
| `ds_id` | `string` | no | example: `DS_001` |
| `ds_max_norm_value` | `number?` | no | example: `30` |
| `ds_min_norm_value` | `number?` | no | example: `20` |
| `ds_max_val_warn` | `number?` | no | example: `38` |
| `ds_min_val_warn` | `number?` | no | example: `12` |
| `ds_max_value` | `number?` | no | example: `40` |
| `ds_min_value` | `number?` | no | example: `10` |

### SensorRead
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `read_id` | `string` | no | example: `read_001` |
| `ds_id` | `string` | no | example: `DS_001` |
| `dev_id` | `string` | no | example: `DEV_001` |
| `log_rx_id` | `string` | no | example: `LOG_001` |
| `read_date` | `string:date-time` | no | example: `2026-05-13T00:00:00.000Z` |
| `read_value` | `string` | no | example: `25.3` |
| `read_sts` | `integer` | no | example: `1` |

### SensorUpdate
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `read_update_id` | `string` | no | example: `DEV_001-DS_001` |
| `ds_id` | `string` | no | example: `DS_001` |
| `dev_id` | `string` | no | example: `DEV_001` |
| `read_update_date` | `string:date-time?` | no | example: `2026-05-13T00:00:00.000Z` |
| `read_update_value` | `string?` | no | example: `25.3` |

### DailyRekap
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `day` | `string:date-time` | no | example: `2026-05-13T00:00:00.000Z` |
| `dev_id` | `string` | no | example: `DEV_001` |
| `ds_id` | `string` | no | example: `DS_001` |
| `min_val` | `number?` | no | example: `20.1` |
| `max_val` | `number?` | no | example: `28.7` |
| `avg_val` | `number?` | no | example: `24.4` |

### MonthlyRekap
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `month` | `object` | no |  |
| `day_reads` | array<`object`> | no |  |

### DailyRekapRequest
- Type: `object`
- Required: `day`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `day` | `string` | yes | example: `2026-05-13` |

### Site
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `site_id` | `string` | no | example: `SITE_001` |
| `site_name` | `string` | no | example: `Kebun Demo A` |
| `site_address` | `string` | no | example: `Jl. Raya Pertanian No. 1` |
| `site_lat` | `number` | no | example: `-6.9` |
| `site_lon` | `number` | no | example: `107.6` |
| `site_alt` | `number` | no | example: `120` |
| `site_sts` | `integer enum(0, 1)` | no | example: `1` |

### SiteCreateRequest
- Type: `object`
- Required: `site_id`, `site_name`, `site_address`, `site_lat`, `site_lon`, `site_alt`, `site_sts`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `site_id` | `string` | yes | example: `SITE_001` |
| `site_name` | `string` | yes | example: `Kebun Demo A` |
| `site_address` | `string` | yes | example: `Jl. Raya Pertanian No. 1` |
| `site_lat` | `number` | yes | example: `-6.9` |
| `site_lon` | `number` | yes | example: `107.6` |
| `site_alt` | `number` | yes | example: `120` |
| `site_sts` | `integer enum(0, 1)` | yes | example: `1` |

### SiteUpdateRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `site_name` | `string` | no | example: `Kebun Demo A Updated` |
| `site_address` | `string` | no | example: `Jl. Raya Pertanian No. 99` |
| `site_lat` | `number` | no | example: `-6.91` |
| `site_lon` | `number` | no | example: `107.61` |
| `site_alt` | `number` | no | example: `121` |
| `site_sts` | `integer enum(0, 1)` | no | example: `1` |

### Device
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `dev_id` | `string` | no | example: `DEV_001` |
| `site_id` | `string` | no | example: `SITE_001` |
| `user_id` | `string` | no | example: `USR_001` |
| `dev_name` | `string` | no | example: `Gateway 1` |
| `dev_token` | `string?` | no | example: `token_abc123` |
| `dev_location` | `string?` | no | example: `Greenhouse A` |
| `dev_lon` | `number?` | no | example: `107.6` |
| `dev_lat` | `number?` | no | example: `-6.9` |
| `dev_alt` | `number?` | no | example: `120` |
| `dev_number_id` | `string?` | no | example: `1` |
| `dev_ip` | `string?` | no | example: `192.168.1.10` |
| `dev_port` | `string?` | no | example: `8080` |
| `dev_sts` | `integer?` | no | example: `1` |

### DeviceCreateRequest
- Type: `object`
- Required: `dev_id`, `user_id`, `dev_name`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `dev_id` | `string` | yes | example: `DEV_001` |
| `user_id` | `string` | yes | example: `USR_001` |
| `dev_name` | `string` | yes | example: `Gateway 1` |
| `dev_location` | `string` | no | example: `Greenhouse A` |
| `dev_lon` | `number` | no | example: `107.6` |
| `dev_lat` | `number` | no | example: `-6.9` |
| `dev_alt` | `number` | no | example: `120` |
| `dev_sts` | `integer enum(0, 1)` | no | example: `1` |

### DeviceUpdateRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `user_id` | `string` | no | example: `USR_001` |
| `dev_name` | `string` | no | example: `Gateway 1 Updated` |
| `dev_location` | `string` | no | example: `Greenhouse B` |
| `dev_lon` | `number` | no | example: `107.61` |
| `dev_lat` | `number` | no | example: `-6.91` |
| `dev_alt` | `number` | no | example: `121` |
| `dev_token` | `string` | no | example: `token_abc123` |
| `dev_number_id` | `string` | no | example: `2` |
| `dev_ip` | `string` | no | example: `192.168.1.11` |
| `dev_port` | `string` | no | example: `8081` |
| `dev_sts` | `integer enum(0, 1)` | no | example: `1` |

### DeviceCoordinates
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `dev_id` | `string` | no | example: `DEV_001` |
| `dev_name` | `string` | no | example: `Gateway 1` |
| `dev_lon` | `number` | no | example: `107.6` |
| `dev_lat` | `number` | no | example: `-6.9` |
| `dev_alt` | `number` | no | example: `120` |
| `sensor` | array<`object`> | no |  |

### Sensor
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `sens_id` | `string` | no | example: `SENS_001` |
| `dev_id` | `string?` | no | example: `DEV_001` |
| `sens_name` | `string` | no | example: `Soil pH Sensor` |
| `sens_address` | `string?` | no | example: `A1` |
| `sens_location` | `string?` | no | example: `Block A` |
| `sens_lat` | `number?` | no | example: `-6.9` |
| `sens_lon` | `number?` | no | example: `107.6` |
| `sens_alt` | `number?` | no | example: `120` |

### SensorCreateRequest
- Type: `object`
- Required: `sens_id`, `dev_id`, `sens_name`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `sens_id` | `string` | yes | example: `SENS_001` |
| `dev_id` | `string` | yes | example: `DEV_001` |
| `sens_name` | `string` | yes | example: `Soil pH Sensor` |
| `sens_address` | `string` | no | example: `A1` |
| `sens_location` | `string` | no | example: `Block A` |
| `sens_lat` | `number` | no | example: `-6.9` |
| `sens_lon` | `number` | no | example: `107.6` |
| `sens_alt` | `number` | no | example: `120` |
| `sens_sts` | `integer enum(0, 1)` | no | example: `1` |

### SensorUpdateRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `dev_id` | `string` | no | example: `DEV_002` |
| `sens_name` | `string` | no | example: `Soil pH Sensor Updated` |
| `sens_address` | `string` | no | example: `A2` |
| `sens_location` | `string` | no | example: `Block B` |
| `sens_lat` | `number` | no | example: `-6.91` |
| `sens_lon` | `number` | no | example: `107.61` |
| `sens_alt` | `number` | no | example: `121` |

### SensorDetail
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `sensor` | `object?` | no |  |
| `updates` | array<`object`> | no |  |
| `latest_read` | array<`object`> | no |  |

### AgroGddDailyItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `day` | `string` | no | example: `2026-05-13` |
| `tempMin` | `number?` | no | example: `20.1` |
| `tempMax` | `number?` | no | example: `28.7` |
| `gdd` | `number` | no | example: `3.2` |

### AgroEtcItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `etc` | `number` | no | example: `4.12` |
| `day` | `string` | no | example: `2026-05-13` |
| `tempMin` | `number?` | no | example: `20.1` |
| `tempMax` | `number?` | no | example: `28.7` |
| `rhMin` | `number?` | no | example: `60` |
| `rhMax` | `number?` | no | example: `85` |

### AgroGddResult
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `totalGDD` | `number` | no | example: `123.4` |
| `daily` | array<`#/components/schemas/AgroGddDailyItem`> | no |  |

### AgroVdp
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `v` | `number` | no | example: `0.5` |
| `d` | `number` | no | example: `0.3` |
| `p` | `number` | no | example: `0.2` |

### AgroData
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `vdp` | `#/components/schemas/AgroVdp` | no |  |
| `gdd` | `#/components/schemas/AgroGddResult` | no |  |
| `etc` | array<`#/components/schemas/AgroEtcItem`> | no |  |

### EnvironmentalHealthSensorItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `dev_id` | `string` | no | example: `DEV_001` |
| `ds_id` | `string` | no | example: `DS_001` |
| `read_update_value` | `string` | no | example: `25.3` |
| `persentase` | `number` | no | example: `85` |

### EnvironmentalHealthResponse
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `overall_health` | `number` | no | example: `88.5` |
| `total_sensors` | `integer` | no | example: `12` |
| `sensors` | array<`#/components/schemas/EnvironmentalHealthSensorItem`> | no |  |

### PhaseItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `phase_id` | `string` | no | example: `PHASE_001` |
| `phase_name` | `string` | no | example: `Vegetative` |
| `phase_order` | `integer` | no | example: `1` |
| `phase_hst_min` | `integer` | no | example: `0` |
| `phase_hst_max` | `integer` | no | example: `30` |
| `chrop_type` | `string` | no | example: `PADI` |

### PlantItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `plant_id` | `string` | no | example: `PLANT_001` |
| `site_id` | `string` | no | example: `SITE_001` |
| `varietas_id` | `string` | no | example: `VAR_001` |
| `plant_name` | `string` | no | example: `Padi Demo` |
| `plant_type` | `string` | no | example: `PADI` |
| `plant_species` | `string` | no | example: `Oryza sativa` |
| `plant_date` | `string:date-time` | no | example: `2026-05-01T00:00:00.000Z` |
| `plant_sts` | `integer` | no | example: `1` |

### PlantCreateRequest
- Type: `object`
- Required: `plant_name`, `varietas_id`, `plant_date`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `plant_name` | `string` | yes | example: `Padi Demo` |
| `varietas_id` | `string` | yes | example: `VAR_001` |
| `plant_date` | `string:date` | yes | example: `2026-05-01` |
| `plant_type` | `string` | no | example: `PADI` |

### UnitItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `unit_id` | `string` | no | example: `UNIT_001` |
| `unit_name` | `string` | no | example: `Kilogram` |
| `unit_symbol` | `string` | no | example: `kg` |
| `unit_sts` | `integer` | no | example: `1` |

### UnitCreateRequest
- Type: `object`
- Required: `unit_id`, `unit_name`, `unit_symbol`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `unit_id` | `string` | yes | example: `UNIT_001` |
| `unit_name` | `string` | yes | example: `Kilogram` |
| `unit_symbol` | `string` | yes | example: `kg` |
| `unit_sts` | `integer enum(0, 1)` | no | example: `1` |

### TaskItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `task_id` | `string` | no | example: `a3f9c12b8d4e7f2a1c6b9d0e` |
| `site_id` | `string` | no | example: `SITE_001` |
| `task_name` | `string` | no | example: `Irigasi pagi` |
| `task_desc` | `string` | no | example: `Lakukan irigasi 2x sehari selama fase vegetatif` |
| `task_type` | `string enum(PLANTING, FERTILIZING, HARVESTING, WATERING, PESTCONTROL, MONITORING, MAINTENANCE, OTHER)` | no | example: `WATERING` |
| `task_priority` | `string enum(LOW, MEDIUM, HIGH)` | no | example: `HIGH` |
| `task_sts` | `string enum(PENDING, PROGRESS, COMPLITE, FAILED)` | no | example: `PENDING` |
| `task_complited_date` | `string:date-time?` | no | example: `` |
| `task_created` | `string:date-time` | no | example: `2026-05-01T08:00:00.000Z` |
| `task_update` | `string:date-time?` | no | example: `` |

### TaskCreateRequest
- Type: `object`
- Required: `task_name`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `task_name` | `string` | yes | example: `Irigasi pagi` |
| `task_desc` | `string` | no | example: `Lakukan irigasi 2x sehari selama fase vegetatif` |
| `task_type` | `string enum(PLANTING, FERTILIZING, HARVESTING, WATERING, PESTCONTROL, MONITORING, MAINTENANCE, OTHER)` | no | example: `WATERING` |
| `task_priority` | `string enum(LOW, MEDIUM, HIGH)` | no | example: `HIGH` |
| `task_sts` | `string enum(PENDING, PROGRESS, COMPLITE, FAILED)` | no | example: `PENDING` |

### TaskUpdateRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `task_name` | `string` | no | example: `Irigasi pagi - diperbarui` |
| `task_desc` | `string` | no | example: `Deskripsi diperbarui` |
| `task_type` | `string enum(PLANTING, FERTILIZING, HARVESTING, WATERING, PESTCONTROL, MONITORING, MAINTENANCE, OTHER)` | no | example: `WATERING` |
| `task_priority` | `string enum(LOW, MEDIUM, HIGH)` | no | example: `MEDIUM` |
| `task_sts` | `string enum(PENDING, PROGRESS, COMPLITE, FAILED)` | no | Mengubah ke COMPLITE akan otomatis mengisi task_complited_date; example: `COMPLITE` |

### ProfileData
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `user_id` | `string` | no | example: `USR_001` |
| `user_name` | `string` | no | example: `John Doe` |
| `user_email` | `string` | no | example: `john@example.com` |
| `user_phone` | `string` | no | example: `081234567890` |
| `role_id` | `string` | no | example: `ROLE_001` |
| `role_name` | `string` | no | example: `Admin` |

### Permission
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `perm_id` | `string` | no | example: `PERM_001` |
| `perm_name` | `string` | no | example: `read:site` |
| `perm_page` | `string?` | no | example: `sites` |

### PaginationMeta
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `page` | `integer` | no | example: `1` |
| `limit` | `integer` | no | example: `10` |
| `total` | `integer` | no | example: `50` |
| `total_pages` | `integer` | no | example: `5` |

### ForumUserSummary
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `user_name` | `string?` | no | example: `John Doe` |
| `user_avatar` | `string?` | no | example: `https://storage.supabase.co/avatars/usr001.jpg` |

### ForumPost
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `forum_id` | `string` | no | example: `clxxxxxxxxxxxxxxxxxxxxxxxx` |
| `forum_title` | `string?` | no | example: `Pertanyaan tentang Irigasi` |
| `forum_content` | `string?` | no | example: `Berapa kali irigasi dalam sehari?` |
| `forum_image_url` | `string?` | no | example: `https://storage.supabase.co/forum/img.jpg` |
| `forum_user_id` | `string` | no | example: `USR_001` |
| `forum_site_id` | `string?` | no | example: `SITE_001` |
| `forum_like_count` | `integer?` | no | example: `12` |
| `forum_dislike_count` | `integer?` | no | example: `2` |
| `forum_share_count` | `integer?` | no | example: `5` |
| `is_liked` | `string? enum(LIKE, DISLIKE, null)` | no | example: `LIKE` |
| `forum_created` | `string:date-time?` | no | example: `2026-05-13T00:00:00.000Z` |
| `forum_update` | `string:date-time?` | no | example: `2026-05-14T00:00:00.000Z` |
| `user` | `#/components/schemas/ForumUserSummary` | no |  |

### ForumCreateRequest
- Type: `object`
- Required: `forum_title`, `forum_content`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `forum_title` | `string` | yes | example: `Pertanyaan tentang Irigasi` |
| `forum_content` | `string` | yes | example: `Berapa kali irigasi dalam sehari?` |
| `forum_image_url` | `string:uri` | no | example: `https://storage.supabase.co/forum/img.jpg` |

### ForumUpdateRequest
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `forum_title` | `string` | no | example: `Judul diperbarui` |
| `forum_content` | `string` | no | example: `Konten diperbarui` |
| `forum_image_url` | `string:uri?` | no | example: `https://storage.supabase.co/forum/new.jpg` |

### ForumPostsResponse
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `status` | `integer` | no | example: `200` |
| `message` | `string` | no | example: `Posts retrieved successfully` |
| `data` | `object` | no |  |

### CommentItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `comment_id` | `string` | no | example: `clxxxxxxxxxxxxxxxxxxxxxxxx` |
| `forum_id` | `string` | no | example: `clxxxxxxxxxxxxxxxxxxxxxxxx` |
| `cf_content` | `string` | no | example: `Irigasi 2 kali sehari saat musim kemarau` |
| `cf_created` | `string:date-time` | no | example: `2026-05-13T00:00:00.000Z` |
| `cf_updated` | `string:date-time` | no | example: `2026-05-14T00:00:00.000Z` |
| `user` | `object?` | no |  |

### CommentCreateRequest
- Type: `object`
- Required: `cf_content`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `cf_content` | `string` | yes | example: `Irigasi 2 kali sehari saat musim kemarau` |

### CommentUpdateRequest
- Type: `object`
- Required: `cf_id`, `cf_content`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `cf_id` | `string` | yes | example: `COMMENT_001` |
| `cf_content` | `string` | yes | example: `Irigasi 2-3 kali sehari` |

### NoteItem
- Type: `object`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `note_id` | `string` | no | example: `NOTE_001` |
| `site_id` | `string` | no | example: `SITE_001` |
| `user_id` | `string` | no | example: `USR_001` |
| `note_content` | `string` | no | example: `Catatan penting tentang tanaman` |
| `created_at` | `string:date-time` | no | example: `2026-05-13T00:00:00.000Z` |

### NoteCreateRequest
- Type: `object`
- Required: `note_content`

| Field | Type | Required | Description / Example |
| --- | --- | --- | --- |
| `note_content` | `string` | yes | example: `Catatan penting tentang tanaman` |

## Catatan Sinkronisasi Frontend

Endpoint di dokumen ini adalah sumber kebenaran terbaru dari Swagger backend live. Jika konstanta Flutter berbeda dari path di dokumen ini, konstanta Flutter harus diperbaiki mengikuti dokumen ini, bukan sebaliknya.

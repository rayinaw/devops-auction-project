# devops-auction-project

## Dotnet Migration

- Install dotnet-ef `dotnet tool install dotnet-ef`

Khởi tạo migrations:
- `dotnet ef migrations add "InitialCreate" -o Data/Migrations`
Thực thi migrations:
- `dotnet ef database update`


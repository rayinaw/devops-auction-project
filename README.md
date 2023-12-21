# devops-auction-project

## Check lỗi config trong quá trình khởi chạy
- `dotnet watch run --verbose`

## Một vài lỗi thường gặp
- launchSettings.json sẽ parse lỗi nếu có dấu `,` ở phần tử cuối cùng.

## Dotnet Migration

- Install dotnet-ef `dotnet tool install dotnet-ef`

Khởi tạo migrations:
- `dotnet ef migrations add "InitialCreate" -o Data/Migrations`

Thực thi migrations:
- `dotnet ef database update`

## Add Service
- `dotnet new webapi -o src/SearchService`
- `dotnet sln add src/SearchService`
## Vim shortcut

- Thêm dòng mới:
  - Dưới cursor: `o`
  - Trên cursor: `O`
- Đầu file: `gg`
- Cuối file: `G`
- Bôi đen toàn dòng `V`, sau đó có thể sử dụng lên xuống để bôi đen
- Bôi đen có thể select `v`. Có thể sử dụng ijkl để select, nó sẽ bắt đầu từ chữ cái nằm ở cursor hiện tại.
- Bôi đen toàn file: `ggVG` hoặc `ggvG` 

- Đi đến đầu dòng nhất định: `:<num>` ví dụ `:10`
- insert mode `i` sẽ insert ở trước cursor hiện tại. `a` sẽ insert ở sau cursor hiện tại.
- `A`: insert mode cuối dòng
- `I`: insert mode đầu dòng
- `==`: indent code đúng format
- `gg=G`: format (indent) cho toàn file

General command:
```
>>   Indent line by shiftwidth spaces
<<   De-indent line by shiftwidth spaces
5>>  Indent 5 lines
5==  Re-indent 5 lines

>%   Increase indent of a braced or bracketed block (place cursor on brace first)
=%   Reindent a braced or bracketed block (cursor on brace)
<%   Decrease indent of a braced or bracketed block (cursor on brace)
]p   Paste text, aligning indentation with surroundings

=i{  Re-indent the 'inner block', i.e. the contents of the block
=a{  Re-indent 'a block', i.e. block and containing braces
=2a{ Re-indent '2 blocks', i.e. this block and containing block

>i{  Increase inner block indent
<i{  Decrease inner block indent
```
Build An Atomic Red Team VM
===
## Description
Atomic Red Team là một dự án nguồn mở cung cấp một framework để thực hiện kiểm tra bảo mật và mô phỏng mối đe dọa. Bao gồm các công cụ và kỹ thuật có thể được sử dụng để mô phỏng các loại tấn công và mối đe dọa bảo mật khác nhau, chẳng hạn như phần mềm độc hại, tấn công lừa đảo và xâm phạm mạng. Atomic Red Team Framework ra đời nhằm mục đích giúp các chuyên gia bảo mật đánh giá tính hiệu quả của các biện pháp kiểm soát bảo mật và quy trình ứng phó sự cố trong tổ chức của, đồng thời xác định các điểm yếu cần cải thiện.

Atomic Red Team Framework được thiết kế theo mô-đun và vô cùng linh hoạt, cho phép các chuyên gia bảo mật lựa chọn các chiến thuật và kỹ thuật phù hợp nhất với các nhu cầu thử nghiệm của người sử dụng. Ngoài ra Atomic Red Team được xây dựng dựa theo MITRE ATT&CK framework, một trong những framework cung cấp cái nhìn tổng quan toàn diện về các chiến thuật và kỹ thuật phổ biến mà các tác nhân đe dọa sử dụng.

## Installation

**Bước 1**: Tải máy ảo Windows tại đường [link](https://public-vms.s3.amazonaws.com/MSEdge.Win10.VMware.zip). Giải nén các tệp trong tệp **MSEdge.Win10.VMware.zip**.

**Bước 2**: Tải **Vmware Workstation Player** tại [link]([https://www.vm-ware.com/go/getplayer-win](https://download3.vmware.com/software/WKST-PLAYER-1750/VMware-player-full-17.5.0-22583795.exe)). Sau đó cài đặt theo  mặc định và khởi động ứng dụng.

**Bước 3**: Chọn **Create a New Virtual Machine** và chọn **MSEdge-Win10-VMware.ovf** từ thư mục đã giải nén.

![image](https://hackmd.io/_uploads/rJik_8OD6.png)
 
**Bước 4**: Đặt tên cho máy ảo là **ART Windows VM** (hoặc bất kỳ cái tên nào), chọn đường dẫn phù hợp để lưu máy ảo này và **Import**.

![image](https://hackmd.io/_uploads/HJxEdU_DT.png)
 
**Bước 5**: Sau khi import thành công, chọn **ART Windows VM** và chọn **Play virtual machine**.

![image](https://hackmd.io/_uploads/H1M8dIOwp.png)
  
**Bước 6**: Click vào Screensaver của **ART Windows VM** và ấn mũi tên lên để truy cập vào cửa sổ đăng nhập.

![image](https://hackmd.io/_uploads/BynhO8dP6.png)
 
User: **IEUser**
Password: **Passw0rd!**
Đăng nhập với thông tin được cung cấp bên trên.
**Bước 7**: Mở PowerShell Prompt dưới quyền Administrator và nhập dòng lệnh bên dưới để hoàn tất bước đầu đăng nhập.

![image](https://hackmd.io/_uploads/ByahMDOPp.png)

```powershell!
IEX (IWR "https://raw.githubusercontent.com/thuyhero2002/build-art-vm/main/setup.ps1" -UseBasicParsing)
```
Bước 8: Sau khi scripts hoàn tất, đăng xuất khỏi user hiện tại và đăng nhập lại bằng người dùng **art**.
 
![image](https://hackmd.io/_uploads/rypOMv_PT.png)

![image](https://hackmd.io/_uploads/S1hKzD_vT.png)

User: **art**
Password: **AtomicRedTeam1!**
Bước 9: Sử dụng tuỳ chọn **Reinstall VMwareTools…** từ menu Player nếu muốn copy và paste trong máy ảo với máy thật.

![image](https://hackmd.io/_uploads/BkNJWDdwT.png)

Bước 10: Sau khi đã chọn **Reinstall VmwareTools…** sẽ có có một ổ DVD như hình

![image](https://hackmd.io/_uploads/HkZgWPuv6.png)

Chuột phải vào ổ DVD Drive và chọn **Install or run program from your media**. Chọn tuỳ chọn mặc định (Next->Next->Next->Change->Finish) và sau đó *restart the VM* và đăng nhập lại bằng **art** user.

Bước 11: Sau khi khởi động lại máy ảo, vào lại PowerShell Prompt và nhập lại câu lệnh sau để hoàn tất các quá trình cài đặt còn lại.
```powershell!
IEX (IWR "https://raw.githubusercontent.com/thuyhero2002/build-art-vm/main/setup.ps1" -UseBasicParsing)
```

![image](https://hackmd.io/_uploads/HybBWP_wa.png)

Ấn **Y** để cài đặt **Atomic Red Team Framework and Folders**

![image](https://hackmd.io/_uploads/ryGPWvuPT.png)
 
Khởi động lại lần cuối để chắc chắn rằng tất cả các cài đặt đã hoàn tất.
Note: Máy ảo này đã được kích hoạt (thời gian sử dụng là 2 giờ mỗi lần) cho 90 ngày. Sử dụng lệnh `slmgr /dlv` trong Command Prompt dưới quyền Administrator. Hoặc có thể dùng lệnh `slmgr /rearm` để làm mới lại thành 90 ngày.

## Related

* [clr2of8 - dc8-deployment-PUBLIC](https://github.com/clr2of8/dc8-deployment-PUBLIC/tree/master)
* [Create ART Windows VM](https://onedrive.live.com/view.aspx?resid=5EFC811CDEC9D7F0%219464&authkey=!ANS0VIAhtxPdlN4)

## Feedback

If you have any feedback, please reach out to us at phamdinhthuy2002@gmail.com

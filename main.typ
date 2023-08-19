#import "template.typ": *
#import "@preview/plotst:0.1.0": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  institutions: (
    text("Đại học Quốc gia Hà nội", weight: 800),
    text("Trường Đại học Khoa học Tự nhiên", weight: 800),
    "",
    "",
    "",
    "",
    "",
    "",
    text("Khoa Toán - Cơ - Tin học", weight: 800)
  ),
  title: "Báo cáo thực tập",
  subtitle: "Xây dựng API nhận diện\n chữ bằng Tesseract OCR",
  authors: (
    "Phạm Hoàng Hải",
  ),
  logo: "VNU-HUS.jpg"
)

#set text(11pt)



// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!


#align(
  center, text(24pt, bottom-edge: "baseline")[Lời cảm ơn]
)
Em xin cảm ơn các thầy cô khoa Toán - Cơ - Tin học đã tạo điều kiện cho em hoàn thành kỳ thực tập năm nay. Kỳ thực tập đã đem lại nhiều kinh nghiệm làm việc quý báu cho em, và sẽ là hành trang giúp em tiếp tục phát triển kỹ năng sau này.

Em xin cảm ơn anh Lê Huy Toàn, người hướng dẫn tại công ty FIS, đã chỉ dẫn em tận tình từ những bước đầu tiên, từ đó em mới có thể có đủ kiến thức để hoàn thành bài báo cáo này. Em xin chân thành cảm ơn.


#pagebreak()

= Giới thiệu công ty FIS

FPT Information System, hay FIS, là doanh nghiệp tích hợp hệ thống, cung cấp các giải pháp hàng đầu Việt Nam trong suốt quá trình hình thành và phát triển. Thành lập từ năm 1994, tính đến năm 2023 FIS đã có 3200 cán bộ, nhân viên có trình độ cao, sở hữu năng lực và trình độ công nghệ được công nhận bởi cả những đối tác trong và ngoài nước.

FIS là một công ty thành viên của Tập đoàn FPT - một tên tuổi dẫn đầu về Công nghệ thông tin - Viễn thông. Tập đoàn FPT có đội ngũ 40.000 nhân viên, với 290 trụ sở, văn phòng, chi nhánh tại 29 quốc gia và vùng lãnh thổ trên toàn cầu. FPT hoạt động chủ yếu trong công nghệ, viễn thông và giáo dục. Hợp thành bởi 8 công ty thành viên và 4 công ty liên kết, sự lớn mạnh của FPT chính là nền tảng vững chắc cho sự phát triển bền vững của FIS.

*Thông tin về đơn vị thực tập - FIS:*
#table(
  columns: (auto, auto),
  inset: 7pt,
  stroke: none,
  column-gutter: 20pt,
  [Tên đăng ký], [CÔNG TY TNHH HỆ THỐNG THÔNG TIN FPT],
  [Địa chỉ đăng ký], [Tầng 22 tòa nhà Keangnam Landmark 72 Tower, E6 Phạm Hùng, Hà Nội],
  [Điện thoại], [84 - 24 3562 6000 hoặc 84 - 24 7300 7373],
  [Tên người đại diện và chức vụ], [Ông Trần Đăng Hòa – Chủ tịch công ty #linebreak() Ông Nguyễn Hoàng Minh – Tổng Giám đốc],
  [Địa chỉ (Trụ sở chính)], [Tầng 22 tòa nhà Keangnam Landmark 72 Tower, E6 Phạm Hùng, Hà Nội],
  [FAX (Trụ sở chính)], [84 - 24 356 24 850],
  [Quy mô nhân sự], [3.200 (theo tháng 04/2023)],
  [Trang chủ URL], [#link("www.fpt-is.com")],
  [Năm thành lập], [1994],
  [Loại hình công ty], [Công ty trách nhiệm hữu hạn]
)

= Phân tích yêu cầu đề tài

== Lý do chọn đề tài

OCR (Optical Character Recognition) - tức nhận dạng ký tự quang học - là một ứng dụng tuy không mới, nhưng vẫn chứa đựng nhiều thách thức, ngay cả với trình độ phát triển của công nghệ AI hiện nay.

Cụ thể, tuy các công cụ nhận dạng các văn bản in đã đạt đến độ chính xác rất cao, nhưng vẫn còn một số hạn chế, chẳng hạn về bộ nhớ, về yêu cầu phần cứng, về tốc độ, giá thành, cũng như khả năng cung cấp các thông tin bổ sung, như vị trí chữ, phân đoạn, phân khoảng... Từ đó, nảy sinh nhu cầu xây dựng một API - tức một giao diện lập trình ứng dụng - làm trung gian giữa công cụ OCR với các ứng dụng khác, từ đó giúp cho việc phát triển các ứng dụng thực tế liên quan tới OCR được dễ tiếp cận hơn.

== Mục tiêu đề tài

Xây dựng một REST API có khả năng nhận diện chữ từ văn bản in, sao cho thỏa mãn các tiêu chí:
- Máy chủ: được cài đặt trên các máy tính trong một mạng máy tính, các máy tính giao tiếp thông qua giao thức HTTP.
- Xử lý song song: phải có khả năng xử lý song song để đạt tốc độ cao hơn so với xử lý tuần tự thông thường, tận dụng triệt để khả năng của cụm máy tính.
- Dễ triển khai và mở rộng: làm sao để có thể thêm/bớt máy chủ mà chỉ cần chỉnh file cấu hình.

= Giới thiệu về OCR

== Tổng quan

OCR (Optical Character Recognition) - hay Nhận diện ký tự quang học, là một lĩnh vực nghiên cứu trong nhận dạng mẫu và thị giác máy tính. Một phần mềm OCR có đầu vào là một ảnh, và đầu ra là các chữ xuất hiện trong ảnh dưới dạng xâu ký tự (`String`). OCR được ứng dụng rộng rãi trong nhiều lĩnh vực, phổ biến nhất là nhập liệu tự động (hóa đơn, danh thiếp, hộ chiếu, biển số xe...) và chuyển các văn bản giấy được scan về dạng xâu ký tự.

Ở trong bài báo cáo này, chúng ta sẽ chủ yếu tập trung vào ứng dụng nhận diện chữ trên văn bản giấy đã được scan.


== Kiến trúc

Các phần mềm OCR nhìn chung đều có 3 bước chính:
- *Bước 1:* Nhận diện kiểu chữ, hướng chữ; Phát hiện chữ
- *Bước 2:* Nhận diện chữ
- *Bước 3:* _(không bắt buộc)_ Kiểm tra chính tả

=== Phát hiện chữ, tìm kiểu chữ và hướng chữ

Đầu tiên, phần mềm OCR thử phát hiện vị trí của từng ký tự (hoặc từng từ), vẽ hình chữ nhật nhỏ nhất bao quanh ký tự, rồi cắt từng hình chữ nhật ra khỏi ảnh để thu được một ảnh con chỉ bao gồm ký tự đó.

#figure(
  image(
    "figures/Capture.PNG",
    fit: "contain",
    height: 40%
  ),
  caption: "Chữ được phát hiện"
) <chu_phat_hien>

Phần mềm sau đó sẽ chạy mô hình phát hiện kiểu chữ đối với các ký tự (chẳng hạn chữ Latin, chữ Hán, chữ Hàn,...), từ đó chọn mô hình nhận diện chữ và bảng chữ cái sử dụng trong bước tiếp theo.

Một số phần mềm OCR có thể phát hiện ra độ xoay của văn bản, và sẽ xoay lại văn bản cho thẳng hàng.

=== Nhận diện chữ

Hàm nhận diện chữ lấy đầu vào là ảnh ký tự (hoặc từ) đã được cắt, và đầu ra là ký tự mà mô hình đọc được.

Hàm nhận diện chữ sử dụng các mô hình deep learning, thường là các mạng neuron tích chập (convolutional neural network).

#figure(
  image(
    "figures/predicted1.jpg",
    fit: "contain",
  ),
  caption: "Chữ được nhận diện"
)

Đây là bước quan trọng nhất của quá trình OCR, và chất lượng của ảnh tại bước này sẽ mang tính quyết định tới chất lượng của đầu ra.

=== Kiểm tra chính tả <chinhta>

Đối với một số ứng dụng của OCR, đôi lúc do việc cắt ảnh, chất lượng ảnh, độ sáng/tối,... mà ảnh đầu ra sẽ bị sai lệch ở nhiều điểm nhỏ. Chẳng hạn đối với tiếng Việt, một số phông chữ có dấu sắc, dấu hỏi, dấu huyền rất giống nhau, khó phân biệt nếu ảnh không đủ độ phân giải.

#figure(
  grid(
    image(
      "figures/baotangtinh.PNG",
    ),
    image(
      "figures/baotangtinh2.PNG"
    )  
  ),
  caption: "Ảnh thực tế (trên) so với kết quả đọc được (dưới)"
)

Như ở trên, dấu huyền trông rất giống dấu hỏi, nên phần mềm OCR đã xảy ra nhầm lẫn.

Vì vậy, một số phần mềm OCR tích hợp công cụ kiểm tra chính tả, hoặc các mô hình ngôn ngữ tự nhiên để đem lại độ chính xác cao hơn.

= Xây dựng API nhận diện chữ

== Các công nghệ chính được sử dụng

=== Giới thiệu về Spring Boot
Spring Boot là một thư viện mã nguồn mở cung cấp các công cụ hỗ trợ để người dùng xây dựng các ứng dụng Java một cách nhanh gọn.

Spring Boot là một thành phần của hệ sinh thái Spring framework, và có thể tương tác với các module khác của Spring, chẳng hạn Spring Data, Spring Web, Spring Security,... giúp người lập trình không phải tương tác trực tiếp với các API bậc thấp, làm cho việc phát triển ứng dụng trở nên dễ dàng.

Một trong những tính năng nổi bật nhất của Spring Boot là các `@Annotations`, giúp người lập trình cài đặt các cấu hình đa dạng chỉ với vài dòng lệnh cơ bản.

*Ưu điểm:*
- Có thể xuất ra file `.jar`, chạy được trên mọi máy tính có phiên bản Java phù hợp.
- Cấu hình tự động mỗi khi có thể, tiết kiệm thời gian lập trình.
- Cung cấp rất nhiều plugin.
- Có thể sử dụng các đối tượng Java cơ bản.
- Cài đặt cấu hình nhanh chóng với các `@Annotation`.
- Có thể cài đặt xử lý đa luồng, giúp tăng tốc độ xử lý
- Mã nguồn mở.
- Miễn phí.


=== Giới thiệu về Tesseract
Tesseract OCR là một phần mềm OCR mã nguồn mở, được phát hành trên giấy phép Apache 2.0, cho phép người dùng có thể sử dụng, chỉnh sửa, và bán sản phẩm phái sinh từ mã nguồn.

Tesseract ban đầu được phát triển bởi Hewlett-Packard, sau đó trở thành phần mềm mã nguồn mở và được tài trợ phát triển bởi Google vào năm 2005. Hiện nay, Tesseract được cho là một trong những công cụ OCR chính xác nhất trên thị trường. Mặc dù là phần mềm mã nguồn mở, Tesseract đạt độ chính xác tương đương những phần mềm trả phí như Azure AI, ABBYY,...

Tesseract rất phù hợp với mục tiêu dự án, vì có thể được cài đặt trên Windows, Linux, MacOS, và hỗ trợ hơn 100 ngôn ngữ.

#figure(
  grid(
    columns: (auto, auto),
    [#image("figures/tesscli.PNG")],
    [#image("figures/vpcp_cropped.png", height: 220pt)]
  ),
  caption: "Giao diện dòng lệnh Tesseract (bên trái) chứa kết quả đọc từ ảnh (bên phải)"
)

*Ưu điểm:*
- Hỗ trợ nhiều ngôn ngữ.
- Cài đặt được trên nhiều hệ điều hành.
- Tốc độ tương đối nhanh.
- Là một trong những phần mềm OCR chính xác nhất hiện nay.
- Dùng được qua ứng dụng dòng lệnh (Tesseract), hoặc API C/C++ (Libtesseract).
- Có các thư viện wrapper cho cả ứng dụng dòng lệnh (pytesseract, tess4j); và cả API C/C++ (tesserocr, module Tesseract thuộc JavaCPP)
- Mã nguồn mở
- Miễn phí

*Nhược điểm:*
- Không xử lý được file PDF.
- Không có chức năng chạy online.
- Cần phải biết trước ngôn ngữ của ảnh cần đọc.
- Không có xử lý đa luồng, mọi bước đều tuần tự.
- Tài liệu của API không được ghi chi tiết, hầu như phải đọc trực tiếp mã nguồn C/C++.
- Nếu muốn cài phiên bản mới nhất thì phải tự biên dịch mã nguồn.
- Không có chức năng kiểm tra chính tả.

=== Giới thiệu về Leptonica
Leptonica là một thư viện mã nguồn mở về xử lý và phân tích ảnh trong C/C++, cung cấp các cấu trúc dữ liệu cơ bản nhưng đi cùng rất nhiều phép toán và hàm biến đổi được dùng trong xử lý ảnh. Leptonica là thư viện nền tảng được sử dụng trong cả Tesseract và OpenCV - 2 thư viện nổi bật trong các ứng dụng OCR.

*Ưu điểm:*
- Cung cấp nhiều phép toán và hàm biến đổi đa dạng.
- Các cấu trúc dữ liệu đơn giản.
- Các hàm đọc và xuất file sử dụng dễ dàng.
- Mã nguồn mở
- Miễn phí

*Nhược điểm:*
- Không sử dụng biến tham chiếu tới đối tượng, mà dùng con trỏ tới địa chỉ bộ nhớ, nên khó kết hợp với ứng dụng Java. Điều này được phần nào giải quyết nếu dùng JavaCPP.

=== Giới thiệu về JavaCPP
Đối với Java, những người phát triển JavaCPP xem thư viện này như là cầu nối tới C++ giống như C++ là cầu nối tới Assembly. Thay vì sáng tạo ra các cú pháp mới, các chức năng của C++ trở thành các lớp, các hàm, các biến trong Java.

Tuy nhiên, code JavaCPP vẫn được đưa về code C++, nên cách viết code cũng phải giống như viết C++.

Thư viện JavaCPP nắm vai trò rất quan trọng trong dự án. Các thư viện dùng để tương tác với Tesseract hầu hết đều có điểm yếu lớn: Cả Pytesseract và Tess4j đều chỉ là wrapper cho giao diện dòng lệnh (Tesseract CLI), nhưng Tesseract CLI gộp 2 hàm phát hiện chữ và nhận diện chữ về 1 lệnh. Khi đó thì chỉ có thể truyền từng trang một vào xử lý, nên chỉ xử lý song song được theo trang. Với những tài liệu lớn nhưng ít trang thì thường không chia đều công việc được cho các máy chủ.

#figure(
  image(
    "figures/tesscli_parallel.PNG",
    height: 200pt
  ),
  caption: "Ví dụ: Nếu gộp bước phát hiện và nhận diện",
)

Ngược lại, thư viện JavaCPP có thể tương tác với API C/C++ của Tesseract (còn gọi là Libtesseract). Khi đó, quá trình OCR có thể chia thành 2 bước rõ ràng (phát hiện chữ #sym.arrow nhận diện chữ), nên ta có thể phát hiện chữ trước, rồi chia đều thành từng đoạn để gửi song song đến các máy chủ chạy Tesseract, giúp chia đều khối lượng công việc hơn cho các máy chủ. Cách tiếp cận này được áp dụng với hy vọng làm tăng tốc độ xử lý cho API, và giúp API chịu tải tốt hơn.

#figure(
  image(
    "figures/tessapi_parallel.PNG",
    height: 250pt
  ),
  caption: "Ví dụ: Nếu tách rời bước phát hiện và nhận diện",
)

*Ưu điểm:*
- Giúp việc tương tác với các API C/C++ trở nên dễ dàng hơn.
- Hỗ trợ cả Tesseract và Leptonica, cùng với rất nhiều thư viện C/C++ khác.
- Cú pháp như Java, người lập trình Java không phải học cú pháp mới.
- Có thể dùng cùng với hệ sinh thái Spring.

*Nhược điểm:*
- Quản lý bộ nhớ thủ công như trong C/C++, nếu không cẩn thận dễ gây rò bộ nhớ.
- Tài liệu API không được ghi chi tiết, hầu như phải đọc mã nguồn Java và cả C/C++.
- Một số hàm không tạo ra `exception` khi lỗi, nên không thể xử lý `exception`, gây dừng ứng dụng (đặc biệt là lỗi truy cập bộ nhớ - `segmentation fault`).
- Tuy cú pháp như Java, nhưng cách code vẫn phải giống C/C++.

#pagebreak()

== Kiến trúc phần mềm
Phần mềm được chia thành 3 module, mỗi module có 1 REST API.

#figure(
  image("figures/kientrucphanmem.png"),
  caption: "Kiến trúc phần mềm"
)

Trong đó mỗi module có công dụng:
- `PDF Image Extract`: Tách file PDF thành một mảng các trang (dưới dạng ảnh), sau đó gửi đến các API tiếp theo bằng 1 trong 3 cách.
- `Tesseract Paragraph Extract`: Tách ảnh trang giấy thành một mảng chứa các đoạn văn trong trang (dưới dạng ảnh), mỗi đoạn văn được đưa vào một luồng xử lý và gửi song song đến REST API của `Tesseract Reader`
- `Tesseract Reader`: Dùng Tesseract đọc chữ từ ảnh, trả về kết quả

API có thể xử lý PDF với theo 3 cách:
- Xử lý tuần tự: Gửi tuần tự từng trang đến `Tesseract Reader`
- Song song theo đoạn: Gửi song song từng trang đến `Tesseract Paragraph Extract`, `Tesseract Paragraph Extract` sau đó sẽ gửi từng trang đến `Tesseract Reader`
- Song song theo trang: Gửi song song từng trang đến `Tesseract Reader`

Để xử lý song song, ta cũng có thể chạy nhiều module `Tesseract Paragraph Extract` và `Tesseract Reader` trên nhiều máy tính khác nhau:

#figure(
  image("figures/kientruc2.png"),
  caption: "Ví dụ: Cách 2 khi chạy nhiều module"
)

=== Module 1: Pdf Image Extract - Tách ảnh từ PDF
Module đọc file PDF và tách ra thành một mảng các file ảnh, mỗi ảnh là một trang giấy trong tài liệu.


*Cấu trúc file*
- #text(`tess.pdf.image.extract`, fill: orange, weight: "bold")
  - #text(`PdfImageExtract.java`, fill: eastern, weight: "bold")
  - #text(`tess.pdf.image.extract.config`, fill: orange, weight: "bold")
    - #text(`PdfImageExtractConfig.java`, fill: eastern, weight: "bold")
  - #text(`tess.pdf.image.extract.controller`, fill: orange, weight: "bold")
    - #text(`PdfImageExtractController.java`, fill: eastern, weight: "bold")
  - #text(`tess.pdf.image.extract.runner`, fill: orange, weight: "bold")
    - #text(`ParaExtractThreadRunner.java`, fill: eastern, weight: "bold")
    - #text(`TessApiThreadRunner.java`, fill: eastern, weight: "bold")
  - #text(`tess.pdf.image.extract.service`, fill: orange, weight: "bold")
    - #text(`ImageExtractor.java`, fill: eastern, weight: "bold")
    - #text(`ParaExtractAsyncRequest.java`, fill: eastern, weight: "bold")
    - #text(`RequestSender.java`, fill: eastern, weight: "bold")
    - #text(`TessApiAsyncRequest.java`, fill: eastern, weight: "bold")

==== Bước 1: Tách ảnh khỏi PDF
Sử dụng thư viện PDFBox để tìm kiếm đệ quy các ảnh trong PDF.

#figure(
  image("figures/pdfstep1.PNG"),
  caption: "Quy trình bước 1"
)

*Các lớp chính:*
- `PdfImageExtractController`: Là dạng `@RestController` để nhận file người dùng tải lên.
- `ImageExtractor`: Dùng để tách ảnh khỏi PDF bằng tìm kiếm đệ quy

`ImageExtractor` chuyển dữ liệu `byte[]` của file thành kiểu `PDDocument`, rồi lấy các `PDResources` tương ứng với mỗi trang và tìm kiếm đệ quy các ảnh trong `PDResources`


==== Bước 2: Gửi ảnh tới module tiếp theo

*Các lớp chính*
- `ParaExtractAsyncRequest`: khởi tạo các luồng để gửi ảnh đến `Tesseract Paragraph Extract`.
- `TessApiAsyncRequest`: khởi tạo các luồng để gửi ảnh đến `Tesseract Reader`
- `ParaExtractThreadRunner` và `TessApiThreadRunner`: kế thừa interface `Runner`, dùng để chạy luồng gửi ảnh. Mỗi luồng trỏ tới một đối tượng `RequestSender` riêng và gửi ảnh bằng hàm của `RequestSender`.
- `RequestSender`:  `@Service` để gửi ảnh đến module tiếp theo.

`RequestSender` sẽ gửi file dưới dạng Multipart Form data.

*Cách 1: Gửi tuần tự từng trang:*

Các file được lần lượt gửi trang đó cho `Tesseract Reader`. Sau khi kết quả trang trước được trả về thì trang sau mới được gửi.

#figure(
  image("figures/pdfimage_pdf.png", height: 160pt),
  caption: "Cách 1: Xử lý tuần tự"
)

Các ảnh được gửi lần lượt, ảnh trước có kết quả thì ảnh sau mới được gửi.

```java
        ArrayList<String> responses = new ArrayList<>();
        for (File image : images) {
            responses.add(requestSender.sendImageToTessApi(image));
        }

        return responses.toString();
```


*Cách 2: Gửi song song từng đoạn đến `Tesseract Paragraph Extract`*

Khởi tạo các luồng xử lý (`Thread`) và gửi song song ảnh tới module tiếp theo.

#figure(
  image("figures/pdfstep2.PNG"),
  caption: "Cách 2: Song song theo đoạn"
)

*Cách 3: Gửi song song từng trang đến `Tesseract Reader`*

Khởi tạo các luồng xử lý (`Thread`) và gửi song song ảnh tới module tiếp theo.

#figure(
  image("figures/pdfimage_async.png"),
  caption: "Cách 3: Song song theo trang"
)


Hàm gửi file đến API khác sử dụng thư viện OkHttp3, vì cho phép gọi hàm gửi file mà chỉ cần biến tham chiếu đến file, từ đó tránh mâu thuẫn về định dạng ảnh, dễ dàng gửi file dạng Multipart.

```java
    /**
     * Gửi ảnh tới Tesseract Paragraph Extract
     * @param file
     * @return
     * @throws FileNotFoundException
     * @throws IOException 
     */
    public String sendImageToParagraphExtractor(File file) throws FileNotFoundException, IOException {
        OkHttpClient client = new OkHttpClient().newBuilder()
                .build();
        MediaType mediaType = MediaType.parse("text/plain");
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
                .addFormDataPart("params", "asdf")
                .addFormDataPart("image", "pic_1.png",
                        RequestBody.create(MediaType.parse("application/octet-stream"),
                                file))
                .build();
        Request request = new Request.Builder()
                .url(PARA_EXTRACT_SERVER)
                .method("POST", body)
                .addHeader("PageSegMode", "3")
                .addHeader("Language", "vie")
                .build();
        Response response = client.newCall(request).execute();

        String result = response.body().string();
        LOGGER.info(result);
        return result;
    }
}
```


#pagebreak()
=== Module 2: Tesseract Paragraph Extract - Tách đoạn văn từ trang
Module đọc ảnh một trang giấy, và tách ra thành một mảng các file ảnh, mỗi ảnh là một đoạn văn được cắt ra khỏi trang giấy.

*Cấu trúc file:*
- #text(`tess.tesseract.paragraph.extract`, fill: orange, weight: "bold")
  - #text(`TesseractParagraphExtract.java`, fill: eastern, weight: "bold")
  - #text(`tess.tesseract.paragraph.extract.controller`, fill: orange, weight: "bold")
    - #text(`ParagraphExtractController.java`, fill: eastern, weight: "bold")
  - #text(`tess.tesseract.paragraph.extract.runner`, fill: orange, weight: "bold")
    - #text(`TessApiThreadRunner.java`, fill: eastern, weight: "bold")
  - #text(`tess.tesseract.paragraph.extract.service`, fill: orange, weight: "bold")
    - #text(`ParagraphExtractor.java`, fill: eastern, weight: "bold")
    - #text(`RequestSender.java`, fill: eastern, weight: "bold")
    - #text(`TessApiAsyncRequest.java`, fill: eastern, weight: "bold")


==== Bước 1: Tách đoạn văn từ ảnh
Dùng Tesseract API thông qua JavaCPP để phát hiện các đoạn văn từ ảnh. Sau đó cắt các ảnh ra và lưu vào file tạm.

#figure(
  image("figures/parastep1.PNG"),
  caption: "Quy trình bước 1"
)

*Các lớp chính:*
- `ParagraphExtractController`: dạng `@RestController`, nhận file ảnh 1 trang giấy mà module `Pdf Image Extract` gửi đến, và truyền vào `ParagraphExtractor`.
- `ParagraphExtractor`: dạng `@Service`, chạy mô hình phát hiện chữ của Tesseract, phát hiện các đoạn văn, cắt ảnh đoạn văn ra.

Hàm tách đoạn văn sử dụng API của Tesseract thông qua lớp `TessBaseAPI` của JavaCPP.

#pagebreak()

```java
    /**
     * Tách ảnh đoạn văn ra khỏi ảnh gốc
     * 
     * @param image: ảnh gốc
     * @return ArrayList<PIX>: các ảnh đoạn văn đã tách
     */
    public ArrayList<PIX> extract(PIX image) {
        Random rand = new Random(12345);
        TessBaseAPI tessApi = new TessBaseAPI();
        tessApi.Init(null, "vie");
        tessApi.SetPageSegMode(tesseract.PSM_AUTO);
        tessApi.SetImage(image);

        BOXA boxes = tessApi.GetRegions((PIXA) null);

        ArrayList<PIX> result = new ArrayList<>();

        for (int i = 0; i < leptonica.boxaGetValidCount(boxes); i++) {
            //L_COPY=1, truyền con trỏ tới bản sao thay vì đến object gốc
            BOX box = leptonica.boxaGetValidBox(boxes, i, leptonica.L_COPY); 
            
            PIX pic = leptonica.pixClipRectangle(image, box, (BOX) null);
            leptonica.pixWritePng("imagedump/test" + Long.toString(rand.nextLong()) + ".png", pic, 0);
            result.add(pic);
        }

        return result;
    }
```

Sau khi tách ảnh, Tesseract trả về tham chiếu tới ảnh ở dạng `PIX`. Đây ngầm là dạng con trỏ của con trỏ bộ nhớ (`PointerPointer` trong JavaCPP, `long**` trong C++), nên ảnh phải được đọc vào file tạm rồi mới có thể gửi đi.

```java
    /**
     * Chuyển ảnh từ dạng PIX về File
     * @param pix ảnh
     * @return File ảnh
     * @throws IOException 
     */
    public File pixToFile(PIX pix) throws IOException {
        UUID uuid = UUID.randomUUID();
        String tempName = "temp" + uuid.toString() + ".png";
        leptonica.pixWritePng(tempName, pix, 0);
        
        File file = new File(tempName);
        file.deleteOnExit();        
        return file;
    }
```

==== Bước 2: Gửi song song ảnh đến Tesseract Reader
Hoàn toàn tương tự bước 2 của module `Pdf Image Extract`, nhưng gửi ảnh đến `Tesseract Reader`

#figure(
  image("figures/parastep2.png"),
  caption: "Quy trình bước 2"
)

*Các lớp chính:*
- `TessApiAsyncRequest`: Dạng `@Service`. Nhận một danh sách ảnh đoạn văn, rồi khởi tạo các luồng xử lý cho mỗi ảnh đoạn văn.
- `TessApiThreadRunner`: kế thừa interface `Runner`. Dùng để chạy luồng gửi ảnh. Mỗi luồng trỏ tới một đối tượng `RequestSender` riêng và gửi ảnh bằng hàm của `RequestSender`.
- `RequestSender`: gửi ảnh đến module tiếp theo.


=== Module 3: Tesseract Reader - Đọc chữ từ ảnh
Module đưa ảnh vào Tesseract để đọc chữ từ ảnh.

*Cấu trúc file:*
- #text(`tess.tesseractReader`, fill: orange, weight: "bold")
  - #text(`TesseractApi.java`, fill: eastern, weight: "bold")
  - #text(`tess.tesseractReader.config`, fill: orange, weight: "bold")
    - #text(`TessConfiguration.java`, fill: eastern, weight: "bold")
  - #text(`tess.tesseractReader.controller`, fill: orange, weight: "bold")
    - #text(`ReaderController.java`, fill: eastern, weight: "bold")
  - #text(`tess.tesseractReader.service`, fill: orange, weight: "bold")
    - #text(`TessReaderService.java`, fill: eastern, weight: "bold")

Module nhận đầu vào là một ảnh có chữ, và đầu ra là các chữ nhận diện được trên ảnh đó.

#figure(
  image("figures/tessreader.png"),
  caption: "Quy trình hoạt động của Tesseract Reader"
)

*Các lớp chính:*
- `ReaderController`: Dạng `@RestController`. Nhận file ảnh, chuyển thành dạng `PIX` của Leptonica, rồi truyền cho `TessReaderService`
- `TessReaderService`: Dạng `@Service`. Lấy đầu vào là ảnh đoạn văn và đầu ra là đoạn văn đọc được dưới dạng xâu ký tự (`String`)

Hàm đọc chữ sử dụng API Tesseract thông qua lớp `TessBaseAPI` của JavaCPP.

```java
    public String readPIXImage(PIX image, Map<String, String> params) {
        TessBaseAPI tessApi = new TessBaseAPI();
        String str_result = new String();
        
        setTesseractParameters(tessApi, params);
        tessApi.SetImage(image);
        
        // Đọc chữ từ ảnh, trả về con trỏ
        BytePointer result = tessApi.GetUTF8Text();
        if (result != null) {
            str_result = result.getString();
        }

        // Phải giải phóng bộ nhớ thủ công
        tessApi.End();
        if (result != null) {
            result.deallocate();
        }

        return str_result;
    }
```


== Chạy thử

=== Cài đặt trên server Linux
Để module `Tesseract Paragraph Extract` và `Tesseract Reader` có thể hoạt động, server cần phải cài sẵn Tesseract và Libtesseract. 
Chi tiết cách cài đặt đã được ghi trên trang web chính thức của Tesseract: #link("https://tesseract-ocr.github.io/tessdoc/#compiling-and-installation")

Để cài các module trên server, đầu tiên ta chỉnh mục `<build>` của file #text("pom.txt", fill: fuchsia) của mỗi module sao cho khi biên dịch ra file `.jar`, các thư viện cần dùng cũng sẽ được copy ra một thư mục 
riêng, để dễ dàng copy qua server Linux:

```xml
  <build>
      <plugins>
          <plugin>
              <artifactId>maven-dependency-plugin</artifactId>
              <executions>
                  <execution>
                      <phase>install</phase>
                      <goals>
                          <goal>copy-dependencies</goal>
                      </goals>
                      <configuration>
                          <outputDirectory>${project.build.directory}/lib</outputDirectory>
                      </configuration>
                  </execution>
              </executions>
          </plugin>
      </plugins>
      <finalName>${project.artifactId}-${project.version}</finalName>
      <directory>${compile.directory}/${project.artifactId}/target</directory>
      <resources>
          <resource>
              <directory>${project.basedir}/src/main/resources</directory>
          </resource>
      </resources>
  </build>
```

#figure(
  image(
    "figures/compile.png",
    height: 150pt
  ),
  caption: "Kết quả biên dịch có cả file .jar và thư mục lib"
)

Để cài đặt module trên server, ta copy file `.jar` và thư mục `lib` qua một thư mục riêng trên server.

#figure(
  image(
    "figures/image.png",
    width: 200pt
  ),
  caption: "Sau khi tải file lên server"
)

Để chạy module, cần dùng lệnh `java` trên dòng lệnh. Để nhanh và tiện, ta dùng file `.sh` để chạy lệnh. File `.sh` chạy bằng lệnh `./<tên file>.sh`.

Nếu không chạy được file `.sh`, dùng lệnh `chmod 755 *.sh` rồi chạy lại.

- *run.sh (để khởi động module)*
```shell-unix-generic
# Đặt biến môi trường
export JAVA_HOME="<thư mục chứa JDK 17>"
export PATH=$JAVA_HOME/bin:$PATH

# Chạy module, lưu đầu ra vào file nohup.out
cd <đường dẫn tới module>
rm nohup.out
# Lưu PID của tiến trình vào file pid.file, để tiện dừng module khi cần
nohup java -Xmx1024m -cp './<tên file jar>.jar:./lib/*' <package chứa main> & echo $! > ./pid.file
tail -f nohup.out
```

#v(20pt)

- *stop.sh (để dừng module)*
```shell-unix-generic
kill $(cat ./pid.file)
```

=== Chạy thử bằng Postman

Đầu tiên, ta tạo một collection trong Postman:

#image("figures/postmancollection.png", height: 120pt)

Bấm vào collection vừa tạo, chọn mục variables, nhập địa chỉ IP của các server chứa module `Pdf Image Extract`:

#image("figures/postmanvar.png")

Sau đó tạo request đến API.

#image("figures/addrequest.png", height: 200pt)

Khi đã có request, ta có thể nhấn vào request để chỉnh cấu hình.

#image("figures/postman.png")

REST API của `Pdf Image Extract` cho phép sử dụng 3 endpoints như sau:
#image("figures/endpoint1.png", height: 45pt)

#image("figures/endpoint2.png", height: 45pt)

#image("figures/endpoint3.png", height: 45pt)

Trong đó:
- `{{pdf_extract_host}}/pdfextract/pdf`: tách ảnh từ PDF, đọc tuần tự.
- `{{pdf_extract_host}}/pdfextract/pdf/async`: tách ảnh từ PDF, đọc song song theo trang.
- `{{pdf_extract_host}}/pdfextract/pdf/para`: tách ảnh từ PDF, đọc song song theo đoạn văn.

Các request đều chỉ chấp nhận body dạng Multipart Form data, với 2 tham số:
- `body`: dạng chữ (tạm thời chưa có công dụng, trong tương lai có thể phát triển để truyền các cấu hình vào).
- `file`: file PDF.

#image("figures/postmanbody.png")

Giờ ta có thể bấm nút Send để gửi request đến API.

#image("figures/postmansend.png")

Kết quả trả về sẽ được hiện thị như hình dưới.

#image("figures/postmanres.png")

#pagebreak()

= Nhận xét và đánh giá

== So sánh tốc độ

=== Phương pháp đánh giá
Ta sẽ so sánh tốc độ của API khi chạy trong 3 trường hợp:
- Tuần tự: Chờ OCR xong trang trước rồi mới OCR trang mới
- Song song theo trang: Tách PDF thành danh sách trang, rồi OCR song song các trang.
- Song song theo đoạn: Tách PDF thành danh sách trang, mỗi trang tách thành danh sách đoạn văn, rồi OCR song song các đoạn văn.

Văn bản sử dụng: Các văn bản chính phủ với độ dài tăng dần. 

Các văn bản được lấy từ: #link("https://vanban.chinhphu.vn/")

*Các bước thực hiện*

Đầu tiên, ta dùng Postman để gửi tài liệu đến API, và Postman sẽ bấm giờ từ lúc gửi đến lúc nhận kết quả trả về. Ta sẽ bỏ qua thời gian thiết lập kết nối HTTP và tải kết quả xuống, mà chỉ tính thời gian từ lúc gửi yêu cầu cho tới lúc yêu cầu hoàn tất, tức chỉ tính mục `Transfer start` dưới đây:

#figure(
  image(
    "figures/transferstart.PNG",
    height: 170pt
  ),
  caption: "Bảng tính giờ của Postman"
)

Mỗi tài liệu được gửi 5 lần và kết quả cuối cùng là thời gian xử lý trung bình.

API `Pdf Images Extract` chạy trên máy laptop (do thời gian xử lý không đáng kể so với việc chạy Tesseract), 2 API `Tesseract Paragraph Extract` và `Tesseract Reader` được chạy trên máy chủ đặt tại công ty FIS.

#pagebreak()

*Cấu hình máy chủ:*
#table(
  columns: (auto, auto, auto),
  inset: 6pt,
  stroke: none,
  column-gutter: 0pt,
  [Mẫu máy], [ProLiant DL380 Gen10], [],
  [Hệ điều hành], [GNU/Linux], [],
  [], [CentOS 7 / RHEL 7], [],
  [CPU], [Tên], [Intel(R) Xeon(R) Gold 5218 CPU #symbol("@") 2.30GHz],
  [], [MHz], [2797],
  [], [Max MHz], [3900],
  [], [Min MHz], [1000],
  [], [Số nhân], [16],
  [], [Số luồng], [32],
  [RAM], [251GB]
)


=== Tiến hành đánh giá

#let docnumber = 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/6/4771-kgvx.signed.pdf")
- Số trang: 1
- Kích cỡ: 134kb

#let avg(arr) = {
  let result = 0
  for value in arr {
    result += value
  }
  result /= arr.len()
  return result
}

#let time1 = (1.31, 1.26, 1.31, 1.32, 1.30)
#let time2 = (1.24, 1.21, 1.24, 1.59, 1.23)
#let time3 = (1.42, 1.06, 0.99, 1.06, 1.05)
#let avg1_1 = calc.round(avg(time1), digits: 2)
#let avg2_1 = calc.round(avg(time2), digits: 2)
#let avg3_1 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 1 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_1 giây
- Song song theo trang: #avg2_1 giây
- Song song theo đoạn: #avg3_1 giây

#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/6/4691-cn.signed.pdf")
- Số trang: 3
- Kích cỡ: 251kb

#let time1 = (5.64, 5.58, 5.46, 5.58, 5.05)
#let time2 = (2.04, 2.06, 2.01, 2.08, 2.05)
#let time3 = (2.36, 2.72, 2.35, 2.42, 3.61)
#let avg1_3 = calc.round(avg(time1), digits: 2)
#let avg2_3 = calc.round(avg(time2), digits: 2)
#let avg3_3 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 3 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_3 giây
- Song song theo trang: #avg2_3 giây
- Song song theo đoạn: #avg3_3 giây

#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/7/877-ttg.signed.pdf")
- Số trang: 6
- Kích cỡ: 317kb

#let time1 = (9.10, 8.92, 9.57, 11.56, 9.12)
#let time2 = (2.38, 2.22, 2.22, 2.40, 2.55)
#let time3 = (2.01, 2.02, 2.10, 2.13, 2.07)
#let avg1_6 = calc.round(avg(time1), digits: 2)
#let avg2_6 = calc.round(avg(time2), digits: 2)
#let avg3_6 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 6 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_6 giây
- Song song theo trang: #avg2_6 giây
- Song song theo đoạn: #avg3_6 giây


#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/7/14-bggdt.signed.pdf")
- Số trang: 9
- Kích cỡ: 443kb

#let time1 = (16.34, 19.71, 15.62, 14.67, 13.79)
#let time2 = (2.07, 2.10, 2.08, 2.08, 2.14)
#let time3 = (2.96, 2.73, 2.69, 2.62, 2.73)
#let avg1_9 = calc.round(avg(time1), digits: 2)
#let avg2_9 = calc.round(avg(time2), digits: 2)
#let avg3_9 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 9 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_9 giây
- Song song theo trang: #avg2_9 giây
- Song song theo đoạn: #avg3_9 giây

#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/7/47-hdp.signed.pdf")
- Số trang: 12
- Kích cỡ: 554kb

#let time1 = (18.55, 16.81, 17.27, 16.72, 16.58)
#let time2 = (2.45, 2.51, 2.46, 2.43, 2.38)
#let time3 = (2.29, 2.45, 2.37, 2.32, 2.34)
#let avg1_12 = calc.round(avg(time1), digits: 2)
#let avg2_12 = calc.round(avg(time2), digits: 2)
#let avg3_12 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 12 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_12  giây
- Song song theo trang: #avg2_12 giây
- Song song theo đoạn: #avg3_12 giây


#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/7/869-ttg.signed.pdf")
- Số trang: 13
- Kích cỡ: 502kb

#let time1 = (17.49, 16.37, 15.34, 15.61, 14.97)
#let time2 = (2.30, 2.28, 2.31, 2.28, 2.28)
#let time3 = (5.24, 5.66, 5.50, 4.84, 5.82)
#let avg1_13 = calc.round(avg(time1), digits: 2)
#let avg2_13 = calc.round(avg(time2), digits: 2)
#let avg3_13 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 13 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_13  giây
- Song song theo trang: #avg2_13 giây
- Song song theo đoạn: #avg3_13 giây


#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/7/105-nq.signed.pdf")
- Số trang: 16
- Kích cỡ: 891kb

#let time1 = (16.27, 15.17, 15.24, 15.04, 16.04)
#let time2 = (3.11, 3.11, 3.12, 3.05, 3.12)
#let time3 = (3.75, 3.76, 3.84, 3.77, 3.79)
#let avg1_16 = calc.round(avg(time1), digits: 2)
#let avg2_16 = calc.round(avg(time2), digits: 2)
#let avg3_16 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 16 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_16  giây
- Song song theo trang: #avg2_16 giây
- Song song theo đoạn: #avg3_16 giây


#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/7/50-btc.signed.pdf")
- Số trang: 20
- Kích cỡ: 797kb

#let time1 = (28.22, 29.09, 28.29, 28.22, 28.27)
#let time2 = (3.35, 3.19, 3.26, 3.25, 3.20)
#let time3 = (6.75, 7.24, 6.80, 6.83, 6.86)
#let avg1_20 = calc.round(avg(time1), digits: 2)
#let avg2_20 = calc.round(avg(time2), digits: 2)
#let avg3_20 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 20 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_20  giây
- Song song theo trang: #avg2_20 giây
- Song song theo đoạn: #avg3_20 giây


#let docnumber = docnumber + 1
*Tài liệu #docnumber*

- Nguồn: #link("https://datafiles.chinhphu.vn/cpp/files/vbpq/2023/7/891-bgtvt.signed.pdf")
- Số trang: 23
- Kích cỡ: 850kb

#let time1 = (29.91, 30.36, 30.62, 30.17, 29.21)
#let time2 = (3.45, 3.27, 3.36, 3.31, 3.29)
#let time3 = (9.14, 9.08, 8.43, 8.85, 8.89)
#let avg1_23 = calc.round(avg(time1), digits: 2)
#let avg2_23 = calc.round(avg(time2), digits: 2)
#let avg3_23 = calc.round(avg(time3), digits: 2)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    rows: (auto, auto), 
    [], [Tuần tự], [Song song theo trang], [Song song theo đoạn],
    [Lần 1], [#time1.at(0)], [#time2.at(0)], [#time3.at(0)],
    [Lần 2], [#time1.at(1)], [#time2.at(1)], [#time3.at(1)],
    [Lần 3], [#time1.at(2)], [#time2.at(2)], [#time3.at(2)],
    [Lần 4], [#time1.at(3)], [#time2.at(3)], [#time3.at(3)],
    [Lần 5], [#time1.at(4)], [#time2.at(4)], [#time3.at(4)],
  ),
  caption: "Thời gian xử lý văn bản 23 trang (tính bằng giây)"
)

Kết quả trung bình:
- Tuần tự: #avg1_23  giây
- Song song theo trang: #avg2_23 giây
- Song song theo đoạn: #avg3_23 giây


=== Kết luận
Ta vẽ lại tất cả các kết quả ở trên dưới dạng đồ thị.

Trục $y$ là thời gian xử lý (giây), trục $x$ là số trang của tài liệu:

// #let iterdata = (
//   (1, avg1_1), (3, avg1_3), (6, avg1_6), (9, avg1_9), (12, avg1_12), (13, avg1_13), (16, avg1_16), (20, avg1_20), (23, avg1_23)
// ) 
// #let pagedata = (
//   (1, avg2_1), (3, avg2_3), (6, avg2_6), (9, avg2_9), (12, avg2_12), (13, avg2_13),(16, avg2_16), (20, avg2_20), (23, avg2_23)
// )
// #let paradata = (
//   (1, avg3_1), (3, avg3_3), (6, avg3_6), (9, avg3_9), (12, avg3_12), (13, avg3_13),(16, avg3_16), (20, avg3_20), (23, avg3_23),
// )
// #let xaxis = axis(min: 0, max: 25, step: 2, location: "bottom")
// #let yaxis = axis(min: 0, max: 30, step: 2, location: "left")

// #let plot_iter = plot(data: iterdata, axes: (xaxis, yaxis))
// #let iter = graph_plot(plot_iter, (100%, 40%), stroke: red, rounding: 20%, caption: "Xử lý tuần tự (đỏ), song song theo trang (xanh lá cây), song song theo đoạn (xanh da trời)")
// #let plot_page = plot(data: pagedata, axes: (xaxis, yaxis))
// #let page = graph_plot(plot_page, (100%, 40%), rounding: 20%, stroke: green)
// #let plot_para = plot(data: paradata, axes: (xaxis, yaxis))
// #let para = graph_plot(plot_para, (100%, 40%), rounding: 20%, stroke: blue)
// #overlay((iter, para, page), (100%, 40%))

#figure(
  image("figures/timegraph.svg"),
  caption: "Thời gian của các cách xử lý"
)

Đầu tiên, rõ ràng việc xử lý song song đem lại kết quả vượt trội so với xử lý tuần tự, ngay cả với tài liệu ít trang.

Việc xử lý song song theo đoạn không đem lại hiệu quả tốt bằng xử lý song song theo trang. Với tài liệu ít trang, không có khác biệt đáng kể giữa 2 cách xử lý. Từ tài liệu 13 trang trở đi, thời gian chạy bắt đầu tăng dần.

Việc xử lý theo trang có tăng trưởng rất nhỏ khi số trang tăng dần. Thời gian chạy trung bình cho tài liệu 1 trang là #avg2_1 giây, tài liệu 23 trang là #avg2_23 giây. Đây là phương pháp phù hợp nhất cho ứng dụng hiện tại.


*Kết luận:* 

Phần mềm có tốc độ đủ tốt khi chạy trên server lớn. Phù hợp với việc tạo ứng dụng web. Phương pháp phù hợp nhất hiện tại là xử lý song song theo trang.

#pagebreak()

== Kiểm tra độ chính xác

=== Phương pháp đánh giá

Ta kiểm tra độ chính xác bằng cách viết một API tự sinh một tập ảnh có chữ, sau đó gửi ảnh đến API `Tesseract Reader`, chờ kết quả trả về, và so sánh kết quả với chữ trong ảnh gốc.

Ở phần này em chọn Python để dễ dàng xử lý ảnh và tạo biểu đồ thống kê.

Ta tính độ chính xác bằng khoảng cách Levenshtein. Khoảng cách Levenshtein của 2 xâu ký tự $a$, $b$ (với độ dài $|a|$, $|b|$) được định nghĩa bằng:

#figure(
  $ "lev"(a, b) = cases(
    |a| #h(110pt) "nếu" |b| = 0,
    |b| #h(111pt) "nếu" |a| = 0,
    "lev"("tail"(a), "tail"(b)) #h(35pt) "nếu" a[0] = b[0],
    1 + "min" cases(
      "lev"("tail"(a), b),
      "lev"(a, "tail"(b)),
      "lev"("tail"(a), "tail"(b)),
    ) #h(8pt) "Các trường hợp còn lại"
  ) $,
  caption: "Công thức tính khoảng cách Levenshtein."
) <levendist>
Trong đó:
- $x[i]$ là ký tự thứ $i$ của xâu $x$ ($i in NN$)
- $"tail"(x)$ là xâu ký tự bao gồm tất cả các phần tử của $x$ trừ phần tử đầu tiên ($"tail"(x) = x without x[0]$)

Khoảng cách Levenshtein giữa $a$ và $b$ bằng số hành động tối thiểu đối với $a$ (bao gồm cả xóa, thêm, đổi 1 ký tự) để cho $a[i] = b[i] quad forall i in [0, space.med"max"(a, b))$. Thuật toán tính nhanh khoảng cách Levenshtein được cung cấp trong thư viện `Diff Match Patch`.

Để tính tỉ lệ chính xác, ta lấy khoảng cách Levenshtein chia cho chiều dài xâu ký tự, cụ thể:

Với xâu cần kiểm tra $a$ và xâu đáp án $b$, tỉ lệ chính xác của xâu $a$ ta định nghĩa bằng:

#figure(
  $
    "acc"(a, b) = "lev"(a, b) / |b| dot 100 percent
  $,
  caption: "Công thức tính độ chính xác."
) <levenacc>

*Các thư viện chính sử dụng:*
- `OpenCV` và `Pillow`: Thư viện xử lý ảnh. Dùng để chuyển định dạng, tạo ảnh, chuyển ảnh về `byte` để truyền qua HTTP.
- `Skimage`: Xoay ảnh.
- `FastAPI`: Thư viện xây dựng API, giúp dựng các API nhanh chóng và không phải cấu hình nhiều.
- `Uvicorn`: Thư viện chạy web server cho API.
- `Httpx`: Thư viện gửi yêu cầu HTTP.
- `Diff Match Patch`: Thư viện so sánh xâu ký tự của Google, dùng để so sánh kết quả trả về với chữ trong ảnh ban đầu.

#pagebreak()

*Cấu trúc file:*
- #text(`ocr_tester`, fill: orange, weight: "bold")
  - #text(`backgrounds`, fill: orange, weight: "bold")
    - #text(`background.png`, fill: fuchsia, weight: "bold")
  - #text(`custom_font`, fill: orange, weight: "bold")
    - #text(`arial.ttf`, fill: fuchsia, weight: "bold")
  - #text(`generated_test`, fill: orange, weight: "bold")
  - #text(`request_handler.py`, fill: eastern, weight: "bold")
  - #text(`tesseract_tester.py`, fill: eastern, weight: "bold")
  - #text(`testgen.py`, fill: eastern, weight: "bold")
  - #text(`words.txt`, fill: fuchsia, weight: "bold")

*Mô tả*
- `request_handler.py`: Lớp gửi yêu cầu HTTP
- `tesseract_tester.py`: Module chính. Chạy `FastAPI`, truyền file đến `request_handler`, chờ kết quả trả về và kiểm tra kết quả.
- `testgen.py`: Tự sinh chữ, và tạo ảnh có chữ đó.

=== Tiến hành đánh giá

==== Tạo ảnh để kiểm tra

===== Tạo chữ:

Ta tạo đoạn văn bằng cách chọn ngẫu nhiên các từ trong từ điển Wiktionary.

Từ điển Wiktionary được lấy từ link:

#link("https://github.com/undertheseanlp/resources/tree/master/resources/DI_Vietnamese-UVD/corpus")

Khi tải từ điển xuống sẽ có dạng: `{"text": "<từ>", "source": "<từ điển>"}`

Ta dùng chức năng `Replace All` của Notepad++, bấm `Ctrl + F`, vào mục `Replace`,  nhập `{"text": "` vào ô `Find what`, để trống ô `Replace with`, và bấm `Replace All`. Phần chữ đứng trước từ sẽ bị xóa.

Sau đó làm tương tự với `", "source": "wiktionary"}`, phần chữ đứng sau từ bị xóa.

#figure(
  table(columns: (auto, auto),
  [```
{"text": "1", "source": "wiktionary"}
{"text": "2G", "source": "wiktionary"}
{"text": "a", "source": "wiktionary"}
{"text": "A", "source": "wiktionary"}
{"text": "à", "source": "wiktionary"}
{"text": "ả", "source": "wiktionary"}
{"text": "á", "source": "wiktionary"}
{"text": "Á", "source": "wiktionary"}
{"text": "ạ", "source": "wiktionary"}
{"text": "a bá hợi", "source": "wiktionary"}
{"text": "á bí tích", "source": "wiktionary"}
```],
  [```
1
2G
a
A
à
ả
á
Á
ạ
a bá hợi
á bí tích
```]),
  caption: "Trước và sau khi dùng Replace All"
)

Khi đã có từ điển như trên, có thể đưa vào `list` trong Python:

```py
#Mở file từ điển và đưa vào dict_arr
dictfile = "ocr_tester/words.txt"
dict_arr = []
with open(dictfile, encoding="UTF-8") as df:
    for line in df:
        dict_arr.append(line[:-1])
```

Để sinh văn bản ngẫu nhiên, ta lấy ngẫu nhiên các từ trong `list` ở trên.

```py
def get_rand_word():
    """
    Lấy từ ngẫu nhiên trong từ điển
    """
    return dict_arr[rd.randint(0, len(dict_arr) - 1)]

def get_rand_str(max_size=50):
    """
    Lấy string ngẫu nhiên thỏa mãn độ dài
    """
    ret = ""
    while True:
        word = get_rand_word()
        if len(ret) + len(word) + 1 > max_size:
            return ret[:-1]
        else:
            ret = ret + get_rand_word() + " "
```

===== Tạo ảnh

Quy trình tạo ảnh như sau:

*Bước 1: Tải ảnh nền.*

Đầu tiên, tạo một ảnh trắng ở thư mục `backgrounds`. Ảnh này sẽ được dùng làm nền cho chữ.

Vì mục tiêu chính của dự án là nhận diện chữ in, nên ta dùng nền trắng.

#figure(
  image("figures/background.png", height: 140pt),
  caption: "Ảnh nền"
)

*Bước 2: Tạo chữ, chia thành từng dòng.*

Ghép ngẫu nhiên các từ trong từ điển thành một xâu ký tự, sao cho độ dài không vượt quá một số cố định.
Sau đó cho các xâu đó vào danh sách, để khi xếp mỗi phần tử trên danh sách theo chiều dọc thì sẽ thành đoạn văn.

#figure(
  table(
    ```
    nam thương Sóc Trăng thiên nhiên khống chế
    tìm thấy phăng pha nhổ giò sa hãm giá dụ
    giáo thụ đồ nghề ximôkinh mất máu phải mặt nón gò găng
    phòng ngừa Thanh Tường đường chim phát tang
    ```
  ),
  caption: "Một số xâu ký tự ngẫu nhiên"
)


*Bước 3: Tạo ảnh dòng chữ.*

Dùng thư viện `PIL.ImageDraw` để tạo ảnh chứa mỗi dòng chữ.

#figure(
  image("figures/namthuong.png", width: 300pt),
  caption: "Ảnh tạo từ ImageDraw"
)


*Bước 4: Ghép ảnh chữ vào ảnh nền.*

Ghép các ảnh dòng chữ vào ảnh nền, sao cho các ảnh tạm được sắp xếp thẳng hàng theo chiều dọc để thành đoạn văn, và chữ không bị tràn ra khỏi ảnh.

#figure(
  table(
    image(
    "figures/odf.png",
    height: 215pt,
    ),
  ),
  caption: "Ảnh nền sau khi được dán thêm các ảnh tạm"
)


*Bước 5: Xoay nhẹ ảnh.*

Xoay $plus.minus 0.01 "radian"$ cho giống với sai lệch của văn bản scan thông thường.

#figure(
  table(
  image(
    "figures/rotate.png",
    height: 215pt
  )),
  caption: "Ảnh sau khi được xoay nhẹ"
)

Việc xoay ảnh sử dụng ma trận xoay trong hệ tọa độ thuần nhất, thông qua module `transform` của thư viện `skimage`.

#pagebreak()

==== OCR và kiểm tra kết quả

Ta gửi liên tiếp 50 ảnh được tạo tự động cho `Tesseract Reader`, lấy kết quả trả về của mỗi ảnh, so sánh với xâu gốc, và tính độ chính xác trung bình.

#let acc_result = csv("csv/result.csv")
#let acc_1st = acc_result.slice(0, 25)
#let acc_2nd = acc_result.slice(25, 50)
#figure(
  grid(
    columns: (auto, auto),
    table(
      columns: (auto, auto, auto, auto),
      [Stt], [$"lev"(a, b)$], [$|b|$], [acc$(a)$],
      ..acc_1st.flatten()
    ),
    table(
      columns: (auto, auto, auto, auto),
      [Stt], [$"lev"(a, b)$], [$|b|$], [acc$(a)$],
      ..acc_2nd.flatten()
    ),
    column-gutter: 20pt
  ),
  caption: "Kết quả chạy OCR trên 50 ảnh ngẫu nhiên"
)

Trong đó:
- a: Xâu kết quả trả về của Tesseract
- b: Xâu gốc trong ảnh
- lev(a, b): Khoảng cách Levenshtein giữa 2 xâu a và b, tính theo công thức ở @levendist
- |b|: Độ dài xâu b
- acc(a, b): Độ chính xác của xâu a (dạng %), tính theo công thức ở @levenacc

#let tess_accuracy = 95.38017574591704

*Độ chính xác trung bình:* #calc.round(tess_accuracy, digits: 2)%
- Số lần nhầm chữ: 588
- Số lần thừa chữ: 1258
- Số lần thiếu chữ: 47

*Phân bố độ chính xác:*
#figure(
  image("figures/tess_accuracy.png", height: 270pt),
  caption: "Phân bố độ chính xác của Tesseract", 
)

*Các lỗi phổ biến:*
#figure(
  image("figures/error_histogram.png", height: 270pt),
  caption: "Các chữ nhiều lỗi trong 50 lần chạy"
) <err_histogram>

=== Kết luận

#let newline_count = 683
#let total_errors = 588 + 1258 + 47
#let newline_percentage = calc.round((newline_count * 100 / total_errors), digits: 2)

#let total_chars = 0
#for entry in acc_result {
  total_chars += int(entry.at(2))
}
#let adjusted_acc = 100 - (100 * (total_errors - newline_count) / total_chars)

Trong 50 lần chạy, Tesseract hầu như đều đạt độ chính xác cao. Trong đó 38/50 lần chạy đạt độ chính xác trên 95%.  

Lỗi phổ biến nhất là lỗi về dấu xuống dòng (newline trong @err_histogram), chiếm #newline_count trên tổng số #total_errors lỗi (#newline_percentage%), tuy nhiên khi xem kết quả, có thể thấy hầu hết là lỗi xuống dòng 2 lần thay vì 1 lần, nên điều này không ảnh hưởng đến nội dung chính của văn bản. Nếu bỏ qua lỗi về xuống dòng, độ chính xác trung bình từ #calc.round(tess_accuracy, digits: 2)% trở thành #calc.round(adjusted_acc, digits: 2)%

#figure(
  image("figures/newline.png"),
  caption: "Hầu hết lỗi xuống dòng là xuống dòng 2 lần"
)

Các lỗi còn lại hầu hết là các ký tự có dấu trong tiếng Việt, tiêu biểu có:
- ắ: 129 lỗi
- â: 76 lỗi
- ê: 70 lỗi
- ỗ: 63 lỗi
- ô: 52 lỗi
- ầ: 50 lỗi
- ề: 50 lỗi

Các ký tự này đều có 1 hoặc nhiều dấu thanh. Như đã nói ở @chinhta, các dấu thanh trong tiếng Việt rất dễ gây nhầm lẫn nếu độ phân giải không đủ.

*Đề xuất:* Một module kiểm tra chính tả có lẽ sẽ làm tăng độ chính xác của Tesseract.

*Kết luận:*

Tesseract có độ chính xác cao đối với văn bản thông thường. Trong 50 lần chạy thử, hầu hết các kết quả đều có độ chính xác cao, chỉ cá biệt 2 trường hợp có độ chính xác 77%, 81%. Độ chính xác trung bình là #calc.round(tess_accuracy, digits: 2)%, nếu bỏ qua xuống dòng thừa thì độ chính xác là #calc.round(adjusted_acc, digits: 2)%.

Phần lớn lỗi là ở ký tự có dấu, có thể sẽ được cải thiện nếu có kiểm tra chính tả cơ bản.

#pagebreak()

= Tài liệu tham khảo

+ Tesseract OCR: https://tesseract-ocr.github.io/tessdoc/
+ Tesseract Advanced API: https://tesseract-ocr.github.io/tessapi/3.x/a01281.html
+ Leptonica: http://www.leptonica.org/
+ Leptonica API: https://tpgit.github.io/Leptonica/
+ Spring Boot: https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/
+ JavaCPP: http://bytedeco.org/
+ Tesseract benchmark: https://research.aimultiple.com/ocr-accuracy/
+ PDFBox: https://pdfbox.apache.org/
+ Khoảng cách Levenshtein:
  - https://www.educative.io/answers/the-levenshtein-distance-algorithm
  - https://en.wikipedia.org/wiki/Levenshtein_distance
+ Diff Match Patch: https://github.com/google/diff-match-patch

#pagebreak()

#align(
  center,
  text(
    "Khoa Toán - Cơ - Tin học
    Trường ĐH Khoa học Tự nhiên - ĐHQGHN",
    weight: 900,
  ),
)
#v(40pt)

#align(
  center,
  text(
    "NHẬN XÉT THỰC TẬP",
    weight: 900,
    size: 20pt,
  ),
)
#v(20pt)

#align(left,
  grid(
    columns: (auto, auto),
    column-gutter: 70pt,
    row-gutter: 15pt,
    [Công ty thực tập:], [CÔNG TY TNHH HỆ THỐNG THÔNG TIN FPT],
    [Người hướng dẫn:], [Lê Huy Toàn],
    [Thời gian thực tập:], [15/05/2023 - 04/08/2023],
    [Họ và tên sinh viên:], [Phạm Hoàng Hải],
  )
)
#v(30pt)

1. Ý thức làm việc của sinh viên: 
........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

2. Khả năng làm việc/học hỏi:

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

3. Mức độ hoàn thành những nhiệm vụ được giao:

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

#pagebreak()

4. Xác nhận công việc được báo cáo có đúng như công việc được giao?

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

5. Những vẫn đề cần góp ý với thực tập sinh/ nhà trường để công việc có thể tiến hành tốt hơn:

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

........................................................................................................................................................................................

6. Điểm đánh giá (theo thang điểm 10):
........................................................................................................................................................................................

#v(50pt)

#align(
  center,
  grid(
    columns: (auto, auto),
    column-gutter: 100pt,
    row-gutter: 20pt,
    [], [_Hà Nội, ngày ...... tháng 08 năm 2023_],
    [*Xác nhận của người đánh giá*], [*Xác nhận của doanh nghiệp*],
    [], [(kí và đóng dấu)],
  )
)
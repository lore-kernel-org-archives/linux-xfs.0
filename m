Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1ABD07CA2
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 20:51:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63B66AC003
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 18:51:20 -0700 (PDT)
Received: from regular2.263xmail.com (regular2.263xmail.com [211.157.152.3])
	by cuda.sgi.com with ESMTP id K1efuh4bINl5QFoG (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 Jun 2016 18:51:15 -0700 (PDT)
Received: from regular1.263xmail.com (unknown [192.168.165.185])
	by regular2.263xmail.com (Postfix) with ESMTP id 13F6B1EA47
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 09:51:06 +0800 (CST)
Received: from ning_wang?asdc.com.cn (unknown [192.168.167.87])
	by regular1.263xmail.com (Postfix) with SMTP id 2DDB04CA7
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 09:50:57 +0800 (CST)
Received: from smtp.263.net (va-smtp01.263.net [54.88.144.211])
	by smtp.263.net (Postfix) with ESMTP id 2ADC6735B
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 09:50:57 +0800 (CST)
Received: from MchiaelPC (localhost.localdomain [127.0.0.1])
	by smtp.263.net (Postfix) with ESMTP id E33CA9F615
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 09:50:49 +0800 (CST)
From: "Michael" <ning_wang@asdc.com.cn>
Subject: questions about flush data to disk.
Date: Tue, 14 Jun 2016 09:50:45 +0800
Message-ID: <00ba01d1c5df$2d254090$876fc1b0$@asdc.com.cn>
MIME-Version: 1.0
Content-Language: zh-cn
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3842760168469513344=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multipart message in MIME format.

--===============3842760168469513344==
Content-Type: multipart/related;
	boundary="----=_NextPart_000_00BB_01D1C622.3B4BDBF0"
Content-Language: zh-cn

This is a multipart message in MIME format.

------=_NextPart_000_00BB_01D1C622.3B4BDBF0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_00BC_01D1C622.3B4BDBF0"


------=_NextPart_001_00BC_01D1C622.3B4BDBF0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

Dear SGI,

=20

I=A1=AFm trying to backup XFS partition SUSE 12 with XFS_PROGS 3.2.1, =
when we do
snapshot of the partition. The created snapshot always have problem by =
run
=A1=B0xfs_repair =A8Cn /dev/VG/snapshot=A1=B1. I have tried =
=A1=B0sync=A1=B1 didn=A1=AFt flush
cache to disk. Then tried to umount and mount the XFS partition the =
snapshot
looks fine. Can you tell me another way to force XFS flush cached data =
to
disk?=20

=20

Best Regards

Michael(Ning)Wang

-------------------------------------------------------------------------=
---
-------------------------------------------

=CB=B5=C3=F7: cid:_Foxmail.1@95d58f00-9e62-93f7-6199-b1696cc80320

ADVANCED SYSTEMS DEVELOPMENT CO.,LTD.

3/F DASCOM Mansion, 9# East Road Shangdi, Haidian, Beijing, 100085

Tel=A3=BA010-62981691-1234, 010-62980000, 010-82780000

Fax=A3=BA010-62981258

E-mail=A3=BA <mailto:ning_wang@asdc.com.cn> ning_wang@asdc.com.cn

Http=A3=BA <http://www.asdc.com.cn/> www.asdc.com.cn

=CB=B5=C3=F7: cid:_Foxmail.1@e1a38f84-0fa5-04a6-9e7c-c5842b6ca2fa

=20


------=_NextPart_001_00BC_01D1C622.3B4BDBF0
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; charset=3Dgb2312"><meta =
name=3DGenerator content=3D"Microsoft Word 14 (filtered medium)"><!--[if =
!mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:=CB=CE=CC=E5;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:=CB=CE=CC=E5;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:=CE=A2=C8=ED=D1=C5=BA=DA;
	panose-1:2 11 5 3 2 2 4 2 2 4;}
@font-face
	{font-family:"\@=CB=CE=CC=E5";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"\@=CE=A2=C8=ED=D1=C5=BA=DA";
	panose-1:2 11 5 3 2 2 4 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"=C5=FA=D7=A2=BF=F2=CE=C4=B1=BE Char";
	margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:9.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:black;}
span.Char
	{mso-style-name:"=C5=FA=D7=A2=BF=F2=CE=C4=B1=BE Char";
	mso-style-priority:99;
	mso-style-link:=C5=FA=D7=A2=BF=F2=CE=C4=B1=BE;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DZH-CN link=3Dblue =
vlink=3Dpurple style=3D'text-justify-trim:punctuation'><div =
class=3DWordSection1><p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:14.0pt;color:black'>Dear SGI,<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:14.0pt;color:black'><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:14.0pt;color:black'>I=A1=AFm trying to backup XFS =
partition SUSE 12 with XFS_PROGS 3.2.1, when we do snapshot of the =
partition. The created snapshot always have problem by run =
=A1=B0xfs_repair =A8Cn /dev/VG/snapshot=A1=B1. I have tried =
=A1=B0sync=A1=B1 didn=A1=AFt flush cache to disk. Then tried to umount =
and mount the XFS partition the snapshot looks fine. Can you tell me =
another way to force XFS flush cached data to disk? =
<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:14.0pt;color:black'><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;line-height:18.0pt;background:#F2F2F2'><b><span =
lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Tahoma","sans-serif";color:#434343=
;border:none windowtext 1.0pt;padding:0cm'>Best =
Regards</span></b><b><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"Tahoma","sans-serif";color:#434343=
'><o:p></o:p></span></b></p><p class=3DMsoNormal =
style=3D'line-height:12.0pt'><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-se=
rif";color:#333333'>Michael(Ning)Wang<o:p></o:p></span></p><p =
class=3DMsoNormal style=3D'line-height:12.0pt'><span lang=3DEN-US =
style=3D'font-size:9.0pt;color:#333333'>---------------------------------=
-------------------------------------------------------------------------=
-------------</span><span lang=3DEN-US =
style=3D'color:black'><o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'line-height:12.0pt'><span lang=3DEN-US =
style=3D'color:black'><img width=3D222 height=3D25 =
id=3D"=CD=BC=C6=AC_x0020_1" src=3D"cid:image001.png@01D1C622.38742AE0" =
alt=3D"=CB=B5=C3=F7: =
cid:_Foxmail.1@95d58f00-9e62-93f7-6199-b1696cc80320"><o:p></o:p></span></=
p><p class=3DMsoNormal style=3D'line-height:20.0pt'><b><span =
lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-se=
rif";color:#333333'>ADVANCED SYSTEMS DEVELOPMENT =
CO.,LTD.</span></b><span lang=3DEN-US =
style=3D'color:black'><o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'line-height:20.0pt'><span lang=3DEN-US =
style=3D'font-size:11.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-se=
rif";color:black'>3/F DASCOM Mansion, 9# East Road Shangdi, Haidian, =
Beijing, 100085</span><span lang=3DEN-US =
style=3D'font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-serif";color:black'=
><o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>Tel</span><span =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>=A3=BA<span lang=3DEN-US>010-62981691-1234, =
010-62980000, 010-82780000</span></span><span lang=3DEN-US =
style=3D'color:black'><o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>Fax</span><span =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>=A3=BA<span =
lang=3DEN-US>010-62981258</span></span><span lang=3DEN-US =
style=3D'color:black'><o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>E-mail</span><span =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>=A3=BA<span lang=3DEN-US><a =
href=3D"mailto:ning_wang@asdc.com.cn"><span =
style=3D'color:blue'>ning_wang@asdc.com.cn</span></a></span></span><span =
lang=3DEN-US style=3D'color:black'><o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>Http</span><span =
style=3D'font-size:9.0pt;font-family:"=CE=A2=C8=ED=D1=C5=BA=DA","sans-ser=
if";color:#333333'>=A3=BA<span lang=3DEN-US><a =
href=3D"http://www.asdc.com.cn/"><span =
style=3D'color:blue'>www.asdc.com.cn</span></a></span></span><span =
lang=3DEN-US style=3D'color:black'><o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US style=3D'color:black'><img =
border=3D0 width=3D400 height=3D90 id=3D"=CD=BC=C6=AC_x0020_2" =
src=3D"cid:image002.gif@01D1C622.38742AE0" alt=3D"=CB=B5=C3=F7: =
cid:_Foxmail.1@e1a38f84-0fa5-04a6-9e7c-c5842b6ca2fa"><o:p></o:p></span></=
p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p></div></body></html>
------=_NextPart_001_00BC_01D1C622.3B4BDBF0--

------=_NextPart_000_00BB_01D1C622.3B4BDBF0
Content-Type: image/png;
	name="image001.png"
Content-Transfer-Encoding: base64
Content-ID: <image001.png@01D1C622.38742AE0>

iVBORw0KGgoAAAANSUhEUgAAAN4AAAAZCAYAAABeipC7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJ
bWFnZVJlYWR5ccllPAAAAyBpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdp
bj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6
eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEz
NDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJo
dHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlw
dGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAv
IiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RS
ZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpD
cmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBXaW5kb3dzIiB4bXBNTTpJbnN0YW5jZUlE
PSJ4bXAuaWlkOjlEM0E1Mzc0QzAwMTExRTVBMkU5REQ1QTQ4MkQ5QzJGIiB4bXBNTTpEb2N1bWVu
dElEPSJ4bXAuZGlkOjlEM0E1Mzc1QzAwMTExRTVBMkU5REQ1QTQ4MkQ5QzJGIj4gPHhtcE1NOkRl
cml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6OUQzQTUzNzJDMDAxMTFFNUEyRTlE
RDVBNDgyRDlDMkYiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6OUQzQTUzNzNDMDAxMTFFNUEy
RTlERDVBNDgyRDlDMkYiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1l
dGE+IDw/eHBhY2tldCBlbmQ9InIiPz5bFwtCAAAJeElEQVR42uxcvW7jRhCmDu5PySFAkCY0UgRI
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
fwIMAE8YLTUlD+5LAAAAAElFTkSuQmCC

------=_NextPart_000_00BB_01D1C622.3B4BDBF0
Content-Type: image/gif;
	name="image002.gif"
Content-Transfer-Encoding: base64
Content-ID: <image002.gif@01D1C622.38742AE0>

R0lGODlhkAFaAPcAAAAAAP////Ly8pK92iAfIGRjZOvr7Ofn6OXl5gA8hUZHSABXqQBIjAFVoQFN
kgVTmBBPjBpbliZjmgBcrAJgsQJgrwRcpgVhrglfqApgqA1krBRqsRhmqR5injR3rzFrnUyEskh6
pmSOsHOXtJ660tPg63ehwYOtzX6guouuyImnvprB3KbH3rLO4b7T4sTZ57PF0uLp7uzv8ZK+2pWx
wqC5ya3AzMnW3trl7JLA2cDN1N/h4pLC2MLR2MTT2pLD15LF1pTG1pLI1JbK1eDl5p7N1tLf4ajS
17DW2LXY2Mne3s7g4Nbh4czR0SgpKeXn59fY2NHS0sPExL2+vrKzs7CxsamqqpydnZWWlo+QkIiJ
ibjZ2L3b2sbe3bra2Mzf3sDc2tvk4+Xn5dPV0/Hy8d3e3eHj4Lq7ube4teLj4N7f3MXGwzk5OOjo
5ubm5OHh3+Hh4IuLipqXkYSDgbm4toqHgrWxq317eH57d4B9eTg1Mjs4NeDb1snIx66ppUhFQyom
JBYUEywqKXt5eMG/viUiIRQSEjEvL97d3fHx8e/v7+3t7ezs7Ovr6+np6efn5+Xl5ePj497e3tzc
3Nvb29nZ2dbW1tTU1NLS0tHR0dDQ0M/Pz8zMzMrKysjIyMbGxsTExMLCwsHBwb6+vry8vLu7u7m5
ubi4uLe3t7a2trS0tK6urq2traurq6mpqaampqWlpaOjo6KioqCgoJ6enpubm5mZmZaWlpWVlZKS
kpGRkY6OjoyMjIeHh4SEhIODg4KCgn9/f319fXt7e3l5eXd3d3R0dHFxcW9vb21tbWtra2lpaWZm
ZmVlZWNjY2BgYF9fX11dXVpaWllZWVhYWFdXV1RUVFJSUlFRUU5OTkxMTEtLS0lJSUdHR0VFRUJC
Qj8/Pz09PTs7Ozc3NzU1NTMzMzExMS8vLywsLCoqKicnJyUlJSMjIyAgIB4eHhwcHBsbGxkZGRcX
FxUVFRISEhAQEA4ODg0NDQoKCgkJCQYGBgUFBQQEBAICAgEBAf///yH5BAEAAP8ALAAAAACQAVoA
AAj/AAUIHEiwoMGDCBMqXMiwocOHECNKnEixosWLGDNq3Mixo8ePIEOKHEmypMmTKFOqXMmypcuX
MGPKnEmzps2bOHPq3Mmzp8+fQIMKHUq0qNGjSJMqXcq0qdOnUKNKnUq1qtWrWLOCTOSQq9avYKdW
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

------=_NextPart_000_00BB_01D1C622.3B4BDBF0--



--===============3842760168469513344==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3842760168469513344==--

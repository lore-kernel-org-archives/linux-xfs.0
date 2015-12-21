Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3DCA57F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 01:15:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D0B48F8039
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 23:15:36 -0800 (PST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
	by cuda.sgi.com with ESMTP id 3s4RqVufvV0ZRMX3 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 23:15:32 -0800 (PST)
From: Linpeimin <linpeimin@hisilicon.com>
Subject: xfs within one hour after power-on reset , nginx performance is
	poor and do not have this phenomenon on ext4
Date: Mon, 21 Dec 2015 07:09:58 +0000
Message-ID: <11FA37A582DFC847A21131D4B69D8B495AA49849@szxema505-mbs.china.huawei.com>
Content-Language: zh-CN
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3296450135308955536=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Linpeimin <linpeimin@hisilicon.com>

--===============3296450135308955536==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_11FA37A582DFC847A21131D4B69D8B495AA49849szxema505mbschi_"

--_000_11FA37A582DFC847A21131D4B69D8B495AA49849szxema505mbschi_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8gLCB3ZSB1c2UgeGZzIGZpbGUgc3lzdGVtIHRvIHRlc3QgbmdpbnggLCBJIGZvdW5kIHRo
ZSBwb3dlci1vbiByZXNldCAsIHdpdGhpbiB0aGUgZmlyc3Qgb25lIGhvdXIgbmdpbnggcmVsYXRp
dmVseSBwb29yIHBlcmZvcm1hbmNlLCBhbmQgYWZ0ZXIgb25lIGhvdXIgLCByZS0gdGVzdCAsIHBl
cmZvcm1hbmNlIHJlc3VsdCggUlBTKSBvZiBkeW5hbWljIHBhZ2VzIGhhcyBpbXByb3ZlZC5JZiB3
ZSBjaGFuZ2UgdGhlIGZpbGUgc3lzdGVtIGludG8gZXh0NCwgeW91IGRvIG5vdCBoYXZlIHRoaXMg
cGhlbm9tZW5vbiAsIGFmdGVyIHRoZSBzdGFydCxSUFMgcGVyZm9ybWFuY2UgaGFzIHJlbWFpbmVk
IHN0YWJsZS4NCkF0IHByZXNlbnQgaXQgaXMgZGlmZmljdWx0IGZvciB1cyB0byBleHBsYWluIHRo
aXMgcGhlbm9tZW5vbi5JIGhvcGUgSSBjYW4gZ2V0IHlvdXIgc3VwcG9ydCBhbmQgYW5zd2VycyAs
IHZlcnkgZ3JhdGVmdWwgIQ0KDQoNCg0KDQoNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18NCrG+08q8/rywxuS4vbz+uqzT0Luqzqq5q8u+tcSxo8Pc0MXPoqOsvfbP3tPat6LLzbj4
yc/D5rXY1rfW0MHQs/a1xLj2yMu78si61+mho737DQrWucjOus7G5Mv7yMvS1MjOus7Qzsq9yrnT
w6OosPzAqLWrsrvP3tPayKuyv7vysr+31rXY0LnCtqGiuLTWxqGiu/LJoreio6mxvtPKvP7W0A0K
tcTQxc+ioaPI57n7xPq07crVwcuxvtPKvP6jrMfrxPrBory0tee7sLvy08q8/s2o1qq3orz+yMuy
osm+s/2xvtPKvP6joQ0KVGhpcyBlLW1haWwgYW5kIGl0cyBhdHRhY2htZW50cyBjb250YWluIGNv
bmZpZGVudGlhbCBpbmZvcm1hdGlvbiBmcm9tIEhVQVdFSSwgd2hpY2gNCmlzIGludGVuZGVkIG9u
bHkgZm9yIHRoZSBwZXJzb24gb3IgZW50aXR5IHdob3NlIGFkZHJlc3MgaXMgbGlzdGVkIGFib3Zl
LiBBbnkgdXNlIG9mIHRoZQ0KaW5mb3JtYXRpb24gY29udGFpbmVkIGhlcmVpbiBpbiBhbnkgd2F5
IChpbmNsdWRpbmcsIGJ1dCBub3QgbGltaXRlZCB0bywgdG90YWwgb3IgcGFydGlhbA0KZGlzY2xv
c3VyZSwgcmVwcm9kdWN0aW9uLCBvciBkaXNzZW1pbmF0aW9uKSBieSBwZXJzb25zIG90aGVyIHRo
YW4gdGhlIGludGVuZGVkDQpyZWNpcGllbnQocykgaXMgcHJvaGliaXRlZC4gSWYgeW91IHJlY2Vp
dmUgdGhpcyBlLW1haWwgaW4gZXJyb3IsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBieQ0KcGhv
bmUgb3IgZW1haWwgaW1tZWRpYXRlbHkgYW5kIGRlbGV0ZSBpdCENCg==

--_000_11FA37A582DFC847A21131D4B69D8B495AA49849szxema505mbschi_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:m=3D"http://schema=
s.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html=
40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:=CB=CE=CC=E5;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:=BB=AA=CE=C4=CF=B8=BA=DA;
	panose-1:2 1 6 0 4 1 1 1 1 1;}
@font-face
	{font-family:"\@=CB=CE=CC=E5";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"\@=BB=AA=CE=C4=CF=B8=BA=DA";
	panose-1:2 1 6 0 4 1 1 1 1 1;}
@font-face
	{font-family:inherit;
	panose-1:0 0 0 0 0 0 0 0 0 0;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
pre
	{mso-style-priority:99;
	mso-style-link:"HTML =D4=A4=C9=E8=B8=F1=CA=BD Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:=CB=CE=CC=E5;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.HTMLChar
	{mso-style-name:"HTML =D4=A4=C9=E8=B8=F1=CA=BD Char";
	mso-style-priority:99;
	mso-style-link:"HTML =D4=A4=C9=E8=B8=F1=CA=BD";
	font-family:=CB=CE=CC=E5;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
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
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"text-justi=
fy-trim:punctuation">
<div class=3D"WordSection1">
<pre style=3D"background:white"><span lang=3D"EN" style=3D"font-family:&quo=
t;inherit&quot;,serif;color:#212121">Hello , we use xfs file system to test=
 nginx , I found the power-on reset , within the first one hour nginx relat=
ively poor performance, and after one hour , re- test , performance result(=
 RPS) of dynamic pages has improved.If we change the file system into ext4,=
 you do not have this phenomenon , after the start,RPS performance has rema=
ined stable.<o:p></o:p></span></pre>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN" style=3D"font-size:12.0pt;font-family:&quot;inherit=
&quot;,serif;color:#212121">At present it is difficult for us to explain th=
is phenomenon.I hope I can get your support and answers
 , very grateful !</span><span lang=3D"EN-US" style=3D"font-size:12.0pt;fon=
t-family:&quot;inherit&quot;,serif;color:#212121"><o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left;background:w=
hite"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<pre style=3D"background:white"><span lang=3D"EN-US" style=3D"font-family:&=
quot;inherit&quot;,serif;color:#212121"><o:p>&nbsp;</o:p></span></pre>
<pre style=3D"background:white"><span lang=3D"EN" style=3D"font-family:&quo=
t;inherit&quot;,serif;color:#212121"><o:p>&nbsp;</o:p></span></pre>
<div class=3D"MsoNormal" align=3D"center" style=3D"text-align:center"><span=
 lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">
<hr size=3D"2" width=3D"100%" align=3D"center">
</span></div>
<p class=3D"MsoNormal"><span style=3D"font-size:7.5pt;font-family:=BB=AA=CE=
=C4=CF=B8=BA=DA;color:gray">=B1=BE=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=BA=
=AC=D3=D0=BB=AA=CE=AA=B9=AB=CB=BE=B5=C4=B1=A3=C3=DC=D0=C5=CF=A2=A3=AC=BD=F6=
=CF=DE=D3=DA=B7=A2=CB=CD=B8=F8=C9=CF=C3=E6=B5=D8=D6=B7=D6=D0=C1=D0=B3=F6=B5=
=C4=B8=F6=C8=CB=BB=F2=C8=BA=D7=E9=A1=A3=BD=FB<span lang=3D"EN-US"><br>
</span>=D6=B9=C8=CE=BA=CE=C6=E4=CB=FB=C8=CB=D2=D4=C8=CE=BA=CE=D0=CE=CA=BD=
=CA=B9=D3=C3=A3=A8=B0=FC=C0=A8=B5=AB=B2=BB=CF=DE=D3=DA=C8=AB=B2=BF=BB=F2=B2=
=BF=B7=D6=B5=D8=D0=B9=C2=B6=A1=A2=B8=B4=D6=C6=A1=A2=BB=F2=C9=A2=B7=A2=A3=A9=
=B1=BE=D3=CA=BC=FE=D6=D0<span lang=3D"EN-US"><br>
</span>=B5=C4=D0=C5=CF=A2=A1=A3=C8=E7=B9=FB=C4=FA=B4=ED=CA=D5=C1=CB=B1=BE=
=D3=CA=BC=FE=A3=AC=C7=EB=C4=FA=C1=A2=BC=B4=B5=E7=BB=B0=BB=F2=D3=CA=BC=FE=CD=
=A8=D6=AA=B7=A2=BC=FE=C8=CB=B2=A2=C9=BE=B3=FD=B1=BE=D3=CA=BC=FE=A3=A1<span =
lang=3D"EN-US"><br>
</span></span><span lang=3D"EN-US" style=3D"font-size:7.5pt;font-family:&qu=
ot;Arial&quot;,sans-serif;color:gray">This e-mail and its attachments conta=
in confidential information from HUAWEI, which
<br>
is intended only for the person or entity whose address is listed above. An=
y use of the
<br>
information contained herein in any way (including, but not limited to, tot=
al or partial
<br>
disclosure, reproduction, or dissemination) by persons other than the inten=
ded <br>
recipient(s) is prohibited. If you receive this e-mail in error, please not=
ify the sender by
<br>
phone or email immediately and delete it!</span><span lang=3D"EN-US"><o:p><=
/o:p></span></p>
</div>
</body>
</html>

--_000_11FA37A582DFC847A21131D4B69D8B495AA49849szxema505mbschi_--


--===============3296450135308955536==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3296450135308955536==--

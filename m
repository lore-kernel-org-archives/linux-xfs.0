Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 952D87F37
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 04:07:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 104BCAC005
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 02:07:46 -0700 (PDT)
Received: from h3cmg01-ex.h3c.com (smtp.h3c.com [60.191.123.56]) by
	cuda.sgi.com with ESMTP id jcu7SNsobTjZtAYs for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2015 02:07:43 -0700 (PDT)
From: "zhengbin.08747@h3c.com" <zhengbin.08747@h3c.com>
Subject: hello, my xfs has a probelm. does anybody know this?thank you
Date: Tue, 25 Aug 2015 09:08:06 +0000
Message-ID: <7B5C2F2226F8AF419D625C6097AD814C5E26FE9C@H3CMLB12-EX.srv.huawei-3com.com>
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
Content-Type: multipart/mixed; boundary="===============2979588618132633420=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2979588618132633420==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_7B5C2F2226F8AF419D625C6097AD814C5E26FE9CH3CMLB12EXsrvhu_"

--_000_7B5C2F2226F8AF419D625C6097AD814C5E26FE9CH3CMLB12EXsrvhu_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

My OS is redhat7.1, the version of Linux kernel is "Linux version 3.10.0-22=
9.el7.x86_64"


Sometime xfs give a message like this

Aug 11 15:51:05 localhost kernel: XFS (dm-4): metadata I/O error: block 0x7=
d9a010 ("xfs_trans_read_buf_map") error 117 numblks 16
Aug 11 15:51:05 localhost kernel: XFS (dm-4): xfs_imap_to_bp: xfs_trans_rea=
d_buf() returned error 117.

Aug 11 15:31:08 localhost kernel: XFS (dm-4): Metadata corruption detected =
at xfs_inode_buf_verify+0x75/0xd0 [xfs], block 0x7d9a010
Aug 11 15:31:08 localhost kernel: XFS (dm-4): Unmount and run xfs_repair
Aug 11 15:31:08 localhost kernel: XFS (dm-4): First 64 bytes of corrupted m=
etadata buffer:
Aug 11 15:31:08 localhost kernel: ffff88089144a000: 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00  ................
Aug 11 15:31:08 localhost kernel: ffff88089144a010: 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00  ................
Aug 11 15:31:08 localhost kernel: ffff88089144a020: 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00  ................
Aug 11 15:31:08 localhost kernel: ffff88089144a030: 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00  ................


So is this a bug of xfs? or is the device's error(the device actually did n=
ot save the data, but give xfs success message)?



---------------------------------------------------------------------------=
----------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, =
which is
intended only for the person or entity whose address is listed above. Any u=
se of the
information contained herein in any way (including, but not limited to, tot=
al or partial
disclosure, reproduction, or dissemination) by persons other than the inten=
ded
recipient(s) is prohibited. If you receive this e-mail in error, please not=
ify the sender
by phone or email immediately and delete it!

--_000_7B5C2F2226F8AF419D625C6097AD814C5E26FE9CH3CMLB12EXsrvhu_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<style>
<!--
@font-face
	{font-family:SimSun}
@font-face
	{font-family:SimSun}
@font-face
	{font-family:Calibri}
@font-face
	{font-family:SimSun}
@font-face
	{font-family:"Segoe UI"}
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri","sans-serif"}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline}
span.EmailStyle17
	{font-family:"Calibri","sans-serif";
	color:windowtext}
.MsoChpDefault
	{font-family:"Calibri","sans-serif"}
@page WordSection1
	{margin:72.0pt 90.0pt 72.0pt 90.0pt}
div.WordSection1
	{}
-->
</style>
</head>
<body lang=3D"ZH-CN" link=3D"blue" vlink=3D"purple" style=3D"">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US">My OS is redhat7.1, the version=
 of </span>
<span lang=3D"EN-US" style=3D"font-size:9.5pt; font-family:&quot;Arial&quot=
;,&quot;sans-serif&quot;; color:black; background:white">Linux kernel is
</span><span style=3D"font-size:9.5pt; font-family:SimSun; color:black; bac=
kground:white">&#8220;</span><span lang=3D"EN-US" style=3D"font-size:10.0pt=
; font-family:&quot;Segoe UI&quot;,&quot;sans-serif&quot;; color:black">Lin=
ux version 3.10.0-229.el7.x86_64</span><span style=3D"font-size:10.0pt; fon=
t-family:SimSun; color:black">&#8221;</span><span lang=3D"EN-US" style=3D"f=
ont-size:9.5pt; font-family:&quot;Arial&quot;,&quot;sans-serif&quot;; color=
:black; background:white"></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:10.0pt; font-family:&quot;Segoe UI&quot;,&quo=
t;sans-serif&quot;; color:black">&nbsp;</span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:10.0pt; font-family:&quot;Segoe UI&quot;,&quo=
t;sans-serif&quot;; color:black">&nbsp;</span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:10.0pt; font-family:&quot;Segoe UI&quot;,&quo=
t;sans-serif&quot;; color:black">Sometime xfs give a message like this</spa=
n></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:10.0pt; font-family:&quot;Segoe UI&quot;,&quo=
t;sans-serif&quot;; color:black">&nbsp;</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:51:05 localhost kerne=
l: XFS (dm-4): metadata I/O error: block 0x7d9a010 (&quot;xfs_trans_read_bu=
f_map&quot;) error 117 numblks 16</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:51:05 localhost kerne=
l: XFS (dm-4): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.&nbs=
p;
</span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt; font-family:SimSun">&nbsp;</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:31:08 localhost kerne=
l: XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify&#43;0x7=
5/0xd0 [xfs], block 0x7d9a010</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:31:08 localhost kerne=
l: XFS (dm-4): Unmount and run xfs_repair</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:31:08 localhost kerne=
l: XFS (dm-4): First 64 bytes of corrupted metadata buffer:</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:31:08 localhost kerne=
l: ffff88089144a000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp; =
................</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:31:08 localhost kerne=
l: ffff88089144a010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp; =
................</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:31:08 localhost kerne=
l: ffff88089144a020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp; =
................</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Aug 11 15:31:08 localhost kerne=
l: ffff88089144a030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00&nbsp; =
................</span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt; font-family:SimSun">&nbsp;</span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt; font-family:SimSun">&nbsp;</span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt; font-family:SimSun">So is this a bug =
of xfs? or is the device&#8217;s error(the device actually did not save the=
 data, but give xfs success message)?</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;</span></p>
</div>
<span style=3D"font-size:7.5pt; font-family:&#21326;&#25991;&#32454;&#40657=
;; color:gray"><span lang=3D"EN-US">---------------------------------------=
---------------------------------------------------------------------------=
-------------------<br>
</span>&#26412;&#37038;&#20214;&#21450;&#20854;&#38468;&#20214;&#21547;&#26=
377;&#26477;&#24030;&#21326;&#19977;&#36890;&#20449;&#25216;&#26415;&#26377=
;&#38480;&#20844;&#21496;&#30340;&#20445;&#23494;&#20449;&#24687;&#65292;&#=
20165;&#38480;&#20110;&#21457;&#36865;&#32473;&#19978;&#38754;&#22320;&#223=
36;&#20013;&#21015;&#20986;<span lang=3D"EN-US"><br>
</span>&#30340;&#20010;&#20154;&#25110;&#32676;&#32452;&#12290;&#31105;&#27=
490;&#20219;&#20309;&#20854;&#20182;&#20154;&#20197;&#20219;&#20309;&#24418=
;&#24335;&#20351;&#29992;&#65288;&#21253;&#25324;&#20294;&#19981;&#38480;&#=
20110;&#20840;&#37096;&#25110;&#37096;&#20998;&#22320;&#27844;&#38706;&#122=
89;&#22797;&#21046;&#12289;<span lang=3D"EN-US"><br>
</span>&#25110;&#25955;&#21457;&#65289;&#26412;&#37038;&#20214;&#20013;&#30=
340;&#20449;&#24687;&#12290;&#22914;&#26524;&#24744;&#38169;&#25910;&#20102=
;&#26412;&#37038;&#20214;&#65292;&#35831;&#24744;&#31435;&#21363;&#30005;&#=
35805;&#25110;&#37038;&#20214;&#36890;&#30693;&#21457;&#20214;&#20154;&#241=
82;&#21024;&#38500;&#26412;<span lang=3D"EN-US"><br>
</span>&#37038;&#20214;&#65281;<span lang=3D"EN-US"><br>
</span></span><span lang=3D"EN-US" style=3D"font-size:7.5pt; font-family:&q=
uot;Arial&quot;,&quot;sans-serif&quot;; color:gray">This e-mail and its att=
achments contain confidential information from H3C, which is
<br>
intended only for the person or entity whose address is listed above. Any u=
se of the
<br>
information contained herein in any way (including, but not limited to, tot=
al or partial
<br>
disclosure, reproduction, or dissemination) by persons other than the inten=
ded <br>
recipient(s) is prohibited. If you receive this e-mail in error, please not=
ify the sender
<br>
by phone or email immediately and delete it!</span>
</body>
</html>

--_000_7B5C2F2226F8AF419D625C6097AD814C5E26FE9CH3CMLB12EXsrvhu_--


--===============2979588618132633420==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2979588618132633420==--

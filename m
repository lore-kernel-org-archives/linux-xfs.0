Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67A8F7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 20:11:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2119AC001
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 18:11:35 -0800 (PST)
Received: from h3cmg01-ex.h3c.com (smtp.h3c.com [60.191.123.56]) by
	cuda.sgi.com with ESMTP id 0ZaxGmYffw9uH4G2 for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 18:11:32 -0800 (PST)
From: "zhao.mingyue@h3c.com" <zhao.mingyue@h3c.com>
Subject: xfs_growfs can expand capacity,then how to reduce xfs filesystem
	capacity?
Date: Thu, 3 Dec 2015 02:11:20 +0000
Message-ID: <1CB94550540AE44E9CAAE8CD5AF40BF846D18C5E@H3CMLB12-EX.srv.huawei-3com.com>
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
Content-Type: multipart/mixed; boundary="===============4608712509260423743=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "'xfs@oss.sgi.com'" <'xfs@oss.sgi.com'>

--===============4608712509260423743==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_1CB94550540AE44E9CAAE8CD5AF40BF846D18C5EH3CMLB12EXsrvhu_"

--_000_1CB94550540AE44E9CAAE8CD5AF40BF846D18C5EH3CMLB12EXsrvhu_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


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

--_000_1CB94550540AE44E9CAAE8CD5AF40BF846D18C5EH3CMLB12EXsrvhu_
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
span.EmailStyle18
	{font-family:"Calibri","sans-serif";
	color:#1F497D}
.MsoChpDefault
	{font-size:10.0pt}
@page WordSection1
	{margin:72.0pt 90.0pt 72.0pt 90.0pt}
div.WordSection1
	{}
-->
</style>
</head>
<body lang=3D"ZH-CN" link=3D"blue" vlink=3D"purple" style=3D"">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"color:#1F497D">&nbsp;<=
/span></p>
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

--_000_1CB94550540AE44E9CAAE8CD5AF40BF846D18C5EH3CMLB12EXsrvhu_--


--===============4608712509260423743==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4608712509260423743==--

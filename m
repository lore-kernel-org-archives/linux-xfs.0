Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D842529DF6
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2016 17:40:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 695D2AC002
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2016 15:40:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JRn8duPdcVVeiUxD for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2016 15:40:07 -0800 (PST)
From: Eric Sandeen <sandeen@sandeen.net>
Mime-Version: 1.0 (1.0)
Subject: Re: xfs_growfs can expand capacity,
	then how to reduce xfs filesystem capacity?
Message-Id: <C2F36C3F-87C2-4112-B861-76D08718E3DC@sandeen.net>
Date: Fri, 1 Jan 2016 15:40:06 -0800
References: <1CB94550540AE44E9CAAE8CD5AF40BF846D18C5E@H3CMLB12-EX.srv.huawei-3com.com>
In-Reply-To: <1CB94550540AE44E9CAAE8CD5AF40BF846D18C5E@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4830982016824511434=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "zhao.mingyue@h3c.com" <zhao.mingyue@h3c.com>, xfs@oss.sgi.com


--===============4830982016824511434==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-92929011-3B27-4518-AAA8-7F1F5F943123
Content-Transfer-Encoding: 7bit


--Apple-Mail-92929011-3B27-4518-AAA8-7F1F5F943123
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

http://xfs.org/index.php/XFS_FAQ#Q:_Is_there_a_way_to_make_a_XFS_filesystem_=
larger_or_smaller.3F

> On Dec 2, 2015, at 6:11 PM, "zhao.mingyue@h3c.com" <zhao.mingyue@h3c.com> w=
rote:
>=20
> =20
> --------------------------------------------------------------------------=
-----------------------------------------------------------
> =E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E5=90=AB=E6=
=9C=89=E6=9D=AD=E5=B7=9E=E5=8D=8E=E4=B8=89=E9=80=9A=E4=BF=A1=E6=8A=80=E6=9C=AF=
=E6=9C=89=E9=99=90=E5=85=AC=E5=8F=B8=E7=9A=84=E4=BF=9D=E5=AF=86=E4=BF=A1=E6=81=
=AF=EF=BC=8C=E4=BB=85=E9=99=90=E4=BA=8E=E5=8F=91=E9=80=81=E7=BB=99=E4=B8=8A=E9=
=9D=A2=E5=9C=B0=E5=9D=80=E4=B8=AD=E5=88=97=E5=87=BA
> =E7=9A=84=E4=B8=AA=E4=BA=BA=E6=88=96=E7=BE=A4=E7=BB=84=E3=80=82=E7=A6=81=E6=
=AD=A2=E4=BB=BB=E4=BD=95=E5=85=B6=E4=BB=96=E4=BA=BA=E4=BB=A5=E4=BB=BB=E4=BD=95=
=E5=BD=A2=E5=BC=8F=E4=BD=BF=E7=94=A8=EF=BC=88=E5=8C=85=E6=8B=AC=E4=BD=86=E4=B8=
=8D=E9=99=90=E4=BA=8E=E5=85=A8=E9=83=A8=E6=88=96=E9=83=A8=E5=88=86=E5=9C=B0=E6=
=B3=84=E9=9C=B2=E3=80=81=E5=A4=8D=E5=88=B6=E3=80=81
> =E6=88=96=E6=95=A3=E5=8F=91=EF=BC=89=E6=9C=AC=E9=82=AE=E4=BB=B6=E4=B8=AD=E7=
=9A=84=E4=BF=A1=E6=81=AF=E3=80=82=E5=A6=82=E6=9E=9C=E6=82=A8=E9=94=99=E6=94=B6=
=E4=BA=86=E6=9C=AC=E9=82=AE=E4=BB=B6=EF=BC=8C=E8=AF=B7=E6=82=A8=E7=AB=8B=E5=8D=
=B3=E7=94=B5=E8=AF=9D=E6=88=96=E9=82=AE=E4=BB=B6=E9=80=9A=E7=9F=A5=E5=8F=91=E4=
=BB=B6=E4=BA=BA=E5=B9=B6=E5=88=A0=E9=99=A4=E6=9C=AC
> =E9=82=AE=E4=BB=B6=EF=BC=81
> This e-mail and its attachments contain confidential information from H3C,=
 which is=20
> intended only for the person or entity whose address is listed above. Any u=
se of the=20
> information contained herein in any way (including, but not limited to, to=
tal or partial=20
> disclosure, reproduction, or dissemination) by persons other than the inte=
nded=20
> recipient(s) is prohibited. If you receive this e-mail in error, please no=
tify the sender=20
> by phone or email immediately and delete it!
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--Apple-Mail-92929011-3B27-4518-AAA8-7F1F5F943123
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><div></div><div><a href=3D"http://xfs.org/i=
ndex.php/XFS_FAQ#Q:_Is_there_a_way_to_make_a_XFS_filesystem_larger_or_smalle=
r.3F">http://xfs.org/index.php/XFS_FAQ#Q:_Is_there_a_way_to_make_a_XFS_files=
ystem_larger_or_smaller.3F</a></div><div><br>On Dec 2, 2015, at 6:11 PM, "<a=
 href=3D"mailto:zhao.mingyue@h3c.com">zhao.mingyue@h3c.com</a>" &lt;<a href=3D=
"mailto:zhao.mingyue@h3c.com">zhao.mingyue@h3c.com</a>&gt; wrote:<br><br></d=
iv><blockquote type=3D"cite"><div>

<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii">=

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


<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"color:#1F497D">&nbsp;</=
span></p>
</div>
<span style=3D"font-size:7.5pt; font-family:=E5=8D=8E=E6=96=87=E7=BB=86=E9=BB=
=91; color:gray"><span lang=3D"EN-US">--------------------------------------=
----------------------------------------------------------------------------=
-------------------<br>
</span>=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E5=90=
=AB=E6=9C=89=E6=9D=AD=E5=B7=9E=E5=8D=8E=E4=B8=89=E9=80=9A=E4=BF=A1=E6=8A=80=E6=
=9C=AF=E6=9C=89=E9=99=90=E5=85=AC=E5=8F=B8=E7=9A=84=E4=BF=9D=E5=AF=86=E4=BF=A1=
=E6=81=AF=EF=BC=8C=E4=BB=85=E9=99=90=E4=BA=8E=E5=8F=91=E9=80=81=E7=BB=99=E4=B8=
=8A=E9=9D=A2=E5=9C=B0=E5=9D=80=E4=B8=AD=E5=88=97=E5=87=BA<span lang=3D"EN-US=
"><br>
</span>=E7=9A=84=E4=B8=AA=E4=BA=BA=E6=88=96=E7=BE=A4=E7=BB=84=E3=80=82=E7=A6=
=81=E6=AD=A2=E4=BB=BB=E4=BD=95=E5=85=B6=E4=BB=96=E4=BA=BA=E4=BB=A5=E4=BB=BB=E4=
=BD=95=E5=BD=A2=E5=BC=8F=E4=BD=BF=E7=94=A8=EF=BC=88=E5=8C=85=E6=8B=AC=E4=BD=86=
=E4=B8=8D=E9=99=90=E4=BA=8E=E5=85=A8=E9=83=A8=E6=88=96=E9=83=A8=E5=88=86=E5=9C=
=B0=E6=B3=84=E9=9C=B2=E3=80=81=E5=A4=8D=E5=88=B6=E3=80=81<span lang=3D"EN-US=
"><br>
</span>=E6=88=96=E6=95=A3=E5=8F=91=EF=BC=89=E6=9C=AC=E9=82=AE=E4=BB=B6=E4=B8=
=AD=E7=9A=84=E4=BF=A1=E6=81=AF=E3=80=82=E5=A6=82=E6=9E=9C=E6=82=A8=E9=94=99=E6=
=94=B6=E4=BA=86=E6=9C=AC=E9=82=AE=E4=BB=B6=EF=BC=8C=E8=AF=B7=E6=82=A8=E7=AB=8B=
=E5=8D=B3=E7=94=B5=E8=AF=9D=E6=88=96=E9=82=AE=E4=BB=B6=E9=80=9A=E7=9F=A5=E5=8F=
=91=E4=BB=B6=E4=BA=BA=E5=B9=B6=E5=88=A0=E9=99=A4=E6=9C=AC<span lang=3D"EN-US=
"><br>
</span>=E9=82=AE=E4=BB=B6=EF=BC=81<span lang=3D"EN-US"><br>
</span></span><span lang=3D"EN-US" style=3D"font-size:7.5pt; font-family:&qu=
ot;Arial&quot;,&quot;sans-serif&quot;; color:gray">This e-mail and its attac=
hments contain confidential information from H3C, which is
<br>
intended only for the person or entity whose address is listed above. Any us=
e of the
<br>
information contained herein in any way (including, but not limited to, tota=
l or partial
<br>
disclosure, reproduction, or dissemination) by persons other than the intend=
ed <br>
recipient(s) is prohibited. If you receive this e-mail in error, please noti=
fy the sender
<br>
by phone or email immediately and delete it!</span>


</div></blockquote><blockquote type=3D"cite"><div><span>____________________=
___________________________</span><br><span>xfs mailing list</span><br><span=
><a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a></span><br><span><a h=
ref=3D"http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/l=
istinfo/xfs</a></span><br></div></blockquote></body></html>=

--Apple-Mail-92929011-3B27-4518-AAA8-7F1F5F943123--


--===============4830982016824511434==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4830982016824511434==--

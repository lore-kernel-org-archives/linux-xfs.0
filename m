Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 562967F4E
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 14:23:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16880304032
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 12:23:20 -0700 (PDT)
Received: from app02.fccn.pt (app02.fccn.pt [193.137.198.37]) by cuda.sgi.com
	with ESMTP id YQiAqjYEIo00yf4M (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 12:23:18 -0700 (PDT)
Received: from mx.anubis.local (ste [10.1.2.2])
	by outbound.anubis.local (Postfix) with ESMTP id A4621D2C21
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 20:23:17 +0100 (WEST)
Received: from zeno (argus.corp.fccn.pt [193.136.44.193])
	(Authenticated sender: duarte.franco@fccn.pt)
	by mx.anubis.local (Postfix) with ESMTP id 6F2A0C2E26
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 20:23:17 +0100 (WEST)
From: "Duarte  Franco" <duarte.franco@fccn.pt>
Subject: XFS data lost recover
Date: Tue, 10 Jun 2014 20:23:20 +0100
Message-ID: <27c101cf84e1$7259a7a0$570cf6e0$@fccn.pt>
MIME-Version: 1.0
Content-Language: pt
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8035302430199277076=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multipart message in MIME format.

--===============8035302430199277076==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_27C2_01CF84E9.D41ED2F0"
Content-Language: pt

This is a multipart message in MIME format.

------=_NextPart_000_27C2_01CF84E9.D41ED2F0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi

=20

I have a Linux RHEL 5.3 server with a XFS partition over lvm on an
infortrend Fc storage.=20

Recently we have a system failure that corrupt the XFS partition. After =
a
xfs_restore the partition was recovered but the lost+found directory =
contain
about 5.5TB of inode files. (almost the total size 7TB)

=20

After that the partitions were used to write a few more data, without =
any
problem.=20

=20

I would like to ask if there is any way to recover the files in =
lost+found
directory? Do you have any service to recover these files?=20

=20

If possible I would prefer to be contacted by email.

=20

Best Regards

=20

Duarte Franco

AIA =96 Area Infra-estruturas Aplicacionais=20

 _________________________________________________

FCT, FCCN

Av. do Brasil, 101 Apartado 50435 1708-001 Lisboa

Telf. 300 005 257  Fax 351 21 8472167

 <blocked::http://www.fccn.pt/> http://www.fccn.pt/

=20

Aviso de Confidencialidade

Esta mensagem =E9 exclusivamente destinada ao seu destinat=E1rio, =
podendo conter
informa=E7=E3o CONFIDENCIAL, cuja divulga=E7=E3o est=E1 expressamente =
vedada nos
termos da lei. Caso tenha recepcionado indevidamente esta mensagem,
solicitamos-lhe que nos comunique esse mesmo facto por esta via ou para =
o
telefone +351 218440100 devendo apagar o seu conte=FAdo de imediato.=20

This message is intended exclusively for its addressee. It may contain
CONFIDENTIAL information protected by law. If this message has been =
received
by error, please notify us via e-mail or by telephone +351 218440100 and
delete it immediately.

=20


------=_NextPart_000_27C2_01CF84E9.D41ED2F0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1"><meta name=3DGenerator content=3D"Microsoft Word =
15 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"Century Gothic";
	panose-1:2 11 5 2 2 2 2 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:70.85pt 3.0cm 70.85pt 3.0cm;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DPT =
link=3D"#0563C1" vlink=3D"#954F72"><div class=3DWordSection1><p =
class=3DMsoNormal>Hi<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal><span =
lang=3DEN-US>I have a Linux RHEL 5.3 server with a XFS partition over =
lvm on an infortrend Fc storage. <o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Recently we have a system failure =
that corrupt the XFS partition. After a =A0xfs_restore the partition was =
recovered but the lost+found directory contain about 5.5TB of inode =
files. (almost the total size 7TB)<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>After that the partitions were used =
to write a few more data, without any problem. <o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>I would like to ask if there is any =
way to recover the files in lost+found directory? Do you have any =
service to recover these files? <o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>If possible I would prefer to be =
contacted by email.<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Best Regards<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span style=3D'font-size:10.0pt;font-family:"Century =
Gothic","sans-serif";color:navy;mso-fareast-language:PT'>Duarte =
Franco</span><span =
style=3D'color:navy;mso-fareast-language:PT'><o:p></o:p></span></p><p =
class=3DMsoNormal><b><span =
style=3D'font-size:10.0pt;font-family:"Century =
Gothic","sans-serif";color:navy;mso-fareast-language:PT'>AIA</span></b><s=
pan style=3D'font-size:10.0pt;font-family:"Century =
Gothic","sans-serif";color:navy;mso-fareast-language:PT'> &#8211; Area =
Infra-estruturas Aplicacionais <o:p></o:p></span></p><p =
class=3DMsoNormal><span =
style=3D'color:navy;mso-fareast-language:PT'>&nbsp;</span><span =
style=3D'font-size:10.0pt;font-family:"Century =
Gothic","sans-serif";color:yellow;mso-fareast-language:PT'>______________=
___________________________________</span><span =
style=3D'font-size:10.0pt;font-family:"Century =
Gothic","sans-serif";color:navy;mso-fareast-language:PT'><o:p></o:p></spa=
n></p><p class=3DMsoNormal><span =
style=3D'font-size:8.0pt;font-family:"Century =
Gothic","sans-serif";color:gray;mso-fareast-language:PT'>FCT, =
FCCN</span><span =
style=3D'font-size:8.0pt;font-family:"Arial","sans-serif";color:navy;mso-=
fareast-language:PT'><o:p></o:p></span></p><p class=3DMsoNormal><span =
style=3D'font-size:8.0pt;font-family:"Century =
Gothic","sans-serif";color:gray;mso-fareast-language:PT'>Av. do Brasil, =
101 Apartado 50435 1708-001 Lisboa</span><span =
style=3D'font-size:8.0pt;font-family:"Arial","sans-serif";color:navy;mso-=
fareast-language:PT'><o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US style=3D'font-size:8.0pt;font-family:"Century =
Gothic","sans-serif";color:gray;mso-fareast-language:PT'>Telf. =
300&nbsp;005 257&nbsp;&nbsp;Fax 351 21 8472167</span><span lang=3DEN-US =
style=3D'font-size:8.0pt;font-family:"Arial","sans-serif";color:navy;mso-=
fareast-language:PT'><o:p></o:p></span></p><p class=3DMsoNormal><span =
style=3D'mso-fareast-language:PT'><a =
href=3D"blocked::http://www.fccn.pt/" =
title=3D"blocked::http://www.fccn.pt/&#10;http://www.fccn.pt/"><span =
lang=3DEN-US style=3D'font-size:8.0pt;font-family:"Century =
Gothic","sans-serif";color:blue'>http://www.fccn.pt/</span></a></span><sp=
an lang=3DEN-US =
style=3D'font-size:8.0pt;font-family:"Arial","sans-serif";color:navy;mso-=
fareast-language:PT'><o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US =
style=3D'mso-fareast-language:PT'><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal style=3D'text-align:justify'><b><span =
style=3D'font-size:10.0pt;color:gray;mso-fareast-language:PT'>Aviso de =
Confidencialidade</span></b><span =
style=3D'font-size:10.0pt;mso-fareast-language:PT'><o:p></o:p></span></p>=
<p class=3DMsoNormal style=3D'text-align:justify'><span =
style=3D'font-size:8.0pt;color:gray;mso-fareast-language:PT'>Esta =
mensagem =E9 exclusivamente destinada ao seu destinat=E1rio, podendo =
conter informa=E7=E3o CONFIDENCIAL, cuja divulga=E7=E3o est=E1 =
expressamente vedada nos termos da lei. Caso tenha recepcionado =
indevidamente esta mensagem, solicitamos-lhe que nos comunique esse =
mesmo facto por esta via ou para o telefone +351 218440100 devendo =
apagar o seu conte=FAdo de imediato. <o:p></o:p></span></p><p =
class=3DMsoNormal style=3D'text-align:justify'><span lang=3DEN-GB =
style=3D'font-size:8.0pt;color:gray;mso-fareast-language:PT'>This =
message is intended exclusively for its addressee. It may =
contain</span><span lang=3DEN-GB =
style=3D'font-size:8.0pt;color:navy;mso-fareast-language:PT'> =
</span><span lang=3DEN-GB =
style=3D'font-size:8.0pt;color:gray;mso-fareast-language:PT'>CONFIDENTIAL=
 information protected by law. If this message has been received by =
error, please notify us via e-mail or by telephone +351 218440100 and =
delete it immediately.<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p></div></body></html>
------=_NextPart_000_27C2_01CF84E9.D41ED2F0--


--===============8035302430199277076==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8035302430199277076==--

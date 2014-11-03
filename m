Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E76097F4E
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 14:35:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D397B304048
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 12:35:58 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id 1ukRBAfdUMDBXkgi
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 03 Nov 2014 12:35:57 -0800 (PST)
Received: from EXCHCAS1.wesad.wesleyan.edu (exchcas1.wesleyan.edu
	[129.133.1.104])
	by msa.wesleyan.edu (8.14.4/8.14.4) with ESMTP id sA3KZthH027224
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 15:35:56 -0500
From: "Meij, Henk" <hmeij@wesleyan.edu>
Subject: clone of filesystem across network preserving ionodes
Date: Mon, 3 Nov 2014 20:35:54 +0000
Message-ID: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6685497581024028723=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6685497581024028723==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_8688BD11DAC0574AA90295127E9E9F4AC047F1CAexchangewes8wes_"

--_000_8688BD11DAC0574AA90295127E9E9F4AC047F1CAexchangewes8wes_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

What is the best practice way to get the contents from server1 to server2 i=
dentical disk array partitions and preserve the ionode information using xf=
s tools or non-xfs tools?



xfsdump/xfsrestore appear to not preserve this or I can not find the obviou=
s setting.



xfs_copy would, per documentation, but can I get from server1 to server2?



-Henk



--_000_8688BD11DAC0574AA90295127E9E9F4AC047F1CAexchangewes8wes_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html dir=3D"ltr">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style id=3D"owaParaStyle">P {
	MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px
}
</style>
</head>
<body fPStyle=3D"1" ocsi=3D"0">
<div style=3D"direction: ltr;font-family: Arial;color: #000000;font-size: 1=
0pt;">
<p>What is the best practice way to get the contents from server1 to server=
2 identical disk array partitions and preserve the ionode information using=
 xfs tools or non-xfs tools?&nbsp;&nbsp;
</p>
<p>&nbsp;</p>
<p>xfsdump/xfsrestore appear to not preserve this or I can not find the obv=
ious setting.</p>
<p>&nbsp;</p>
<p>xfs_copy would, per documentation, but can I get from server1 to server2=
?</p>
<p>&nbsp;</p>
<p>-Henk</p>
<p>&nbsp;</p>
</div>
</body>
</html>

--_000_8688BD11DAC0574AA90295127E9E9F4AC047F1CAexchangewes8wes_--


--===============6685497581024028723==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6685497581024028723==--

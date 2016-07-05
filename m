Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E77047CE1
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 12:02:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8C7A304048
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 10:01:59 -0700 (PDT)
Received: from BAY004-OMC4S2.hotmail.com (bay004-omc4s2.hotmail.com
	[65.54.190.204]) by cuda.sgi.com with ESMTP id ARzct2TQ3RW3SGTP
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2016 10:01:54 -0700 (PDT)
From: Anthony l <Martinezant2141@live.com>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Date: Tue, 5 Jul 2016 17:01:48 +0000
Message-ID: <SN1PR05MB2317EA24D96CB85D8CBDF33DCC390@SN1PR05MB2317.namprd05.prod.outlook.com>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
	<20160630220737.GS12670@dastard>	,
	<BFF5CB1A-BA65-4212-9607-2F25F427433B@animezone.org>
	<SN1PR05MB23179FAACBDA0B885FE11D06CC250@SN1PR05MB2317.namprd05.prod.outlook.com>,
	<1467401339.7631.221.camel@filmlight.ltd.uk>
In-Reply-To: <1467401339.7631.221.camel@filmlight.ltd.uk>
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
Content-Type: multipart/mixed; boundary="===============4088481683207692496=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Roger Willcocks <roger@filmlight.ltd.uk>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4088481683207692496==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_SN1PR05MB2317EA24D96CB85D8CBDF33DCC390SN1PR05MB2317namp_"

--_000_SN1PR05MB2317EA24D96CB85D8CBDF33DCC390SN1PR05MB2317namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Yes so no luck yet. Even specifying the block size as 24576.

But I did come across something interesting. I decided to give up on these =
tapes and try out some other ones. One tape in particular was listed as an =
Amanda dump file. upon researching I came across a page labeled Amanda Chea=
t Sheet. http://www.mast.queensu.ca/computing/department/service.catalogue/=
backup/cheat-sheet.html

On that site there is a section talking about XFS file systems, SGI, and re=
storing them using Amanda + xfsrestore. Ill give this a shot I just got to =
figure out how to use Amanda on a local machine.

Does anyone think this may be my problem, and or any advice?
Thanks.

--_000_SN1PR05MB2317EA24D96CB85D8CBDF33DCC390SN1PR05MB2317namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;back=
ground-color:#FFFFFF;font-family:Calibri,Arial,Helvetica,sans-serif;">
<p><span style=3D"font-size: 10pt;">Yes so no luck yet. Even specifying the=
 block size as</span><span style=3D"font-size: 10pt;">
</span><font size=3D"2"><span style=3D"font-size: 10pt;">24576.</span></fon=
t></p>
<p><font size=3D"2"><span style=3D"font-size:10pt;"><span style=3D"font-siz=
e: 10pt;">But I did come ac</span><span style=3D"font-size: 10pt;">ro</span=
><span style=3D"font-size: 10pt;">ss something i</span><span style=3D"font-=
size: 10pt;">nteresting. I decided to give up
 on </span><span style=3D"font-size: 10pt;">t</span><span style=3D"font-siz=
e: 10pt;">hese tapes and try out some ot</span><span style=3D"font-size: 10=
pt;">her ones</span><span style=3D"font-size: 10pt;">.</span><span style=3D=
"font-size: 10pt;"> One tape
</span><span style=3D"font-size: 10pt;">in particular</span><span style=3D"=
font-size: 10pt;">
</span><span style=3D"font-size: 10pt;">was listed a</span><span style=3D"f=
ont-size: 10pt;">s an
</span><span style=3D"font-size: 10pt;">Amanda</span><span style=3D"font-si=
ze: 10pt;"> dump file.
</span><span style=3D"font-size: 10pt;">upon researchi</span><span style=3D=
"font-size: 10pt;">ng I came across a page
</span><span style=3D"font-size: 10pt;">labeled</span><span style=3D"font-s=
ize: 10pt;">
</span><span style=3D"font-size: 10pt;">Amanda</span><span style=3D"font-si=
ze: 10pt;">
</span><span style=3D"font-size: 10pt;">Cheat</span><span style=3D"font-siz=
e: 10pt;"> Sheet</span><span style=3D"font-size: 10pt;">.
</span><a id=3D"LPlnk963857" href=3D"http://www.mast.queensu.ca/computing/d=
epartment/service.catalogue/backup/cheat-sheet.html" class=3D"OWAAutoLink">=
<span style=3D"font-size: 10pt;">http://www.mast.queensu.ca/computing/depar=
tment/service.catalogue/backup/cheat-sheet.html</span></a></span></font></p=
>
<p><font size=3D"2"><span style=3D"font-size:10pt;"><span style=3D"font-siz=
e: 10pt;">On that site there is a section talking about XFS file
</span><span style=3D"font-size: 10pt;">syste</span><span style=3D"font-siz=
e: 10pt;">ms, SGI,</span><span style=3D"font-size: 10pt;"> and restor</span=
><span style=3D"font-size: 10pt;">ing them using</span><span style=3D"font-=
size: 10pt;">
</span><span style=3D"font-size: 10pt;">Amanda</span><span style=3D"font-si=
ze: 10pt;"> &#43; xfsrestore</span><span style=3D"font-size: 10pt;">.</span=
><span style=3D"font-size: 10pt;"> Ill give this a shot
</span><span style=3D"font-size: 10pt;">I just got to figure out how to use=
 </span>
<span style=3D"font-size: 10pt;">Amanda</span><span style=3D"font-size: 10p=
t;"> on a local machi</span><span style=3D"font-size: 10pt;">ne.
</span><br>
</span></font><span style=3D"font-size: 10pt;"></span></p>
<span style=3D"font-size: 10pt;"></span>
<div style=3D"color: rgb(0, 0, 0);"><font size=3D"2"><span style=3D"font-si=
ze:10pt;"><span style=3D"font-size: 10pt;"></span>
<div class=3D"PlainText"><br>
<span style=3D"font-size: 10pt;">Does anyone think this may be my problem, =
and or any ad</span><span style=3D"font-size: 10pt;">vice?
</span><br>
Thanks. <br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_SN1PR05MB2317EA24D96CB85D8CBDF33DCC390SN1PR05MB2317namp_--


--===============4088481683207692496==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4088481683207692496==--

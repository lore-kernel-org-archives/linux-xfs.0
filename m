Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34E207CA1
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 11:59:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07E738F8084
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 09:59:07 -0700 (PDT)
Received: from SNT004-OMC4S14.hotmail.com (snt004-omc4s14.hotmail.com
	[65.55.90.217]) by cuda.sgi.com with ESMTP id IdKtTBfAELXEX06v
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 09:59:04 -0700 (PDT)
From: Anthony l <Martinezant2141@live.com>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Date: Thu, 30 Jun 2016 16:59:01 +0000
Message-ID: <SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>,
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
In-Reply-To: <4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
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
Content-Type: multipart/mixed; boundary="===============1319584185262345010=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1319584185262345010==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_SN1PR05MB2317E464B2CFB5A06CC4B66BCC240SN1PR05MB2317namp_"

--_000_SN1PR05MB2317E464B2CFB5A06CC4B66BCC240SN1PR05MB2317namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I don't think this is a multi tape dump. But then again i don't know for su=
re. I recently got a job and this is my first 'project'. I have about 10 ta=
pes each are labeled a month and a year, so I don't think they are multi ta=
pe because they span like 3 years 2004-2007 . Although for the current tape=
 I am working on right now if I select 1 skip, I'll get to another back up =
labeled "incremental backup 1" or something similar. Using the verbosity ou=
tput here is what I got. (also using interactive restore). I went ahead and=
 specified byte size 4096. Through earlier test using the dd command I dete=
rmined that was the correct size. Ill post one without byte size specified =
too. I just saw it in that post and thought it might help.

Here is the output with verbosity.

http://pastebin.com/Nd6BqNc5

The out is the same with or without -b 4096.

http://pastebin.com/0dxbCvyc (no -b)


-Anthony

<http://oss.sgi.com/mailman/listinfo/xfs>

--_000_SN1PR05MB2317E464B2CFB5A06CC4B66BCC240SN1PR05MB2317namp_
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
<p><span style=3D"font-size: 8pt;"><span style=3D"font-size: 10pt;"></span>=
<span style=3D"font-size: 10pt;">I don't think this is a multi tape dump. B=
ut then again i don't know for sure. I recently got a job and this is my fi=
rst 'project'. I have about 10 tapes each
 are labeled a month and a year, so I don't think they are multi tape becau=
se they span like 3 years 2004-2007 . Although for the current tape I am wo=
rking on right now if I select 1 skip, I'll get to another back up labeled =
&quot;incremental backup 1&quot; or something
 similar. Using the verbosity output here is what I got. (also using intera=
ctive restore). I went ahead and specified byte size 4096. Through earlier =
test using the dd command I determined that was the correct size. Ill post =
one without byte size specified
 too. I just saw it in that post and thought it might help.<br>
</span></span></p>
<p><span style=3D"font-size: 8pt;"><span style=3D"font-size: 10pt;"></span>=
</span><font size=3D"2"><span style=3D"font-size:10pt;"></span></font>Here =
is the output with verbosity.
<br>
</p>
<p><a id=3D"LPlnk552761" href=3D"http://pastebin.com/Nd6BqNc5" class=3D"OWA=
AutoLink">http://pastebin.com/Nd6BqNc5</a></p>
<p><span style=3D"font-size: 10pt;">The out is the same with or without -b =
4096. <br>
</span></p>
<p><span style=3D"font-size: 10pt;"></span><a id=3D"LPlnk828460" href=3D"ht=
tp://pastebin.com/0dxbCvyc" class=3D"OWAAutoLink">http://pastebin.com/0dxbC=
vyc</a> (no -b)</p>
<p><br>
</p>
<p>-Anthony<br>
</p>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText"><a href=3D"http://oss.sgi.com/mailman/listinfo/xfs=
"></a></div>
</span></font><font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText"></div>
</span></font>
<div style=3D"color: rgb(0, 0, 0);"><font size=3D"2"><span style=3D"font-si=
ze:10pt;"></span></font></div>
</div>
</body>
</html>

--_000_SN1PR05MB2317E464B2CFB5A06CC4B66BCC240SN1PR05MB2317namp_--


--===============1319584185262345010==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1319584185262345010==--

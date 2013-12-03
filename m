Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAEC57F4E
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 14:55:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5C62304084
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 12:55:46 -0800 (PST)
Received: from mail-ea0-f174.google.com (mail-ea0-f174.google.com
	[209.85.215.174]) by cuda.sgi.com with ESMTP id
	fSP6HFbIHMQCclZE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 12:55:44 -0800 (PST)
Received: by mail-ea0-f174.google.com with SMTP id b10so10158378eae.33
	for <xfs@oss.sgi.com>; Tue, 03 Dec 2013 12:55:43 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <yangsuli@gmail.com>
Date: Tue, 3 Dec 2013 14:55:23 -0600
Message-ID: <CABK4GYMABHhU-afrgViOU0s4cpks7mGZ-dYoB7iFAmq-SZAX=A@mail.gmail.com>
Subject: XFS journal documentation?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0235511863665568038=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0235511863665568038==
Content-Type: multipart/alternative; boundary=001a11c2902212c2e604eca785d1

--001a11c2902212c2e604eca785d1
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I am trying to understand XFS a little bit better, especially its journal
process. Unfortunately, I am having trouble find documentation in this
regard.

The general XFS documentation (
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html)
has been quite helpful, but it doesn't describe the journal part of XFS. I
also found some kernel documentation ablout XFS's delayed logging (
https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logging-design.txt),
which talks about the journal process a bit. But it seems to assume a lot
of prior knowledge of how the original XFS logging works to completely
understand what the author is talking about; and the term it uses (like
checkpoint) seem to have complete different meaning from, say, ext4.

So I am wondering, is there some kind of (any kind of ) documentation on
XFS journaling? Ideally it will cover the major data structure and major
code flow, but even a very high level, incomplete overview would be better
than what I have now, which is essentially nothing. And if so, where can I
find it?

Thanks a lot!

Suli

-- 
Suli Yang

Department of Physics
University of Wisconsin Madison

4257 Chamberlin Hall
Madison WI 53703

--001a11c2902212c2e604eca785d1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I am trying to understand XFS a lit=
tle bit better, especially its journal process. Unfortunately, I am having =
trouble find documentation in this regard.=A0</div><div><br></div><div>The =
general XFS documentation (<a href=3D"http://xfs.org/docs/xfsdocs-xml-dev/X=
FS_Filesystem_Structure//tmp/en-US/html/index.html">http://xfs.org/docs/xfs=
docs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html</a>) has b=
een quite helpful, but it doesn&#39;t describe the journal part of XFS. I a=
lso found some kernel documentation ablout XFS&#39;s delayed logging (<a hr=
ef=3D"https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logg=
ing-design.txt">https://www.kernel.org/doc/Documentation/filesystems/xfs-de=
layed-logging-design.txt</a>), which talks about the journal process a bit.=
 But it seems to assume a lot of prior knowledge of how the original XFS lo=
gging works to completely understand what the author is talking about; and =
the term it uses (like checkpoint) seem to have complete different meaning =
from, say, ext4.=A0</div>

<div><br></div><div>So I am wondering, is there some kind of (any kind of )=
 documentation on XFS journaling? Ideally it will cover the major data stru=
cture and major code flow, but even a very high level, incomplete overview =
would be better than what I have now, which is essentially nothing. And if =
so, where can I find it?</div>

<div><br></div><div>Thanks a lot!</div><div><br></div><div>Suli<br clear=3D=
"all"><div><br></div>-- <br>Suli Yang<br><br>Department of Physics<br>Unive=
rsity of Wisconsin Madison<br><br>4257 Chamberlin Hall<br>Madison WI 53703<=
br>

<br>
</div></div>

--001a11c2902212c2e604eca785d1--


--===============0235511863665568038==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0235511863665568038==--

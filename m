Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F22AD7F3F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 05:07:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0CFE304032
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 03:07:18 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	QqARovaUEWTAk4nN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 03:07:17 -0700 (PDT)
Received: by mail-wi0-f172.google.com with SMTP id hn9so5140837wib.17
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 03:07:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Sep 2013 18:07:16 +0800
Message-ID: <CADZE9xxjLAXW6_G0qB9chJW=1Xxuj4G8GzAMDS+HT0u8PE=A1w@mail.gmail.com>
Subject: Thanks for this great filesystem, I encounter a problem in using XFS
	project quota.
From: Jex Lin <jex_lin@miiicasa.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7656342536643270330=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7656342536643270330==
Content-Type: multipart/alternative; boundary=001a11c38462fe3a5b04e7326a6d

--001a11c38462fe3a5b04e7326a6d
Content-Type: text/plain; charset=ISO-8859-1

OS : ubuntu 13.04
xfsprogs version : 3.1.9
xfsdump version : 3.1.1

------------------------------------------------------------

In this case :

There are three folders (A, B and C) in XFS filesystem.
I set quota to A and B folder, C folder doesn't  be set quota.

The report of A folder is correct when I moved file to B folder from A
folder,
but when I move file to C folder from A folder, the report of A folder has
wrong display with used.

Capacity of the file still be added in "used" of report of A folder.

Any help would be very appreciated.

Best regards,

Jex Lin

--001a11c38462fe3a5b04e7326a6d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>OS : ubuntu 13.04</div><div>xfsprogs version : 3.1.9<=
/div><div>xfsdump version : 3.1.1</div><div><br></div><div>----------------=
--------------------------------------------</div><div><br></div><div>In th=
is case :</div>
<div><br></div><div>There are three folders (A, B and C) in XFS filesystem.=
</div><div>I set quota to A and B folder, C folder doesn&#39;t =A0be set qu=
ota.=A0</div><div><br></div><div>The report of A folder is correct when I m=
oved file to B folder from A folder,=A0</div>
<div>but when I move file to C folder from A folder, the report of A folder=
 has wrong display with used.</div><div><br></div><div>Capacity of the file=
 still be added in &quot;used&quot; of report of A folder.</div><div><br>
</div><div>Any help would be very appreciated.</div><div><br></div><div>Bes=
t regards,</div><div><br></div><div>Jex Lin</div></div>

--001a11c38462fe3a5b04e7326a6d--


--===============7656342536643270330==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7656342536643270330==--

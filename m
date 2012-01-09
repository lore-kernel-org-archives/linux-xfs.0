Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q09IEPRT031444 for <xfs@oss.sgi.com>; Mon, 9 Jan 2012 12:14:25 -0600
Received: from mail-tul01m020-f181.google.com (mail-tul01m020-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	MajXTVQb1YVwv0pD for <xfs@oss.sgi.com>;
	Mon, 09 Jan 2012 10:14:23 -0800 (PST)
Received: by obbup6 with SMTP id up6so4892902obb.26
	for <xfs@oss.sgi.com>; Mon, 09 Jan 2012 10:14:23 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Jan 2012 19:14:23 +0100
Message-ID: <CAPPqfY1DOesJGfpZfnukr6PGo-KsGQ3u3tnF8UdVTZgWn2=HKA@mail.gmail.com>
Subject: Get file using a specific sector number
From: Olivier Doucet <webmaster@ajeux.com>
Reply-To: olivier@ajeux.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3656443161779291394=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3656443161779291394==
Content-Type: multipart/alternative; boundary=f46d04446a6d3e0c7604b61c5e18

--f46d04446a6d3e0c7604b61c5e18
Content-Type: text/plain; charset=ISO-8859-1

Hello everyone,

I'm actually using xfsprogs quite heavily and I'm stuck with one problem :

I have a sector number and I want to know which file is using it. xfs_bmap
does exactly the opposite (give sector number for a specific file), but I
cannot find how to do it the other way.
I made several attempts with xfs_db but cannot find how to do it properly.
Moreover, I need to do it on a mounted filesystem (RW), and xfs_db does not
seem very friendly about that ...

Any help would be much appreciated.

Thank you,

Olivier

--f46d04446a6d3e0c7604b61c5e18
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello everyone,<div><br></div><div>I&#39;m actually using xfsprogs quite he=
avily and I&#39;m stuck with one problem :=A0</div><div><br></div><div>I ha=
ve a sector number and I want to know which file is using it. xfs_bmap does=
 exactly the opposite (give sector number for a specific file), but I canno=
t find how to do it the other way.<br>
I made several attempts with xfs_db but cannot find how to do it properly. =
Moreover, I need to do it on a mounted filesystem (RW), and xfs_db does not=
 seem very friendly about that ...</div><div><br></div><div>Any help would =
be much appreciated.<br>
<br>Thank you,</div><div><br></div><div>Olivier</div><div><br></div>

--f46d04446a6d3e0c7604b61c5e18--


--===============3656443161779291394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3656443161779291394==--

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AFBsRM172883 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 10:11:54 -0500
Received: from psmtp.com (na3sys009aog127.obsmtp.com [74.125.149.107]) by
	cuda.sgi.com with SMTP id BK3JatMnKYv7ED5G for
	<xfs@oss.sgi.com>; Tue, 10 Apr 2012 08:11:53 -0700 (PDT)
Received: by lbok13 with SMTP id k13so2367564lbo.3
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 08:11:51 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 11:11:51 -0400
Message-ID: <CAFcHYYCoVOUOhzoeY1y576gRQzROMjQVDefa0iBF_fcCk0WFXw@mail.gmail.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1518 of file
	fs/xfs/xfs_alloc.c.
From: Robert Bennett <rbennett@mail.crawford.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8209222774283516866=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8209222774283516866==
Content-Type: multipart/alternative; boundary=f46d04426bd6d76d1b04bd548a4a

--f46d04426bd6d76d1b04bd548a4a
Content-Type: text/plain; charset=ISO-8859-1

I am new to this mailing list, so please forgive me if my protocol is not
polished.

The XFS performance is phenomenal for our use case.  The question(s) is
what can be done to mitigate this issue.  The particulars are as follows:
OS = RedHat Linux 6.2
LVM2
DRBD synching between two Super Micro Head Nodes
~ 35TB
Hardware RAID = LSI
XFS created with default settings

Thanks for any help.

-bob

--f46d04426bd6d76d1b04bd548a4a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I am new to this mailing list, so please forgive me if my protocol is not p=
olished.=A0 <br><br>The XFS performance is phenomenal for our use case.=A0 =
The question(s) is what can be done to mitigate this issue.=A0 The particul=
ars are as follows:<br>
OS =3D RedHat Linux 6.2<br>LVM2<br>DRBD synching between two Super Micro He=
ad Nodes<br>~ 35TB<br>Hardware RAID =3D LSI<br>XFS created with default set=
tings<br><br>Thanks for any help.<br><br>-bob<br>

--f46d04426bd6d76d1b04bd548a4a--


--===============8209222774283516866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8209222774283516866==--

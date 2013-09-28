Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 119527F4E
	for <xfs@oss.sgi.com>; Sat, 28 Sep 2013 07:36:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2D868F8035
	for <xfs@oss.sgi.com>; Sat, 28 Sep 2013 05:36:00 -0700 (PDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id pArhjjpLszyZ5zHq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 28 Sep 2013 05:35:59 -0700 (PDT)
Received: by mail-wg0-f48.google.com with SMTP id n12so3733023wgh.3
	for <xfs@oss.sgi.com>; Sat, 28 Sep 2013 05:35:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 28 Sep 2013 18:05:58 +0530
Message-ID: <CAMRGQbO4ojkim_fwEYUznMW0MGFPeALW-xPFg8u2Ky7ZR6xBLQ@mail.gmail.com>
Subject: Xfs options for small files
From: Ram Chander <ramquick@gmail.com>
Reply-To: ram_chander250@yahoo.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0380513134933489126=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0380513134933489126==
Content-Type: multipart/alternative; boundary=047d7bb048224fad2004e770d866

--047d7bb048224fad2004e770d866
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I have millions of small files of size ranging 2kb - 50kb  stored in
hundreds of dir.
Total size is around 2Tb.  Xfs runs on top of LVM.  Existing files wont
grown and wont be overwritten.
Lots of new small files will be created and there will be lot  of read
operations.

Can someone shed light on optimal  format options and mount options.
Many  thanks .


Regards,
Ram

--047d7bb048224fad2004e770d866
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>Hi,<br><br></div>I have millions =
of small files of size ranging 2kb - 50kb=A0 stored in hundreds of dir.<br>=
</div><div>Total size is around 2Tb.=A0 Xfs runs on top of LVM.=A0 Existing=
 files wont grown and wont be overwritten. <br>
Lots of new small files will be created and there will be lot=A0 of read op=
erations.<br></div><div><br></div>Can someone shed light on optimal=A0 form=
at options and mount options. <br></div>Many=A0 thanks .<br><br><br></div>R=
egards, <br>
</div>Ram<br></div>

--047d7bb048224fad2004e770d866--


--===============0380513134933489126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0380513134933489126==--

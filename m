Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAB5XipO022105 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 23:33:44 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4119116D2FB
	for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 21:35:12 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id B6UnxgFSL7Gyl6Fm
	for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 21:35:12 -0800 (PST)
Received: by qwd6 with SMTP id 6so758384qwd.26
	for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 21:35:12 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Nov 2010 11:05:12 +0530
Message-ID: <AANLkTinsus+r4p6122hZwHupoQ7sXimGTpnwiTYmKVKC@mail.gmail.com>
Subject: Testcase and guide to XFS log corruption issues.
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4144290646522841153=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4144290646522841153==
Content-Type: multipart/alternative; boundary=20cf300fb39f7a04ad0494c056ef

--20cf300fb39f7a04ad0494c056ef
Content-Type: text/plain; charset=ISO-8859-1

Dear,
I have been facing problems due to virtually index caches that causes XFS
log corruption, and in some cases it corrupted on disk data itself.
Since the stability of XFS is very much dependent on integrity of log, I
wish to make testcase and offer guide to detect XFS log corruption issues.
If there is already a procedure or tool to check these issues then I will be
glad if you can share you knowledge with us.

With Regards,
Ajeet Yadav

--20cf300fb39f7a04ad0494c056ef
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dear,<div>I have been facing problems due to virtually index caches that ca=
uses XFS log corruption, and in some cases it corrupted on disk data itself=
.</div><div>Since the stability of XFS is very much dependent on integrity =
of log,=A0I wish to make testcase and offer guide to detect XFS log corrupt=
ion issues.</div>
<div>If there is already a procedure or tool to check these issues then I w=
ill be glad if you can share you knowledge with us.</div><div><br></div><di=
v>With Regards,</div><div>Ajeet Yadav</div><div><br></div><div><br></div>

--20cf300fb39f7a04ad0494c056ef--


--===============4144290646522841153==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4144290646522841153==--

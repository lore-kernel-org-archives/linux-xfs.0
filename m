Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 43C617F50
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 01:08:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2354E8F8037
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2015 23:08:37 -0700 (PDT)
Received: from mail-qg0-f44.google.com (mail-qg0-f44.google.com
	[209.85.192.44]) by cuda.sgi.com with ESMTP id VLX5oZenf8HBTpIu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jul 2015 23:08:33 -0700 (PDT)
Received: by qget71 with SMTP id t71so64829804qge.2
	for <xfs@oss.sgi.com>; Sun, 05 Jul 2015 23:08:33 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Jul 2015 11:38:32 +0530
Message-ID: <CAMcfJ7vDCNo138qnUJ8O0ZDYxgh9k8rgFUoTN3mKcY-SiMWrzA@mail.gmail.com>
Subject: regarding journaling mode
From: Rakesh Patel <patelrakeshcomp@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7695178515767742290=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7695178515767742290==
Content-Type: multipart/alternative; boundary=001a11355a0c432c36051a2ebcbb

--001a11355a0c432c36051a2ebcbb
Content-Type: text/plain; charset=UTF-8

Hi,

I come to know XFS is using writeback journaling mode. As per the
journaling guide, writeback is unsafe which does not preserve data and
metadata write synchronization.

I really want to know reason behind to choose writeback mode for journaling
in XFS.



Thanks.
Regards,
Rakesh

--001a11355a0c432c36051a2ebcbb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hi,<br><br></div>I come to know XFS is=
 using writeback journaling mode. As per the journaling guide, writeback is=
 unsafe which does not preserve data and metadata write synchronization. <b=
r><br></div>I really want to know reason behind to choose writeback mode fo=
r journaling in XFS.<br><br><br><br></div><div>Thanks.<br></div>Regards,<br=
></div>Rakesh <br></div>

--001a11355a0c432c36051a2ebcbb--


--===============7695178515767742290==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7695178515767742290==--

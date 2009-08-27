Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RCe2iu087893 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 07:40:13 -0500
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00343403486
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 05:40:49 -0700 (PDT)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.150])
	by cuda.sgi.com with ESMTP id GllzxYi1xoGQ6m4X for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 05:40:49 -0700 (PDT)
Received: by ey-out-1920.google.com with SMTP id 5so214106eyb.22
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 05:40:47 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 27 Aug 2009 14:40:47 +0200
Message-ID: <76f36dd60908270540ja50b56ct9c47667934ba9f50@mail.gmail.com>
Subject: Problem with xfs
From: Damian Wolski <damian.wolski@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5053068283991208776=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5053068283991208776==
Content-Type: multipart/alternative; boundary=00504502c5ec739ef504721ee06c

--00504502c5ec739ef504721ee06c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

I have problem with *xfs_bmbt_ptr_t* from *xfs_dinode_t* structure. I don't
know how to interprete *filesystem block number* (i use documentation from
http://oss.sgi.com/projects/xfs/papers/xfs_filesystem_structure.pdf , page
34).

In detail

I have b-tree extent list -> i read some informations about this b-tree (so
i have filesystem block number)
How can i allocate block from *filesystem block number?*

Regards
Damian

--00504502c5ec739ef504721ee06c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello.<br><br>I have problem with <b>xfs_bmbt_ptr_t</b> from <b>xfs_dinode_=
t</b> structure. I don&#39;t know how to interprete <b>filesystem block num=
ber</b> (i use documentation from <a href=3D"http://oss.sgi.com/projects/xf=
s/papers/xfs_filesystem_structure.pdf">http://oss.sgi.com/projects/xfs/pape=
rs/xfs_filesystem_structure.pdf</a> , page 34).<br>
<br>In detail<br><br>I have b-tree extent list -&gt; i read some informatio=
ns about this b-tree (so i have filesystem block number)<br>How can i alloc=
ate block from <b>filesystem block number?</b><br><br>Regards<br>Damian<br>

--00504502c5ec739ef504721ee06c--


--===============5053068283991208776==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5053068283991208776==--

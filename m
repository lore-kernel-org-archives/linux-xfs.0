Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8R7HmWP016661
	for <linux-xfs@oss.sgi.com>; Tue, 27 Sep 2011 02:17:49 -0500
Received: from smtpauth.rollernet.us (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32AEB1C477C0
	for <linux-xfs@oss.sgi.com>; Tue, 27 Sep 2011 00:17:46 -0700 (PDT)
Received: from smtpauth.rollernet.us (smtpauth.rollernet.us [208.79.240.5]) by
	cuda.sgi.com with ESMTP id YcSUy6TdXtRFskTu for
	<linux-xfs@oss.sgi.com>; Tue, 27 Sep 2011 00:17:46 -0700 (PDT)
Received: from smtpauth.rollernet.us (localhost [127.0.0.1])
	by smtpauth.rollernet.us (Postfix) with ESMTP id BEAA8594055
	for <linux-xfs@oss.sgi.com>; Tue, 27 Sep 2011 00:17:29 -0700 (PDT)
Received: from [192.168.1.104] (balticom-152-203.balticom.lv [83.99.152.203])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtpauth.rollernet.us (Postfix) with ESMTPSA
	for <linux-xfs@oss.sgi.com>; Tue, 27 Sep 2011 00:17:28 -0700 (PDT)
Message-ID: <4E817895.6030103@11.lv>
Date: Tue, 27 Sep 2011 07:17:41 +0000
From: =?UTF-8?B?S8SBcmxpcyBSZXBzb25z?= <k@11.lv>
MIME-Version: 1.0
Subject: question about XATTRS of symlinks in Linux
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

Could you let me know if there is any way to attach extended attributes
to symlinks in Linux or why shouldn't it be done? I'm considering to
write some additions for ext filesystem modules with aim of providing
Linux with a capability to identify and sign *all* objects in filesystem
for later identification... That, of course, includes symlinks...
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6BeJQACgkQHuSu329e3GG3fgCg4LHjUqlrXSoJQMkLGrA3Iy34
6OEAn2V/46CDcV3SSfDqh1vj4J4JP4SL
=+SO3
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4J7oLKS035782 for <xfs@oss.sgi.com>; Tue, 19 May 2009 02:50:22 -0500
Received: from mail.gware.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 713D319E363F
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 00:50:30 -0700 (PDT)
Received: from mail.gware.it ([80.94.126.121]) by cuda.sgi.com with SMTP id
	HojCwDQkrm6kvwP5 for <xfs@oss.sgi.com>;
	Tue, 19 May 2009 00:50:30 -0700 (PDT)
Message-ID: <005e01c9d856$7a89d450$ae00a8c0@ferroamd64>
From: "Alessandro Ferrari" <alexferro@tiscali.it>
Subject: compilation error xfs_fsr.c:33:23 sys/xattr.h: No such file or
	directory
Date: Tue, 19 May 2009 09:50:28 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Linux kernel 2.4.37

I have downloaded:
- acl_2.2.47-1.tar.gz
- attr_2.4.43-1.tar.gz
- xfsprogs-3.0.1-tar.gz
- xfsdump-3.0.1-tar.gz

I compiled and installed this tarballs in this order:
- acl_2.2.47-1
- attr_2.4.43-1

Now I have this error when I compile xfsprogs-3.0.1:

xfs_fsr.c:33:23: sys/xattr.h: No such file or directory

I have forgotten something?

Thanks, alexferro

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4JA1Lrn039150 for <xfs@oss.sgi.com>; Tue, 19 May 2009 05:01:21 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74486296136
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 03:01:30 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.177]) by cuda.sgi.com with ESMTP id
	O4Q5wJMk4kE9jh0A for <xfs@oss.sgi.com>;
	Tue, 19 May 2009 03:01:30 -0700 (PDT)
Date: Tue, 19 May 2009 03:01:30 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: compilation error xfs_fsr.c:33:23 sys/xattr.h: No such file or
	directory
In-Reply-To: <005e01c9d856$7a89d450$ae00a8c0@ferroamd64>
Message-ID: <alpine.DEB.2.01.0905190256030.8681@bogon.housecafe.de>
References: <005e01c9d856$7a89d450$ae00a8c0@ferroamd64>
MIME-Version: 1.0
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
To: Alessandro Ferrari <alexferro@tiscali.it>
Cc: xfs@oss.sgi.com

On Tue, 19 May 2009, Alessandro Ferrari wrote:
> Now I have this error when I compile xfsprogs-3.0.1:
> xfs_fsr.c:33:23: sys/xattr.h: No such file or directory

sys/xattr.h should be part of a libc6-dev (or glibc-headers) package your 
distribution provides, I think.

Christian.
-- 
SHA = "Schneier has access"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

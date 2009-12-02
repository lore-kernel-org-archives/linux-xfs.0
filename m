Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB22dSq8193484
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 20:39:28 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C80AC43AE
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 18:39:57 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id F5vFw0AJ5CY0GNXH for
	<linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 18:39:57 -0800 (PST)
Date: Wed, 2 Dec 2009 13:39:51 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1930278763.848341259721591215.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <hf4hs7$1ks$1@ger.gmane.org>
Subject: Re: Does xfs automatically support acl without needing a
	mount/fstab option?
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
To: mlueck@lueckdatasystems.com
Cc: linux-xfs@oss.sgi.com


----- "Michael Lueck" <mlueck@lueckdatasystems.com> wrote:

> Greetings-
> 
> I am seeing directories on xfs partitions with the + at the end of the
> perms list indicating there is an ACL associated with that particular
> directory.
> 
> With xfs, is it not necessary to specify in fstab that ACL support is
> desired?

Not necessary.

> Is it automatically enabled?

Yes, its always enabled.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

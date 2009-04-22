Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3MJ8K2m219259 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 14:08:21 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF4291CDD316
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 12:08:16 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id EG1LN59a4MEcZHyy for
	<xfs@oss.sgi.com>; Wed, 22 Apr 2009 12:08:16 -0700 (PDT)
Date: Wed, 22 Apr 2009 15:08:16 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] make lazy-count=1 the default
Message-ID: <20090422190816.GZ3709@josefsipek.net>
References: <49EE3EDD.1090305@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EE3EDD.1090305@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Apr 21, 2009 at 04:47:09PM -0500, Eric Sandeen wrote:
> If folks think it's been out there long enough, let's make
> lazy-count=1 the mkfs default going forward?
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Sounds good!

It may be worth mentioning the kernel version that introduced lazy-count in
the manpage.

Josef 'Jeff' Sipek.

-- 
It used to be said [...] that AIX looks like one space alien discovered
Unix, and described it to another different space alien who then implemented
AIX. But their universal translators were broken and they'd had to gesture a
lot.
		- Paul Tomblin 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

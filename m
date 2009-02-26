Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1Q14YlY236012 for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 19:04:35 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F41A19AB98F
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 17:04:04 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id 2p6AzzwHvoytUPuU for
	<xfs@oss.sgi.com>; Wed, 25 Feb 2009 17:04:04 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Wed, 25 Feb 2009 20:03:29 -0500
References: <200902240010.25434.vapier@gentoo.org>
	<200902241845.27249.vapier@gentoo.org>
	<200902260126.14606.agruen@suse.de>
In-Reply-To: <200902260126.14606.agruen@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902252003.32646.vapier@gentoo.org>
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
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wednesday 25 February 2009 19:26:14 Andreas Gruenbacher wrote:
> On Wednesday, 25 February 2009 0:45:25 Mike Frysinger wrote:
> > and for attr.git:
> > http://sources.gentoo.org/sys-apps/attr/files/attr-2.4.39-gettext.patch
>
> This functionality already exists (in both the acl and attr packages).

was this in the last release (2.4.43) ?  either way, can you highlight the 
code you're referring to so there's no confusion on my part ;)
-mike

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

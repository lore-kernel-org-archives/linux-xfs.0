Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1Q0RNlp234593 for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 18:27:24 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D80019AC095
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 16:26:54 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id NAcXHuD4DbKB9Npz for <xfs@oss.sgi.com>;
	Wed, 25 Feb 2009 16:26:54 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Thu, 26 Feb 2009 01:26:14 +0100
References: <200902240010.25434.vapier@gentoo.org>
	<200902242322.48314.agruen@suse.de>
	<200902241845.27249.vapier@gentoo.org>
In-Reply-To: <200902241845.27249.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902260126.14606.agruen@suse.de>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wednesday, 25 February 2009 0:45:25 Mike Frysinger wrote:
> is this mailing list still going to be used for acl/attr ?

I would like to keep the discussion here until the packages have found a final 
new location, if SGI won't mind.

> here are the patches i have for acl.git:
> http://sources.gentoo.org/sys-apps/acl/files/acl-2.2.45-libtool.patch

Added.

> http://sources.gentoo.org/sys-apps/acl/files/acl-2.2.45-linguas.patch

Added.

> and for attr.git:
> http://sources.gentoo.org/sys-apps/attr/files/attr-2.4.39-gettext.patch

This functionality already exists (in both the acl and attr packages).

> http://sources.gentoo.org/sys-apps/attr/files/attr-2.4.43-linguas.patch

Added.

Thanks, Mike!

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

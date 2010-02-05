Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o159bO4H126036 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 03:37:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8080A1830D36
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 01:38:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id G2ZSClIsLqZba2im for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 01:38:35 -0800 (PST)
Date: Fri, 5 Feb 2010 04:38:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: rename _acl_requirements to _require_acls
Message-ID: <20100205093835.GC14508@infradead.org>
References: <4B69EC23.8040207@sandeen.net> <4B69ED6D.6030902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B69ED6D.6030902@sandeen.net>
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

On Wed, Feb 03, 2010 at 03:41:01PM -0600, Eric Sandeen wrote:
> Most requirement tests are named _require_foo, so just
> make this more consistent.
> 
> Also remove a few redundant tests for /usr/bin/chacl
> since _require_acls covers that.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

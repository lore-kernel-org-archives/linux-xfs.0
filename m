Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n31798fm056891 for <xfs@oss.sgi.com>; Wed, 1 Apr 2009 02:09:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6F6213E48C8
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2009 00:09:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7PqwkGmTfpsPRlTu for
	<xfs@oss.sgi.com>; Wed, 01 Apr 2009 00:09:16 -0700 (PDT)
Date: Wed, 1 Apr 2009 03:08:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstests: make the mode consistent for all the
	test scripts
Message-ID: <20090401070823.GA3044@infradead.org>
References: <1238536234-26969-1-git-send-email-jsipek@eecs.umich.edu>
	<1238536234-26969-2-git-send-email-jsipek@eecs.umich.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1238536234-26969-2-git-send-email-jsipek@eecs.umich.edu>
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
To: Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com

A consistant mode sounds fine to me, but we'd have to pull this in as
git-pull not as patch, right?

Also for some reason some modes seem to change when actually running
xfstests which makes git barf when pulling into such a tree again, not
sure where that comes from.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

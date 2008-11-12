Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:42:18 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9gBdM032037
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:42:11 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EC8A154ABAD
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:42:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 4u06k4A97v7XwS6m for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:42:11 -0800 (PST)
Date: Wed, 12 Nov 2008 04:42:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfstest: confirm mkfs.gfs[2] in test 032
Message-ID: <20081112094211.GA9944@infradead.org>
References: <490C801E.9070405@sandeen.net> <490CABAE.2070402@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490CABAE.2070402@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Nov 01, 2008 at 02:19:10PM -0500, Eric Sandeen wrote:
> mkfs.gfs[2] asks for confirmation before mkfs'ing; without
> this test 032 hangs when mkfs.gfs2 is present.
> 
> Also, mkfs.gfs needs a few more args to make it go.

Looks good.

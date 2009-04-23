Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHGvWj016640 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:16:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5152236C41
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:16:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KhP4IRrH3DP3OCQY for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:16:55 -0700 (PDT)
Date: Thu, 23 Apr 2009 13:16:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] make lazy-count=1 the default
Message-ID: <20090423171654.GD11391@infradead.org>
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

Yes, please put it in just after the 3.0.1 release we'll hopefully
put out ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

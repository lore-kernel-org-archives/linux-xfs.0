Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BHVD3r103225 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 11:31:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CA9AFDB83D
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:33:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iM2WJY1joHBJbZ9s for
	<xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:33:25 -0800 (PST)
Date: Tue, 11 Jan 2011 12:33:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfstests] 243: remove test files before starting
Message-ID: <20110111173325.GA24025@infradead.org>
References: <4D2C7967.2090801@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D2C7967.2090801@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jan 11, 2011 at 09:38:15AM -0600, Eric Sandeen wrote:
> I found that overwriting existing files hides a bug
> in ext4 (since fixed).  Removing the files before
> the test reliably reproduces it.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

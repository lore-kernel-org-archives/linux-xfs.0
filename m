Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SKBQox173388 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 15:11:41 -0500
Date: Fri, 28 Aug 2009 16:12:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: switch to seq_file
Message-ID: <20090828201220.GA17216@infradead.org>
References: <20090828195500.GC15123@x200.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090828195500.GC15123@x200.localdomain>
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
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: hch@infradead.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Fri, Aug 28, 2009 at 11:55:00PM +0400, Alexey Dobriyan wrote:
> create_proc_read_entry() is getting deprecated.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Looks good to me, I'll throw it into my QA queue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

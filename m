Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EHIq7V112645 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 11:18:52 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xzxvQJPU8g3gOVFw for
	<xfs@oss.sgi.com>; Tue, 14 Feb 2012 09:18:50 -0800 (PST)
Message-ID: <4F3A9776.2010108@redhat.com>
Date: Tue, 14 Feb 2012 09:18:46 -0800
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: deprecate the "-F" foreign flag
References: <4F2AC948.1050909@redhat.com> <20120213190028.GA1941@infradead.org>
In-Reply-To: <20120213190028.GA1941@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/13/12 11:00 AM, Christoph Hellwig wrote:
> This actually breaks the following nreak tests 249 and 256 for me, can
> you please look into fixing these ASAP?

argh will do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

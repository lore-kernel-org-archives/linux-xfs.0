Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H7cDFS057610 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 02:38:13 -0500
Date: Tue, 17 Jul 2012 03:38:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: Add pquotaino to on-disk super block
Message-ID: <20120717073811.GC24395@infradead.org>
References: <4FFFDDF8.10401@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FFFDDF8.10401@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Fri, Jul 13, 2012 at 04:36:08PM +0800, Jeff Liu wrote:
> Add pquotaino to on-disk super block. Add a new field to
> the super block to add support for separate pquota with
> a specific version.

Call me stupid, but I can't find where it actually adds the field.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

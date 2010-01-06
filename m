Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06HmBOk099829 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 11:48:11 -0600
Date: Wed, 6 Jan 2010 12:49:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] use time32_t consistently in xfsdump tree
Message-ID: <20100106174902.GA18167@infradead.org>
References: <4B300389.7020905@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B300389.7020905@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

After discussion with Alex I've put both patches into the xfsdump-dev
repository.  I've taken the final version each, with the description
of the initial posting.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

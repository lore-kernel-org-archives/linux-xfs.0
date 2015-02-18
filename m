Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1EADC7F4E
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 11:20:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0DBA38F8037
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 09:20:37 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4JDpcxZaQte5mCuS (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 09:20:36 -0800 (PST)
Date: Wed, 18 Feb 2015 18:20:31 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [Cluster-devel] [PATCH 7/8] xfs: Add support for Q_SETINFO
Message-ID: <20150218172031.GC11951@quack.suse.cz>
References: <1424267274-11836-1-git-send-email-jack@suse.cz>
	<1424267274-11836-8-git-send-email-jack@suse.cz>
	<20150218165412.GC29465@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150218165412.GC29465@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 18-02-15 08:54:12, Christoph Hellwig wrote:
> Looks fine except for the cosmetical argument alignment style issue.
  OK, fixed.
 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

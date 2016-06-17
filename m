Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C88D7CD2
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 10:07:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CF80304048
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 08:06:58 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nNAxiZnZr16SVwAT (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 08:06:56 -0700 (PDT)
Date: Fri, 17 Jun 2016 08:06:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 002/119] vfs: support FS_XFLAG_REFLINK and
	FS_XFLAG_COWEXTSIZE
Message-ID: <20160617150654.GA21627@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612628567.12839.3246258786290141903.stgit@birch.djwong.org>
	<20160617114117.GF19042@infradead.org>
	<20160617121604.GB23661@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617121604.GB23661@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>, vishal.l.verma@intel.com

On Fri, Jun 17, 2016 at 08:16:05AM -0400, Brian Foster wrote:
> I'd take that a step further and suggest the entire series be split into
> independent feature series, as appropriate.

Yes, that's what I meant.  I just didn't manage to get to the rest yet.

> off the rmap bits for the time being. I'm just suggesting that if a
> repost is required from this point forward for any of the logical
> subunits (deps, rmap, reflink, scrub), I'd suggest to post, version and
> changelog those units independently.

Agreed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
